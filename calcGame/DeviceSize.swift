//
//  DeviceSize.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/09.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

struct DeviceSize {
    
    //CGRectを取得
    static func bounds() ->CGRect {
        return UIScreen.main.bounds
    }
    
    //画面の横サイズを取得
    static func screenWidth() ->Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    
    //画面の縦サイズを取得
    static func screenHeight() ->Int {
        return Int(UIScreen.main.bounds.size.height)
    }
    
    //ステータスバー
    static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    //ナビゲーションバー
    static func navBarHeight(navigationController: UINavigationController) -> CGFloat {
        return navigationController.navigationBar.frame.size.height
    }
    
    //タブバー
    static func tabBarHeight(tabBarController: UITabBarController) -> CGFloat {
        return tabBarController.tabBar.frame.size.height
    }
    
}
