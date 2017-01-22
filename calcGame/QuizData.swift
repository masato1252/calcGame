//
//  QuizData.swift
//  calcGame
//
//  Created by 松浦 雅人 on 2017/01/21.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import Foundation




class QuizData: NSObject, NSCoding {



    private var uuid:String = NSUUID().uuidString
    private var numKey:Int = 0
    private var answer:String = ""
    private var question:String = ""
    private var times:Int = 0
    
    override init() {
        
    }
    
    // 以下NSCodingのための処理
    public required init?(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        self.numKey = aDecoder.decodeObject(forKey: "numKey") as! Int
        self.answer = aDecoder.decodeObject(forKey: "answer") as! String
        self.question = aDecoder.decodeObject(forKey: "question") as! String
        self.times = aDecoder.decodeObject(forKey: "times") as! Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uuid as String, forKey: "uuid")
        aCoder.encode(self.numKey as Int, forKey: "numKey")
        aCoder.encode(self.answer as String, forKey: "answer")
        aCoder.encode(self.question as String, forKey: "question")
        aCoder.encode(self.times as Int, forKey: "times")
    }


    
    //-------
    // Setter
    //-------
    func setNumKey(num:Int){
        self.numKey = num
    }
    
    
    func setAnswer(str:String){
        self.answer = str
    }
    
    func setQuestion(str:String){
        self.question = str
    }
    
    func setTimes(num: Int){
        self.times = num
    }
    
    
    //--------
    // Getter
    //--------
    func getNumkey() -> Int {
        return self.numKey
    }
    
    func getAnswer() -> String {
        return self.answer
    }
    
    func getQuestion() -> String {
        return self.question
    }
    
    func getTimes() -> Int {
        return self.times
    }
    
}
