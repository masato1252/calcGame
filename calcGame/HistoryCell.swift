//
//  HistoryCell.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var label_equation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(history :HistoryData, index :Int) {
        self.label_equation.text = history.getDispStr()
        
        //背景色設定
        if(index%2==0){
            self.backgroundColor = UIColor(hexString: "#F5F5F5")
        }else{
            self.backgroundColor = UIColor(hexString: "#F5FFFA")
        }
        
        //レイアウト設定
        self.label_equation.translatesAutoresizingMaskIntoConstraints = true
        self.label_equation.frame = CGRect(x:10, y:5, width:Int(DeviceSize.screenWidth())-20, height:Int(self.frame.size.height)-10)
    }
    
}

