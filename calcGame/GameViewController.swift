//
//  GameViewController.swift
//  calcGame
//
//  Created by 松浦 雅人 on 2017/01/20.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentContext:MainViewController? = nil
    var gameNum:Int = 0
    
    @IBOutlet weak var layout_upperMenu: UIStackView!
    @IBOutlet weak var layout_state: UIStackView!
    @IBOutlet weak var tv_history: UITableView!
    
    @IBOutlet weak var layout_disp: UIStackView!
    @IBOutlet weak var layout_btn4: UIStackView!
    @IBOutlet weak var layout_btn3: UIStackView!
    @IBOutlet weak var layout_btn2: UIStackView!
    @IBOutlet weak var layout_btn1: UIStackView!
    
    @IBOutlet weak var label_disp: UILabel!
    @IBOutlet weak var label_spent: UILabel!
    @IBOutlet weak var label_times: UILabel!
    @IBOutlet weak var label_question: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    
    @IBOutlet weak var btnDot: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnEq: UIButton!
    
    @IBOutlet weak var btnAc: UIButton!
    @IBOutlet weak var btnBs: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnTimes: UIButton!
    @IBOutlet weak var btnDiv: UIButton!
    @IBOutlet weak var btnAdd: UIButton!

    @IBOutlet weak var btnPause: UIButton!
    
    
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
    
    var times:Int = 0  //残り計算回数
    var timesOrigin:Int = 0  //計算回数制限(元データ)
    var answer:String = "0"  //計算結果(クリア条件)
    
    var timer:Timer!  //経過時間カウント用タイマー
    var startDate = NSDate() // ゲーム開始時の時刻を取得
    var timeStr:String = ""
    var timeNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //クイズデータをロード
        var quiz:QuizData = QuizData()
        for tmp in QuizDataHelper.sharedInstance.quizArray {
            if(gameNum == tmp.getNumkey()){
                quiz = tmp
            }
        }
        times = quiz.getTimes()
        timesOrigin = times
        answer = quiz.getAnswer()
        label_times.text = "あと\(times)回"
        label_question.text = quiz.getQuestion()
        label_spent.text = "00:00"
        
        //経過時間カウント開始
        timerStart()
        
        //ボタンの調整
        setButton()
        //レイアウトの調整
        setLayout()

        
    }
    
    
    
    //回数ラベルの更新
    internal func reloadLabelTimes(){
        label_times.text = "あと\(times)回"
    }
    
    //経過時間カウントアップ用 タイマー開始
    internal func timerStart() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countUpSpent), userInfo: nil, repeats: true)
        timer.fire()
    }
    //経過時間カウントアップ用 タイマー停止
    internal func timerStop() {
        
        timer.invalidate()

    }
    
    
    //経過時間カウント
    internal func countUpSpent() {
        
        var hh:Int = 0
        var mm:Int = 0
        var ss:Int = 0
        
        timeNum += 1
        
        let nowTime = NSDate().timeIntervalSince(startDate as Date) // 現在時刻と開始時刻の差
        hh = Int(nowTime / 3600)
        mm = Int((nowTime - Double(hh * 3600)) / 60)
        ss = Int(nowTime - Double(hh * 3600 + mm * 60))
        if(hh>=1){
            //1h以上
            timeStr = String(format: "%02d:%02d:%02d", hh, mm, ss)
        }else{
            //1h未満
            timeStr = String(format: "%02d:%02d", mm, ss)
        }
        label_spent.text = timeStr
    }
    
    
    //---------------
    // Tap Events
    //---------------
    
    //数字ボタン押下時
    internal func tappedNumKey(sender: UIButton){
        
        if(times<=0){
            //回数0の場合は、無効化
            return
        }
        
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
        
        if(times<=0 || (numArray.count>=1 && !temp.isEmpty)){
            //回数0の場合、または、(A+B)の一式が成り立つ場合は、無効化
            if(sender.tag == 100 || sender.tag == 105){
                //BSキー押下時以外は何もしない
            }else{
                return
            }
        }
        
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
        
        if(times<=0){
            //回数0の場合は、無効化
            return
        }
        
        if(!temp.isEmpty && numArray.count>0){
            numArray.append(temp)
            
            //回数更新
            times = times - 1
            reloadLabelTimes()
            
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
            
            //クリア判定
            if(dispStr == answer){
                timerStop()
                clearGame()
            }
        }
    }
    
    
    //中断ボタン押下時
    func tappedPause() {
        
        // アラートを作成
        let alert = UIAlertController(
            title: "Pause",
            message: "",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "戻る", style: .cancel))
        alert.addAction(UIAlertAction(title: "リタイア", style: .default, handler: { action in
            self.retireGame()
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
        
    }
    //---------------
    // Tap Events  End
    //---------------
    
    //リタイア時
    internal func retireGame() {

        dismiss(animated: true, completion: {
            [presentingViewController] () -> Void in
            // 閉じる前の処理
            presentingViewController?.viewWillAppear(true)
        })

    }
    
    //クリア時
    internal func clearGame() {
        
        // アラートを作成
        let alert = UIAlertController(
            title: "クリア！",
            message: "「\(SaveData.sharedInstance.btnLabelTable[gameNum]!)」ボタンが開放されました！",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.clearGameClose()
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    //クリア時(OKボタン押下)の挙動
    internal func clearGameClose() {
        
        dismiss(animated: true, completion: {
            [presentingViewController] () -> Void in
            // 閉じる前の処理
            SaveData.sharedInstance.clearStory(num: self.gameNum, time: self.timeStr, timeNum: self.timeNum)
            let ssvc:SelectStoryViewController = self.parentContext?.viewCtrArray[1] as! SelectStoryViewController
            let vc:ViewController = self.parentContext?.viewCtrArray[0] as! ViewController
            ssvc.reloadButtonAfterClear()
            vc.reloadButtonAfterClear()
            presentingViewController?.viewWillAppear(true)
        })
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
        
        //回数更新
        times = timesOrigin - historyArray.count
        reloadLabelTimes()
    }
    
    
    //GameViewControllerから呼び出し・クリア（解放）したボタンの色更新
    func reloadButtonAfterClear(){
        for i in 0...10 {
            
            let tag = btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                //未解放
                btnArray[i].backgroundColor = UIColor.init(hexString: "#D3D3D3")
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
        btn1.tag=1
        btnArray.append(btn1)
        btn2.tag=2
        btnArray.append(btn2)
        btn3.tag=3
        btnArray.append(btn3)
        btn4.tag=4
        btnArray.append(btn4)
        btn5.tag=5
        btnArray.append(btn5)
        btn6.tag=6
        btnArray.append(btn6)
        btn7.tag=7
        btnArray.append(btn7)
        btn8.tag=8
        btnArray.append(btn8)
        btn9.tag=9
        btnArray.append(btn9)
        btn0.tag=0
        btnArray.append(btn0)
        btnDot.tag=10
        btnArray.append(btnDot)
        
        btnEq.tag=999
        btnEq.addTarget(self, action: #selector(self.tappedEqualKey), for: .touchUpInside)
        btnArray.append(btnEq)
        btnEq.showsTouchWhenHighlighted = true
        
        for i in 0..<btnArray.count-1 {
            btnArray[i].addTarget(self, action: #selector(self.tappedNumKey), for: .touchUpInside)
            btnArray[i].showsTouchWhenHighlighted = true
            
            let tag = (btnArray[i].tag==999) ? 1 : btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                //未解放
                btnArray[i].backgroundColor = UIColor.init(hexString: "#D3D3D3")
                btnArray[i].isEnabled = false
            }else{
                //解放済み
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
                btnArray[i].isEnabled = true
            }
            
        }
        
        //演算子＋AC＋BSボタン(右側)
        btnAc.tag=105
        btnArray2.append(btnAc)
        btnBs.tag=100
        btnArray2.append(btnBs)
        btnDiv.tag=104
        btnArray2.append(btnDiv)
        btnTimes.tag=103
        btnArray2.append(btnTimes)
        btnSub.tag=102
        btnArray2.append(btnSub)
        btnAdd.tag=101
        btnArray2.append(btnAdd)
        
        
        for i in 0..<btnArray2.count {
            btnArray2[i].addTarget(self, action: #selector(self.tappedOperator), for: .touchUpInside)
            btnArray2[i].showsTouchWhenHighlighted = true
        }
        
        //中断ボタン
        btnPause.addTarget(self, action: #selector(self.tappedPause), for: .touchUpInside)
        btnPause.showsTouchWhenHighlighted = true
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
        //上部ステータス領域の高さ
        let stateHeight:Int = Int(DeviceSize.screenHeight()/15)
        //履歴テーブルビューの高さ
        let historyViewHeight:Int = Int(DeviceSize.screenHeight()/5)
        //計算結果ビューの高さ
        let labelViewHeight:Int = Int(DeviceSize.screenHeight()/9)
        
        
        
        //縦レイアウト制御
        var h_tmp:Int = Int(DeviceSize.statusBarHeight())
        layout_upperMenu.translatesAutoresizingMaskIntoConstraints = true
        //layout_upperMenu.frame = CGRect(x:0, y:Int(DeviceSize.statusBarHeight()), width:DeviceSize.screenWidth(), height:upperMenuHeight);
        layout_upperMenu.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:upperMenuHeight);
        //h_tmp = Int(DeviceSize.statusBarHeight()) + upperMenuHeight
        h_tmp += upperMenuHeight
        
        layout_state.translatesAutoresizingMaskIntoConstraints = true
        layout_state.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:stateHeight);
        h_tmp += stateHeight
        
        
        tv_history.translatesAutoresizingMaskIntoConstraints = true
        tv_history.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:historyViewHeight);
        h_tmp += historyViewHeight
        
        layout_disp.translatesAutoresizingMaskIntoConstraints = true
        layout_disp.backgroundColor = UIColor.black
        layout_disp.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:labelViewHeight);
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
        
        var uw:Int = 0
        btnPause.translatesAutoresizingMaskIntoConstraints = true
        btnPause.frame = CGRect(x:0, y:0, width:Int(DeviceSize.screenWidth()/4), height:Int(layout_upperMenu.frame.size.height))
        uw += Int(DeviceSize.screenWidth()/4) + 5
        
        label_times.translatesAutoresizingMaskIntoConstraints = true
        label_times.frame = CGRect(x:uw, y:0, width:Int(DeviceSize.screenWidth()/3), height:Int(layout_upperMenu.frame.size.height))
        uw += Int(DeviceSize.screenWidth()/3) + 5
        
        label_spent.translatesAutoresizingMaskIntoConstraints = true
        label_spent.frame = CGRect(x:uw, y:0, width:Int(DeviceSize.screenWidth()-uw), height:Int(layout_upperMenu.frame.size.height))
        
        
        //計算結果ビューのパディング
        label_disp.translatesAutoresizingMaskIntoConstraints = true
        label_disp.frame = CGRect(x:5, y:0, width:Int(DeviceSize.screenWidth())-10, height:Int(layout_disp.frame.size.height))
        
        
    }

}

