//
//  SaveData.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/12.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import Foundation

class SaveData :NSObject {
    
    //シングルトン化
    static let sharedInstance = SaveData()
    
    var userDefaults = UserDefaults.standard

    //ボタン解放状況
    var releaseArray:Dictionary<Int,Int> = Dictionary<Int,Int>()
    //クリア時間
    var timeArray:Dictionary<Int,String> = Dictionary<Int,String>()
    //クリア時間(秒数) ※比較用
    var timeNumArray:Dictionary<Int,Int> = Dictionary<Int,Int>()
    
    let btnLabelTable:Dictionary<Int,String> = [ 0:"0", 1:"1", 2:"2", 3:"3", 4:"4", 5:"5", 6:"6", 7:"7", 8:"8", 9:"9", 10:"ドット(小数点)"]
    
    private override init() {
        if (userDefaults.object(forKey: "releaseArray") == nil) {
            //新規作成
            for i in 0...10 {
                releaseArray[i] = 0
                timeArray[i] = "--:--"
                timeNumArray[i] = 10000
            }
            releaseArray.updateValue(1, forKey: 1)  //最初に1だけ解放
            var archiveData = NSKeyedArchiver.archivedData(withRootObject: releaseArray)
            userDefaults.set(archiveData, forKey: "releaseArray")
            archiveData = NSKeyedArchiver.archivedData(withRootObject: timeArray)
            userDefaults.set(archiveData, forKey: "timeArray")
            archiveData = NSKeyedArchiver.archivedData(withRootObject: timeNumArray)
            userDefaults.set(archiveData, forKey: "timeNumArray")
            userDefaults.synchronize()
        }else{
            
            var storedData = userDefaults.object(forKey: "releaseArray") as! Data
            releaseArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
            storedData = userDefaults.object(forKey: "timeArray") as! Data
            timeArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, String>
            storedData = userDefaults.object(forKey: "timeNumArray") as! Data
            timeNumArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
        }

    }
    
    //クリア時の解放ボタンを指定
    func clearStory(num:Int, time:String, timeNum:Int){
        releaseArray.updateValue(1, forKey: num)

        if(timeNumArray[num]! > timeNum){
            //ベストタイム更新
            timeArray.updateValue(time, forKey: num)
            timeNumArray.updateValue(timeNum, forKey: num)
        }
        syncroData()
    }
    
    //データを本体に保存
    func syncroData() {
        var archiveData = NSKeyedArchiver.archivedData(withRootObject: releaseArray)
        userDefaults.set(archiveData, forKey: "releaseArray")
        archiveData = NSKeyedArchiver.archivedData(withRootObject: timeArray)
        userDefaults.set(archiveData, forKey: "timeArray")
        userDefaults.synchronize()
        archiveData = NSKeyedArchiver.archivedData(withRootObject: timeNumArray)
        userDefaults.set(archiveData, forKey: "timeNumArray")
        userDefaults.synchronize()
    }
    
    
    //クリアデータ・リロード
    func reloadSaveData() {
        
        if (userDefaults.object(forKey: "releaseArray") == nil) {
            //新規作成
            for i in 0...10 {
                releaseArray[i] = 0
                timeArray[i] = "--:--"
                timeNumArray[i] = 10000
            }
            releaseArray.updateValue(1, forKey: 1)  //最初に1だけ解放
            syncroData()
        }else{
            var storedData = userDefaults.object(forKey: "releaseArray") as! Data
            releaseArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
            storedData = userDefaults.object(forKey: "timeArray") as! Data
            timeArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, String>
            storedData = userDefaults.object(forKey: "timeNumArray") as! Data
            timeNumArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
        }
    }
    
    
    //クリアデータ初期化
    func resetSaveData() {
        
        for i in 0...10 {
            releaseArray.updateValue(0, forKey: i)
            timeArray.updateValue("--:--", forKey: i)
            timeNumArray.updateValue(10000, forKey: i)
        }
        releaseArray.updateValue(1, forKey: 1)
        
        syncroData()
    }
    

}
