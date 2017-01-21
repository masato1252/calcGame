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
    
    
    private override init() {
        if (userDefaults.object(forKey: "releaseArray") == nil) {
            //新規作成
            for i in 0...10 {
                releaseArray[i] = 0
            }
            releaseArray.updateValue(1, forKey: 1)  //最初に1だけ解放
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: releaseArray)
            userDefaults.set(archiveData, forKey: "releaseArray")
            userDefaults.synchronize()
        }else{
            let storedData = userDefaults.object(forKey: "releaseArray") as! Data
            releaseArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
        }

    }
    
    //クリア時の解放ボタンを指定
    func clearStory(num:Int){
        releaseArray.updateValue(1, forKey: num)
        syncroData()
    }
    
    //データを本体に保存
    func syncroData() {
        let archiveData = NSKeyedArchiver.archivedData(withRootObject: releaseArray)
        userDefaults.set(archiveData, forKey: "releaseArray")
        userDefaults.synchronize()
    }
    
    
    //クリアデータ・リロード
    func reloadSaveData() {
        
        if (userDefaults.object(forKey: "releaseArray") == nil) {
            //新規作成
            for i in 0...10 {
                releaseArray[i] = 0
            }
            releaseArray.updateValue(1, forKey: 1)  //最初に1だけ解放
            syncroData()
        }else{
            let storedData = userDefaults.object(forKey: "releaseArray") as! Data
            releaseArray = NSKeyedUnarchiver.unarchiveObject(with: storedData) as! Dictionary<Int, Int>
        }
    }
    
    
    //クリアデータ初期化
    func resetSaveData() {
        
        for i in 0...10 {
            releaseArray.updateValue(0, forKey: i)
        }
        releaseArray.updateValue(1, forKey: 1)
        
        syncroData()
    }
    

}
