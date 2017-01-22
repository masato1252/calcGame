//
//  QuizDataHelper.swift
//  calcGame
//
//  Created by 松浦 雅人 on 2017/01/21.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import Foundation


class QuizDataHelper: NSObject {
    
    //シングルトン化
    static let sharedInstance = QuizDataHelper()
    
    var userDefaults = UserDefaults.standard
    
    //クイズデータ
    var quizArray:[QuizData] = [QuizData]()
    
    let keyArray:[Int] = [2,3,4,5,6,7,8,9,10,0]
    
    private override init() {
        super.init()
        
        if (userDefaults.object(forKey: "quiz2") == nil) {
            //初期クイズデータをセット
            self.makeInitQuizData()

            for tmp in quizArray {
                
                let dict:[String:String] = ["numKey":String(tmp.getNumkey()), "question":tmp.getQuestion(), "answer":tmp.getAnswer(), "times":String(tmp.getTimes())]
                let archiveData = NSKeyedArchiver.archivedData(withRootObject: dict)
                userDefaults.set(archiveData, forKey: "quiz\(tmp.getNumkey())")
            }
            
            userDefaults.synchronize()
        }else{
            
            for i in keyArray {
                let storedData = userDefaults.object(forKey: "quiz\(i)") as! Data
                let dict = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! [String:String]
                let quiz:QuizData = QuizData()
                quiz.setNumKey(num: Int(atoi(dict["numKey"])))
                quiz.setQuestion(str: dict["question"]!)
                quiz.setAnswer(str: dict["answer"]!)
                quiz.setTimes(num: Int(atoi(dict["times"])))
                quizArray.append(quiz)
            }
            
            
        }

        
    }
    
    //データを本体に保存
    func syncroData() {
        print("syncQuizData")
        for tmp in quizArray {
            let dict:[String:String] = ["numKey":String(tmp.getNumkey()), "question":tmp.getQuestion(), "answer":tmp.getAnswer(), "times":String(tmp.getTimes())]
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: dict)
            userDefaults.set(archiveData, forKey: "quiz\(tmp.getNumkey())")
        }
        userDefaults.synchronize()
    }
    
    
    
    //クイズデータ・リロード
    func reloadQuizData() {
        
        if (userDefaults.object(forKey: "quiz2") == nil) {
            //新規作成
            makeInitQuizData()
            syncroData()
        }else{
            for i in keyArray {
                let storedData = userDefaults.object(forKey: "quiz\(i)") as! Data
                let dict = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! [String:String]
                let quiz:QuizData = QuizData()
                quiz.setNumKey(num: Int(atoi(dict["numKey"])))
                quiz.setQuestion(str: dict["question"]!)
                quiz.setAnswer(str: dict["answer"]!)
                quiz.setTimes(num: Int(atoi(dict["times"])))
                quizArray.append(quiz)
            }

            print("Load QuizData")
            print(quizArray)

        }
    }
    
    
    //クリアデータ初期化
    func resetQuizData() {
        print("resetQuizData")
        quizArray.removeAll()
        makeInitQuizData()
        syncroData()
    }

    
    
    func makeInitQuizData() {
        print("Make Init-QuizData")
        
        var quiz:QuizData = QuizData()
        
        //2
        quiz.setNumKey(num: 2)
        quiz.setQuestion(str: "3回以内に計算結果「4」を導け")
        quiz.setAnswer(str: "4")
        quiz.setTimes(num: 3)
        quizArray.append(quiz)
        
        //3
        quiz = QuizData()
        quiz.setNumKey(num: 3)
        quiz.setQuestion(str: "4回以内に計算結果「9」を導け")
        quiz.setAnswer(str: "9")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //4
        quiz = QuizData()
        quiz.setNumKey(num: 4)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //5
        quiz = QuizData()
        quiz.setNumKey(num: 5)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //6
        quiz = QuizData()
        quiz.setNumKey(num: 6)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //7
        quiz = QuizData()
        quiz.setNumKey(num: 7)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //8
        quiz = QuizData()
        quiz.setNumKey(num: 8)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //9
        quiz = QuizData()
        quiz.setNumKey(num: 9)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //0
        quiz = QuizData()
        quiz.setNumKey(num: 0)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        //ドット
        quiz = QuizData()
        quiz.setNumKey(num: 10)
        quiz.setQuestion(str: "4回以内に計算結果「10」を導け")
        quiz.setAnswer(str: "10")
        quiz.setTimes(num: 4)
        quizArray.append(quiz)
        
        
    }

    
}
