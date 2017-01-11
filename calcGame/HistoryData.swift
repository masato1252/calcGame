//
//  HistoryData.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import Foundation

class HistoryData: NSObject {
    
    private var dispStr:String = ""
    private var numArray:[String] = []
    private var opeArray:[String] = []
    
    
    init(dispStr:String, numArray:[String], opeArray:[String]) {
        self.dispStr = dispStr
        self.numArray = numArray
        self.opeArray = opeArray
    }
    
    //-------
    // Setter
    //-------
    func setDispStr(str:String) {
        self.dispStr = str
    }
    
    func setNumArray(array:[String]) {
        self.numArray = array
    }
    
    func setOpeArray(array:[String]) {
        self.opeArray = array
    }
    
    //--------
    // Getter
    //--------
    func getDispStr() -> String {
        return self.dispStr
    }
    
    func getNumArray() -> [String] {
        return self.numArray
    }
    
    func getOpeArray() -> [String] {
        return self.opeArray
    }
    
}
