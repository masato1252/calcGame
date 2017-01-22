//
//  GetRateController.swift
//  test1
//
//  Created by 松浦 雅人 on 2017/01/15.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit


class GetQuizController : NSObject {
    
    var activity:UIViewController
    var indicator = UIActivityIndicatorView()
    var group = DispatchGroup()
    
    
    //自作APIアドレス=> http://concierge-apps.lovepop.jp/calc/json.php
    var baseUrl:String = "http://concierge-apps.lovepop.jp/calc/json.php"
    
    
    
    init(activity: UIViewController){
        //親アクティビティのインスタンス保持 => グルグル表示
        self.activity = activity
        
        super.init()
    }

    
    //実行する関数（APIへアクセス＆配列へ格納）
    func execute(){
        
        //処理中のグルグルを表示
        showIndicator()
  
        //1回APIを叩く
//        for i in 0..<countryArray.count {
//            group.enter()
//            DispatchQueue.global().async {
//                self.getRateArray(num: i)
//            }
//        }
        group.enter()
        DispatchQueue.global().async {
            self.getQuizData(num: 0)
        }
        
        //データ受信＆配列格納が全て完了 => グルグル停止＆レートを内部に保存
        group.notify(queue: .global()) {
            print("クイズデータ取得完了")
            //グルグル停止
            self.indicator.stopAnimating()
            
            //本体へ保存
            //RateData.sharedInstance.saveRateData(array: self.rateArray)
            
            //debug
        }

    }
    
    
    //実際にAPIへアクセス＆配列格納を行う
    func getQuizData(num: Int){

        let url: URL = URL(string: baseUrl)!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                //既存のクイズデータを一旦削除
                QuizDataHelper.sharedInstance.quizArray.removeAll()
                
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:String]]
                    
                    for tmp in parsedData {
                        let quiz:QuizData = QuizData()
                        let keyNum:Int = Int(atoi(tmp["keyNum"]!))
                        
                        quiz.setNumKey(num: keyNum)
                        quiz.setQuestion(str: tmp["question"]!)
                        quiz.setAnswer(str: tmp["answer"]!)
                        quiz.setTimes(num: Int(atoi(tmp["times"]!)))
                        
                        print(quiz)
                        QuizDataHelper.sharedInstance.quizArray.append(quiz)
                    }
                    QuizDataHelper.sharedInstance.syncroData()
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.group.leave()
                }
            }
            
        })

        task.resume()
    }
    

    
    //グルグル生成＆表示
    func showIndicator() {
        
        // UIActivityIndicatorView のスタイルをテンプレートから選択
        indicator.activityIndicatorViewStyle = .whiteLarge
        // 表示位置
        indicator.center = activity.view.center
        // 色の設定
        indicator.color = UIColor.green
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        // 画面に追加
        activity.view.addSubview(indicator)
        // 最前面に移動
        activity.view.bringSubview(toFront: indicator)
        // アニメーション開始
        indicator.startAnimating()
        
    }

    
    
}
