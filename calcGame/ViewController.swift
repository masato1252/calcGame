//
//  ViewController.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/07.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //履歴用テーブルビュー
    @IBOutlet weak var tv_history: UITableView!
    //結果表示用ラベル
    @IBOutlet weak var label_disp: UILabel!

    //右側ボタン
    @IBOutlet weak var btn_sub: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btn_div: UIButton!
    @IBOutlet weak var btn_times: UIButton!
    @IBOutlet weak var btn_clear: UIButton!
    @IBOutlet weak var btn_ac: UIButton!
    
    //左側ボタン
    @IBOutlet weak var btn_9: UIButton!
    @IBOutlet weak var btn_8: UIButton!
    @IBOutlet weak var btn_7: UIButton!
    @IBOutlet weak var btn_6: UIButton!
    @IBOutlet weak var btn_5: UIButton!
    @IBOutlet weak var btn_4: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var btn_0: UIButton!
    @IBOutlet weak var btn_dot: UIButton!
    @IBOutlet weak var btn_eq: UIButton!
    
    //上部メニューボタン
    @IBOutlet weak var btn_clip: UIButton!
    @IBOutlet weak var btn_histDel: UIButton!
    
    //レイアウト
    @IBOutlet weak var layout_btn1: UIStackView!
    @IBOutlet weak var layout_btn2: UIStackView!
    @IBOutlet weak var layout_btn3: UIStackView!
    @IBOutlet weak var layout_btn4: UIStackView!
    @IBOutlet weak var layout_label: UIStackView!
    @IBOutlet weak var layout_upperMenu: UIStackView!
    
    
    private var temp:String = ""  //数値用の一時的な文字列 => 演算子orイコール押下時にnumArrayへ格納
    var dispStr:String = ""   //画面表示向け文字列
    var equation:String = ""  //イコール押下時の数式整形用
    
    var btnArray:[UIButton] = [UIButton]()  //レイアウト一括適用向けボタン配列
    var btnArray2:[UIButton] = [UIButton]() //レイアウト一括適用向けボタン配列2
    
    var numArray:[String] = [String]()  //数字用配列
    var opeArray:[String] = [String]()  //演算子用配列
    
    var historyArray:[HistoryData] = [HistoryData]() //履歴データ用配列
    
    var minusMode:Bool = false  //マイナスの数値が入力されている場合:true, それ以外:false
    var floatMode:Bool = false  //小数の数値が入力されている場合:true, それ以外:false (2つ以上小数を入力させない)
    
    //var savaData:SaveData = SaveData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //数値表示初期化
        dispStr = "0"
        label_disp.text = "0"
        temp = "0"
        
        //履歴テーブルビュー関連
        self.tv_history.delegate = self
        self.tv_history.dataSource = self
        self.tv_history.setContentOffset(
            CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
            animated: false);
        self.tv_history.separatorColor = UIColor.clear
        
        //ボタンの調整
        setButton()
        //レイアウトの調整
        setLayout()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //数字ボタン押下時
    internal func tappedNumKey(sender: UIButton){
        switch sender.tag {
        case 0:
            //0キー
            if(temp=="0"){
                //「0」の時は何もしない
            }else{
                temp += "0"
                dispStr += "0"
                label_disp.text = dispStr
            }
        case 1...9:
            //1~9キー
            if(temp=="0"){
                //「0」の時は一旦ゼロをクリア
                dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                temp.remove(at: temp.index(temp.endIndex, offsetBy: -1))
            }
            
            temp += String("\(sender.tag)")
            dispStr += String("\(sender.tag)")
            label_disp.text = dispStr
            
        case 10:
            //ドットキー
            if(temp.isEmpty || floatMode){
                //演算子直後 or  小数が入力済みの場合何もしない
            }else{
                temp += "."
                dispStr += "."
                label_disp.text = dispStr
                floatMode = true //小数モードON
            }
        default:
            
            break
        }
        
    }
    
    //演算子系ボタン押下時
    internal func tappedOperator(sender: UIButton){
        
        if(temp.isEmpty && numArray.count==0){
            //初期状態
            if(sender.tag != 102){
                //ーキー押下時以外は何もしない
                return
            }
            //ーキー押下時は、マイナスの数値入力を許可させるため、通過OK
        }

        
        switch sender.tag {
            case 100:
                //バックスペースキー
                
                if(temp.isEmpty){
                    //演算子が削除ターゲットとなっている場合、その前の数値を配列から引き出す
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    opeArray.remove(at: opeArray.count-1)
                    temp = numArray[numArray.count-1]
                    numArray.remove(at: numArray.count-1)
                    
                    //最後尾の数値からモード判定
                    decideMode()
                }else{
                    
                    if(temp == "-" && minusMode){
                        //マイナスのみ入力されていれば削除＆モード脱出
                        minusMode = false
                    }else if(temp.substring(from: temp.index(temp.endIndex, offsetBy: -1))=="."){
                        //小数点を削除した時点でモード脱出
                        floatMode = false
                    }
                    
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    temp.remove(at: temp.index(temp.endIndex, offsetBy: -1))
                }

                //配列を全て引き出している、かつ全て削除した場合、「0」を補完
                if(temp.isEmpty && numArray.count==0){
                    dispStr = "0"
                    temp = "0"
                    label_disp.text = dispStr
                }else{
                   label_disp.text = dispStr
                }
            
            case 101:
                //＋キー
                if(temp.isEmpty){
                    //演算子入力（数字待ち）時に演算子入れ替え
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    dispStr += "+"
                    label_disp.text = dispStr
                    temp = ""
                }else if(temp == "-" && minusMode){
                    //マイナスのみ入力されていれば何もしない(数字待ち)
                }else{
                    if(minusMode){
                        minusMode = false
                    }
                    if(floatMode){
                        floatMode = false
                    }
                    numArray.append(temp)
                    opeArray.append("+")
                    dispStr += "+"
                    label_disp.text = dispStr
                    temp = ""
                }
            
            
            case 102:
                //ーキー
                if(temp.isEmpty){
                    //マイナスの数値入力モードへ
                    minusMode = true

                    dispStr += "-"
                    label_disp.text = dispStr
                    temp = "-"
                }else if(temp == "-" && minusMode){
                    //マイナスのみ入力されていれば何もしない(数字待ち)
                }else{
                    if(floatMode){
                        floatMode = false
                    }
                    numArray.append(temp)
                    opeArray.append("-")
                    
                    dispStr += "-"
                    label_disp.text = dispStr
                    temp = ""
                }
            
                
            case 103:
                //×キー
                if(temp.isEmpty){
                    //演算子入力（数字待ち）時に演算子入れ替え
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    dispStr += "×"
                    label_disp.text = dispStr
                    temp = ""
                }else if(temp == "-" && minusMode){
                    //マイナスのみ入力されていれば何もしない(数字待ち)
                }else{
                    if(minusMode){
                        minusMode = false
                    }
                    if(floatMode){
                        floatMode = false
                    }
                    numArray.append(temp)
                    opeArray.append("*")
                    dispStr += "×"
                    label_disp.text = dispStr
                    temp = ""
                }
            

            case 104:
                //÷キー
                if(temp.isEmpty){
                    //演算子入力（数字待ち）時に演算子入れ替え
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    dispStr += "÷"
                    label_disp.text = dispStr
                    temp = ""
                }else if(temp == "-" && minusMode){
                    //マイナスのみ入力されていれば何もしない(数字待ち)
                }else{
                    if(minusMode){
                        minusMode = false
                    }
                    if(floatMode){
                        floatMode = false
                    }
                    numArray.append(temp)
                    opeArray.append("/")
                    dispStr += "÷"
                    label_disp.text = dispStr
                    temp = ""
                }
            
            case 105:
                //AC(全削除)キー
                dispStr = "0"
                temp = "0"
                label_disp.text = dispStr
                numArray.removeAll()
                opeArray.removeAll()
                minusMode = false
                floatMode = false
            
            default:
                break
        }
        
    }
    
    //イコールボタン押下時
    internal func tappedEqualKey(sender: UIButton){
        
        if(!temp.isEmpty && numArray.count>0){
            numArray.append(temp)
            
            //計算式の整形
            var equation:String = ""
            if(atof(numArray[0]) != floor(atof(numArray[0]))){
                equation = numArray[0]
            }else{
                equation = String("\(atof(numArray[0]))")
            }
            for i in 0..<opeArray.count {
                if(atof(numArray[i+1]) != floor(atof(numArray[i+1]))){
                    equation += (opeArray[i] + numArray[i+1])
                }else{
                    equation += (opeArray[i] + String("\(atof(numArray[i+1]))"))
                }
            }
            print(equation)
            //計算式をパースさせ、swift内部で演算させる
            let expression = NSExpression(format: equation)
            let result = expression.expressionValue(with: nil, context: nil) as? NSNumber
            
            //結果が小数時の場合に起きる、微小なズレを丸める
            let r1:NSDecimalNumber = NSDecimalNumber(string: result!.stringValue)
            let behaviors:NSDecimalNumberHandler = NSDecimalNumberHandler(
                roundingMode: NSDecimalNumber.RoundingMode.up,
                scale: 5,
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false)
            let r2:NSDecimalNumber = r1.rounding(accordingToBehavior: behaviors)
            
            //履歴データ配列へ登録
            let histData:HistoryData = HistoryData(dispStr:dispStr, numArray:numArray, opeArray: opeArray)
            historyArray.append(histData)
            tv_history.reloadData()
            tv_history.setContentOffset(
                CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
                animated: false);
            
            //計算結果を画面等へ反映
            dispStr = String("\(r2)")
            label_disp.text = dispStr
            temp = String("\(r2)")
            
            //最後尾の数値からマイナス・小数モードを判定
            decideMode()
            
            //演算関連の配列を初期化
            numArray.removeAll()
            opeArray.removeAll()
        }
    }
    
    //上部メニューボタン押下時
    internal func tappedUpperMenu(sender: UIButton){
        
        switch sender.tag {
        case 200:
            //履歴削除ボタン
            historyArray.removeAll()
            tv_history.reloadData()
            
        case 201:
            //クリップボードにコピーボタン
            //コピー処理
            let board = UIPasteboard.general
            board.setValue(dispStr, forPasteboardType: "public.text")
            
            //アラート表示
            let alert: UIAlertController = UIAlertController(title: "コピー", message: "クリップボードにコピーしました", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        default:
            break
            
        }
        
    }
    
    
    //temp(String)からモード判別
    internal func decideMode() {
        
        //マイナスモード判定
        if(atof(temp)<0){
            minusMode = true
        }else{
            minusMode = false
        }
        //小数モード判定
        if(atof(temp) != floor(atof(temp))){
            floatMode = true
        }else{
            floatMode = false
        }
        
    }
    
    func decimalNumberWithDouble(double: Double) -> NSDecimalNumber {
        let number = double as NSNumber
        return NSDecimalNumber(string: number.stringValue)
    }

    

    //-----------------------
    // TableView for History
    //-----------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    //セルのセット
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.setCell(history: historyArray[indexPath.row], index:indexPath.row)
        
        return cell
    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectData:HistoryData = historyArray[indexPath.row]
        
        //履歴読み込み
        dispStr = selectData.getDispStr()
        label_disp.text = dispStr
        numArray = selectData.getNumArray()
        temp = numArray[numArray.count-1]
        numArray.remove(at: numArray.count-1)
        opeArray = selectData.getOpeArray()
        
        //最後尾の数値からモード判定
        decideMode()
        
        //選択以降の履歴削除
        var max = historyArray.count
        for _ in indexPath.row ..< max {
            historyArray.remove(at: indexPath.row)
            max = historyArray.count
        }
        tv_history.reloadData()
        tv_history.setContentOffset(
            CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
            animated: true);
        
    }

    
    //GameViewControllerから呼び出し・クリア（解放）したボタンの色更新
    func reloadButtonAfterClear(){
        for i in 0...10 {
            
            let tag = btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                //未解放
                btnArray[i].backgroundColor = UIColor.black
                btnArray[i].isEnabled = false
            }else{
                //解放済み
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
                btnArray[i].isEnabled = true
            }
        }
    }
    
    
    //-----------------
    // Setting Context
    //-----------------
    
    //ボタン配置
    internal func setButton() {
        //数値ボタン+イコール（左側）
        btn_1.tag=1
        btnArray.append(btn_1)
        btn_2.tag=2
        btnArray.append(btn_2)
        btn_3.tag=3
        btnArray.append(btn_3)
        btn_4.tag=4
        btnArray.append(btn_4)
        btn_5.tag=5
        btnArray.append(btn_5)
        btn_6.tag=6
        btnArray.append(btn_6)
        btn_7.tag=7
        btnArray.append(btn_7)
        btn_8.tag=8
        btnArray.append(btn_8)
        btn_9.tag=9
        btnArray.append(btn_9)
        btn_0.tag=0
        btnArray.append(btn_0)
        btn_dot.tag=10
        btnArray.append(btn_dot)
        
        btn_eq.tag=999
        btn_eq.addTarget(self, action: #selector(self.tappedEqualKey), for: .touchUpInside)
        btnArray.append(btn_eq)
        
        for i in 0..<btnArray.count-1 {
            btnArray[i].addTarget(self, action: #selector(self.tappedNumKey), for: .touchUpInside)
            btnArray[i].showsTouchWhenHighlighted = true
            
            let tag = (btnArray[i].tag==999) ? 0 : btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                //未解放
                btnArray[i].backgroundColor = UIColor.black
                btnArray[i].isEnabled = false
            }else{
                //解放済み
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
                btnArray[i].isEnabled = true
            }
        }
        
        //演算子＋AC＋BSボタン(右側)
        btn_ac.tag=105
        btnArray2.append(btn_ac)
        btn_clear.tag=100
        btnArray2.append(btn_clear)
        btn_div.tag=104
        btnArray2.append(btn_div)
        btn_times.tag=103
        btnArray2.append(btn_times)
        btn_sub.tag=102
        btnArray2.append(btn_sub)
        btn_add.tag=101
        btnArray2.append(btn_add)
        
        
        for i in 0..<btnArray2.count {
            btnArray2[i].addTarget(self, action: #selector(self.tappedOperator), for: .touchUpInside)
            btnArray2[i].showsTouchWhenHighlighted = true
        }
        
        //上部メニューボタン
        btn_histDel.tag = 200
        btn_histDel.addTarget(self, action: #selector(self.tappedUpperMenu(sender:)), for: .touchUpInside)
        btn_clip.tag = 201
        btn_clip.addTarget(self, action: #selector(self.tappedUpperMenu(sender:)), for: .touchUpInside)
    }
    
    
    
    //レイアウトの詳細設定
    internal func setLayout(){
        
        //------------------
        // レイアウトパラメータ
        //------------------
        //左の数字キーの高さ
        let leftBtnHeight:Int = Int(DeviceSize.screenHeight()/8)
        //左の数字キーの幅
        let leftBtnWidth:Int = Int(DeviceSize.screenWidth()/4)-5
        //左の数字キーの縦マージン
        let marginTop_leftBtn:Int = 5
        
        //演算ボタンの高さ(AC以外)
        let rightBtnHeight:Int = Int(DeviceSize.screenHeight()/11)-5
        //演算ボタンの高さ(ACのみ)
        let rightBtnHeight_ac:Int = Int(DeviceSize.screenHeight()/15)
        //演算ボタンの縦マージン
        let marginTop_rightBtn:Int = 5
        
        //上部メニューの高さ
        let upperMenuHeight:Int = Int(DeviceSize.screenHeight()/20)
        //履歴テーブルビューの高さ
        let historyViewHeight:Int = Int(DeviceSize.screenHeight()/5)
        //計算結果ビューの高さ
        let labelViewHeight:Int = Int(DeviceSize.screenHeight()/9)
        
        
        
        //縦レイアウト制御
        var h_tmp:Int = 0
        layout_upperMenu.translatesAutoresizingMaskIntoConstraints = true
        //layout_upperMenu.frame = CGRect(x:0, y:Int(DeviceSize.statusBarHeight()), width:DeviceSize.screenWidth(), height:upperMenuHeight);
        layout_upperMenu.frame = CGRect(x:0, y:5, width:DeviceSize.screenWidth(), height:upperMenuHeight);
        //h_tmp = Int(DeviceSize.statusBarHeight()) + upperMenuHeight
        h_tmp = 5 + upperMenuHeight
        
        tv_history.translatesAutoresizingMaskIntoConstraints = true
        tv_history.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:historyViewHeight);
        h_tmp += historyViewHeight
        
        layout_label.translatesAutoresizingMaskIntoConstraints = true
        layout_label.backgroundColor = UIColor.black
        layout_label.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:labelViewHeight);
        h_tmp += labelViewHeight + 10
        
        
        layout_btn4.translatesAutoresizingMaskIntoConstraints = true
        layout_btn4.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn3.translatesAutoresizingMaskIntoConstraints = true
        layout_btn3.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn2.translatesAutoresizingMaskIntoConstraints = true
        layout_btn2.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn1.translatesAutoresizingMaskIntoConstraints = true
        layout_btn1.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        
        //数字ボタンレイアウト制御
        var v_tmp:Int = 5
        for i in 0..<btnArray.count {
            let btn:UIButton = btnArray[i]
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.frame = CGRect(x:v_tmp, y:Int(btn.frame.minY), width:leftBtnWidth, height:Int(layout_btn1.frame.size.height))
            
            if((i+1)%3==0){
                v_tmp = 5
            }else{
                v_tmp += (Int(DeviceSize.screenWidth())/4)
            }
        }
        
        //オペレータボタンレイアウト制御
        var v_ope:Int = 0
        var h_ope:Int = 0
        
        v_ope += (Int(DeviceSize.screenWidth())/4)*3 + 5
        h_ope = Int(layout_btn4.frame.minY)
        
        for i in 0..<btnArray2.count {
            let btn_ope:UIButton = btnArray2[i]
            btn_ope.translatesAutoresizingMaskIntoConstraints = true
            if(i==0){
                btn_ope.frame = CGRect(x:v_ope, y:h_ope, width:Int(DeviceSize.screenWidth()/4)-5, height:rightBtnHeight_ac)
                h_ope += rightBtnHeight_ac + marginTop_rightBtn
            }else{
                btn_ope.frame = CGRect(x:v_ope, y:h_ope, width:Int(DeviceSize.screenWidth()/4)-5, height:rightBtnHeight)
                h_ope += rightBtnHeight + marginTop_rightBtn
            }
        }
        
        
        //計算結果ビューのパディング
        label_disp.translatesAutoresizingMaskIntoConstraints = true
        label_disp.frame = CGRect(x:5, y:0, width:Int(DeviceSize.screenWidth())-10, height:Int(layout_label.frame.size.height))
        
    }

}

