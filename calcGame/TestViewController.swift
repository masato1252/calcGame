//
//  TestViewController.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/11.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var btn_test1: UIButton!
    
    var parentContext:MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btn_test1.addTarget(self, action: #selector(self.tapped(sender:)), for: .touchUpInside)
    
    }
    
    func tapped(sender: UIButton){
        self.parentContext?.moveToPage(num: 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
