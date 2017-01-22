//
//  TestViewController.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/11.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    
    @IBOutlet weak var btn_quizGet: UIButton!
    @IBOutlet weak var btn_quizReset: UIButton!
    @IBOutlet weak var btn_storyReset: UIButton!
    
    var parentContext:MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btn_quizGet.addTarget(self, action: #selector(self.tappedQuizGet), for: .touchUpInside)
        btn_quizReset.addTarget(self, action: #selector(self.tappedQuizReset), for: .touchUpInside)
        btn_storyReset.addTarget(self, action: #selector(self.tappedStoryReset), for: .touchUpInside)
    
    }
    
    //Webからクイズ更新
    func tappedQuizGet(sender: UIButton){
        
        let gq = GetQuizController(activity: parentContext!)
        gq.execute()
    }
    
    
    //クイズデータを初期へリセット
    func tappedQuizReset(sender: UIButton){
        
        // アラートを作成
        let alert = UIAlertController(
            title: "確認",
            message: "本当に問題データをインストール時へ戻しますか？",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            
            QuizDataHelper.sharedInstance.resetQuizData()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //クリアデータの初期化
    func tappedStoryReset(sender: UIButton){
        // アラートを作成
        let alert = UIAlertController(
            title: "確認",
            message: "本当にクリアデータを初期化しますか？",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            SaveData.sharedInstance.resetSaveData()
            let ssvc:SelectStoryViewController = self.parentContext?.viewCtrArray[1] as! SelectStoryViewController
            let vc:ViewController = self.parentContext?.viewCtrArray[0] as! ViewController
            ssvc.reloadButtonAfterResetData()
            vc.reloadButtonAfterClear()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
