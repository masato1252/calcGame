//
//  GameViewController.swift
//  calcGame
//
//  Created by 松浦 雅人 on 2017/01/20.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit


class GameViewController: UIViewController {
    
    var parentContext:MainViewController? = nil
    
    @IBOutlet weak var btnClose: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnClose.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchUpInside)
        
    }
    
    
    internal func tapped(sender: UIButton){
        
        dismiss(animated: true, completion: {
            [presentingViewController] () -> Void in
            // 閉じる前の処理
            SaveData.sharedInstance.releaseArray.updateValue(1, forKey: 3)
            let ssvc:SelectStoryViewController = self.parentContext?.viewCtrArray[1] as! SelectStoryViewController
            let vc:ViewController = self.parentContext?.viewCtrArray[0] as! ViewController
            ssvc.reloadButtonAfterClear()
            vc.reloadButtonAfterClear()
            presentingViewController?.viewWillAppear(true)
        })
    }

    
}

