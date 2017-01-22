//
//  SelectStoryViewController.swift
//  calcGame
//
//  Created by 松浦 雅人 on 2017/01/16.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit


class SelectStoryViewController: UIViewController {
    
    
    
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnDot: UIButton!
    @IBOutlet weak var btnDam: UIButton!  //ダミー
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var label_state: UILabel!
    @IBOutlet weak var label_select: UILabel!
    @IBOutlet weak var label_eachState: UILabel!
    @IBOutlet weak var label_time: UILabel!
    
    @IBOutlet weak var layout_upperMenu: UIStackView!
    @IBOutlet weak var layout_btn1: UIStackView!
    @IBOutlet weak var layout_btn2: UIStackView!
    @IBOutlet weak var layout_btn3: UIStackView!
    @IBOutlet weak var layout_btn4: UIStackView!
    
    @IBOutlet weak var layout_eachState: UIStackView!
    @IBOutlet weak var layout_playBtn: UIStackView!
    
    
    var btnArray:[UIButton] = [UIButton]()
    
    var selectNum:Int = 0
    var isShowedPlayBtn:Bool = false
    
    var parentContext:MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタン調整
        setButton()
        //レイアウト調整
        setLayout()
        
        //クリア状況のセット
        self.label_state.text = "ボタンを選択\n計算クイズをクリアして使えるボタンを集めよう"
        
        
    }
    
    
    internal func tappedKey(sender: UIButton) {
        
        //選択状態を下部ステートにセット
        switch (sender.tag) {
        case 0...9:
            self.label_select.text = "「\(sender.tag)」ボタン"
            break
        case 10:
            self.label_select.text = "「ドット(小数点)」ボタン"
            break
        default:
            break
        }
        
        //解放済みかどうか判定し、下部ステートに表示
        if(SaveData.sharedInstance.releaseArray[sender.tag]==0){
            self.label_eachState.text = "ロック中（未クリア）"
            self.label_time.text = ""
            
        }else{
            self.label_eachState.text = "解放済み（クリア）"
            self.label_time.text = "ベストタイム " + SaveData.sharedInstance.timeArray[sender.tag]!
        }
        
        
        
        //選択中の番号を保持
        selectNum = sender.tag
        
        //プレイボタン非常時なら表示させる
        if(!isShowedPlayBtn){
            isShowedPlayBtn = true
            layout_playBtn.isHidden = false
        }
        
    }
    
    
    //プレイボタンが押された時
    internal func tappedPlayBtn(){
        
        self.parentContext?.openGameView(num: selectNum)
    }
    

    
    //GameViewControllerから呼び出し・クリア（解放）したボタンの色更新
    func reloadButtonAfterClear(){
        for i in 0..<btnArray.count-1 {

            let tag = btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                btnArray[i].backgroundColor = UIColor.init(hexString: "#FA8072")
            }else{
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
            }
        }
        
        self.label_eachState.text = "解放済み（クリア）"
        self.label_time.text = "ベストタイム " + SaveData.sharedInstance.timeArray[selectNum]!
    }
    
    //設定画面より、セーブデータリセット時
    func reloadButtonAfterResetData(){
        for i in 0..<btnArray.count-1 {
            
            let tag = btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                btnArray[i].backgroundColor = UIColor.init(hexString: "#FA8072")
            }else{
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
            }
        }
        
        if(isShowedPlayBtn){
            self.label_eachState.text = "ロック中（未クリア）"
            self.label_time.text = ""
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
        btnDam.tag=11
        btnArray.append(btnDam)

        for i in 0..<btnArray.count-1 {
            btnArray[i].addTarget(self, action: #selector(self.tappedKey), for: .touchUpInside)
            btnArray[i].showsTouchWhenHighlighted = true
            
            let tag = btnArray[i].tag
            if(SaveData.sharedInstance.releaseArray[tag]==0){
                //未解放
                btnArray[i].backgroundColor = UIColor.init(hexString: "#FA8072")
                btnArray[i].showsTouchWhenHighlighted = true
                btnArray[i].addTarget(self, action: #selector(self.tappedKey(sender:)), for: .touchUpInside)
                //btnArray[i].isEnabled = false
            }else{
                //解放済み
                btnArray[i].backgroundColor = UIColor.init(hexString: "#87CEFA")
                btnArray[i].showsTouchWhenHighlighted = true
                btnArray[i].addTarget(self, action: #selector(self.tappedKey(sender:)), for: .touchUpInside)
            }
        }
        //「1」のみ非活性
        btnArray[0].isEnabled = false
        
        btnPlay.addTarget(self, action: #selector(self.tappedPlayBtn), for: .touchUpInside)

    }

    
    internal func setLayout() {
        
        //------------------
        // レイアウトパラメータ
        //------------------
        //数字キーの高さ
        let BtnHeight:Int = Int(DeviceSize.screenHeight()/8)
        //数字キーの幅
        let BtnWidth:Int = Int(DeviceSize.screenWidth()/4)-5
        //数字キーの縦マージン
        let marginTop_Btn:Int = 10
        //数字キーの横マージン
        let marginRight_Btn:Int = 10
        
        //上部メニューの高さ
        let upperMenuHeight:Int = Int(DeviceSize.screenHeight()/12)
        //下部ステート領域の高さ
        let eachStateHeight:Int = Int(DeviceSize.screenHeight()/8)
        //下部プレイボタン領域の高さ
        let playBtnHeight:Int = Int(DeviceSize.screenHeight()/10)
        
        //プレイボタン領域の初期は非表示
        layout_playBtn.isHidden = true
        
        
        //縦レイアウト制御
        var h_tmp:Int = 0
        layout_upperMenu.translatesAutoresizingMaskIntoConstraints = true
        layout_upperMenu.frame = CGRect(x:0, y:5, width:DeviceSize.screenWidth(), height:upperMenuHeight);
        //h_tmp = Int(DeviceSize.statusBarHeight()) + upperMenuHeight
        h_tmp = 5 + upperMenuHeight
        
        layout_btn1.translatesAutoresizingMaskIntoConstraints = true
        layout_btn1.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:BtnHeight);
        layout_btn1.backgroundColor = UIColor.init(hexString: "#FAEBD7")
        h_tmp += BtnHeight + marginTop_Btn
        
        layout_btn2.translatesAutoresizingMaskIntoConstraints = true
        layout_btn2.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:BtnHeight);
        layout_btn2.backgroundColor = UIColor.init(hexString: "#FAEBD7")
        h_tmp += BtnHeight + marginTop_Btn
        
        layout_btn3.translatesAutoresizingMaskIntoConstraints = true
        layout_btn3.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:BtnHeight);
        layout_btn3.backgroundColor = UIColor.init(hexString: "#FAEBD7")
        h_tmp += BtnHeight + marginTop_Btn
        
        layout_btn4.translatesAutoresizingMaskIntoConstraints = true
        layout_btn4.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:BtnHeight);
        layout_btn4.backgroundColor = UIColor.init(hexString: "#FAEBD7")
        h_tmp += BtnHeight + marginTop_Btn
        
        layout_eachState.translatesAutoresizingMaskIntoConstraints = true
        layout_eachState.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:eachStateHeight);
        h_tmp += eachStateHeight
        
        layout_playBtn.translatesAutoresizingMaskIntoConstraints = true
        layout_playBtn.frame = CGRect(x:0, y:DeviceSize.screenHeight()-(playBtnHeight*2), width:DeviceSize.screenWidth(), height:playBtnHeight);
        
        
        
        //数字ボタンレイアウト制御
        let v_start:Int = (DeviceSize.screenWidth()/2) - ((BtnWidth/2)*3+marginRight_Btn)
        var v_tmp:Int = v_start
        for i in 0..<btnArray.count {
            let btn:UIButton = btnArray[i]
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.frame = CGRect(x:v_tmp, y:Int(btn.frame.minY), width:BtnWidth, height:Int(layout_btn1.frame.size.height))
            
            if((i+1)%3==0){
                v_tmp = v_start
            }else{
                v_tmp += BtnWidth + marginRight_Btn
            }
        }
        
//        label_time.translatesAutoresizingMaskIntoConstraints = true
//        label_time.frame = CGRect(x:Int(label_time.frame.minX), y:Int(label_time.frame.minY)+5, width:Int(label_time.frame.size.width), height:Int(label_time.frame.size.height))

    }
    
    
    
    
}
