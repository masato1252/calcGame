//
//  ViewController.swift
//  UIPageViewControllerSample
//
//  Created by 酒井文也 on 2016/04/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//テーブルビューに関係する定数
struct PageSettings {
    
    //UIScrollViewのサイズに関するセッテイング
    static let menuScrollViewY : Int = 20
    static let menuScrollViewH : Int = 30
    static let slidingLabelY : Int = 25
    static let slidingLabelH : Int = 5
    
    
    
    //UIScrollViewに表示するボタン名称
    static let pageScrollNavigationList: [String] = [
        "フリー計算",
        "ストーリー",
        "設定"
    ]
    
    //UIPageViewControllerに配置するUIViewControllerクラスの名称
    static let pageControllerIdentifierList : [String] = [
        "ViewController",
        "ViewController",
        "TestViewController"
    ]
    
    //UIPageViewControllerに追加するViewControllerのリストを生成する
    static func generateViewControllerList() -> [UIViewController] {
        

        var viewControllers : [UIViewController] = []
        self.pageControllerIdentifierList.forEach { viewControllerName in
        
            //ViewControllerのIdentifierからViewControllerを作る
            let viewController = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "\(viewControllerName)")

            viewControllers.append(viewController)
        }
        return viewControllers
    }

}

class MainViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    //子のViewControllerのindex
    var viewControllerIndex : Int = 0
    
    //動くラベルの設定
    var slidingLabel : UILabel!
    
    //ページ管理用のコントローラー
    var pageViewController : UIPageViewController!
    
    //ページコンテンツのViewController名格納用の配列
    var pageContentsControllerList : [String] = [String]()
    
    //メニュー用のスクロールビュー
    var menuScrollView : UIScrollView!
    
    //メニュー用スクロールビューのX座標のOffset値
    var scrollButtonOffsetX : Int = 0
    
    //UIViewControllerのオブジェクト格納用配列
    var viewCtrArray:[UIViewController] = [UIViewController]()
    

    //var saveData:SaveData = SaveData()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let userDefaults = UserDefaults.standard
//        //クリアデータの読み込み
//        if (userDefaults.object(forKey: "data") == nil) {
//            //新規作成
//                userDefaults.set(0, forKey: "data")
//            for i in 0...10 {
//                userDefaults.set(0, forKey: "\(i)")
//            }
//        }
        
        //UIScrollViewの初期化
        self.menuScrollView = UIScrollView()
        
        //UIScrollViewのデリゲート
        self.menuScrollView.delegate = self
        
        //UIScrollViewを配置
        self.view.addSubview(self.menuScrollView)
        
        //動くラベルの初期化
        self.slidingLabel = UILabel()
        
        //UIPageViewControllerの設定
        // * .Scrollだと謎のキャッシュ問題が発生
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        //UIPageViewControllerのデリゲート
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        //UIPageViewControllerの初期の位置を決める
        //self.pageViewController.setViewControllers([PageSettings.generateViewControllerList().first!], direction: .forward, animated: false, completion: nil)
        self.pageViewController.setViewControllers([generateViewControllerList().first!], direction: .forward, animated: false, completion: nil)
        
        //UIPageViewControllerを子のViewControllerとして登録
        self.addChildViewController(self.pageViewController)
        
        //UIPageViewControllerを配置
        self.view.addSubview(self.pageViewController.view)
    }
    
    func generateViewControllerList() -> [UIViewController] {
        
        if(!self.viewCtrArray.isEmpty){
            return self.viewCtrArray
        }
        
        //var viewControllers : [UIViewController] = []
        var c:Int = 0
        PageSettings.pageControllerIdentifierList.forEach { viewControllerName in
            
            //ViewControllerのIdentifierからViewControllerを作る
            if(c==2){
                let viewController:TestViewController = UIStoryboard(name: "Main", bundle: nil) .
                    instantiateViewController(withIdentifier: "\(viewControllerName)") as! TestViewController
                viewController.parentContext = self
                self.viewCtrArray.append(viewController)
            }else{
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "\(viewControllerName)")
                self.viewCtrArray.append(viewController)
            }
            
            c += 1
        }
        return self.viewCtrArray
    }

    
    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        
        //UIScrollViewのサイズを変更する
        self.menuScrollView.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(PageSettings.menuScrollViewY),
            width: CGFloat(self.view.frame.width),
            height: CGFloat(PageSettings.menuScrollViewH)
        )
        
        //UIPageViewControllerのサイズを変更する
        //サイズの想定 →（X座標：0, Y座標：[UIScrollViewのY座標＋高さ], 幅：[おおもとのViewの幅], 高さ：[おおもとのViewの高さ] - [UIScrollViewのY座標＋高さ]）
        self.pageViewController.view.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height),
            width: CGFloat(self.view.frame.width),
            height: CGFloat(self.view.frame.height - (self.menuScrollView.frame.origin.y + self.menuScrollView.frame.height))
        )
        self.pageViewController.view.backgroundColor = UIColor.gray
        self.menuScrollView.backgroundColor = UIColor.lightGray
        
        //UIScrollViewの初期設定
        self.initContentsScrollViewSettings()
        
        //UIScrollViewへのボタンの配置
        for i in 0...(PageSettings.pageScrollNavigationList.count - 1){
            self.addButtonToButtonScrollView(i)
        }
        
        //動くラベルの配置
        self.menuScrollView.addSubview(self.slidingLabel)
        self.menuScrollView.bringSubview(toFront: self.slidingLabel)
        self.slidingLabel.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(PageSettings.slidingLabelY),
            width: CGFloat(self.view.frame.width / 3),
            height: CGFloat(PageSettings.slidingLabelH)
        )
        self.slidingLabel.backgroundColor = UIColor.darkGray
    }
    
    /**
     * 
     * UIPageViewControllerDataSourceのメソッドを活用
     *
     */
    
    //ページを次にめくった際に実行される処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        let targetViewControllers : [UIViewController] = self.generateViewControllerList()
        
        if self.viewControllerIndex == targetViewControllers.count - 1 {
            return nil
        } else {
            self.viewControllerIndex = self.viewControllerIndex + 1
        }
        //スクロールビューとボタンを押されたボタンに応じて移動する
        self.moveToCurrentButtonScrollView(self.viewControllerIndex)
        self.moveToCurrentButtonLabel(self.viewControllerIndex)
        
        return targetViewControllers[self.viewControllerIndex]
    }

    //ページを前にめくった際に実行される処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        //let targetViewControllers : [UIViewController] = PageSettings.generateViewControllerList()
        let targetViewControllers : [UIViewController] = self.generateViewControllerList()
        
        if self.viewControllerIndex == 0 {
            return nil
        } else {
            self.viewControllerIndex = self.viewControllerIndex - 1
        }
        //スクロールビューとボタンを押されたボタンに応じて移動する
        self.moveToCurrentButtonScrollView(self.viewControllerIndex)
        self.moveToCurrentButtonLabel(self.viewControllerIndex)
        
        return targetViewControllers[self.viewControllerIndex]
    }
    
    /**
     *
     * UIScrollViewに関するセッティング
     *
     */
    
    //コンテンツ配置用Scrollviewの初期セッティング
    func initContentsScrollViewSettings() {
        
        self.menuScrollView.isPagingEnabled = false
        self.menuScrollView.isScrollEnabled = true
        self.menuScrollView.isDirectionalLockEnabled = false
        self.menuScrollView.showsHorizontalScrollIndicator = false
        self.menuScrollView.showsVerticalScrollIndicator = false
        self.menuScrollView.bounces = false
        self.menuScrollView.scrollsToTop = false
        
        //コンテンツサイズの決定
        self.menuScrollView.contentSize = CGSize(
            width: CGFloat(Int(self.view.frame.width) * PageSettings.pageScrollNavigationList.count / 3),
            height: CGFloat(PageSettings.menuScrollViewH)
        )
    }
    
    //ボタンの初期配置を行う
    func addButtonToButtonScrollView(_ i: Int) {
        
        let buttonElement: UIButton! = UIButton()
        self.menuScrollView.addSubview(buttonElement)
        
        let pX: CGFloat = CGFloat(Int(self.view.frame.width) / 3 * i)
        let pY: CGFloat = CGFloat(0)
        let pW: CGFloat = CGFloat(Int(self.view.frame.width) / 3)
        let pH: CGFloat = CGFloat(self.menuScrollView.frame.height)
        
        buttonElement.frame = CGRect(x: pX, y: pY, width: pW, height: pH)
        buttonElement.backgroundColor = UIColor.clear
        buttonElement.setTitle(PageSettings.pageScrollNavigationList[i], for: UIControlState())
        buttonElement.titleLabel!.font = UIFont(name: "Bold", size: CGFloat(16))
        buttonElement.tag = i
        buttonElement.addTarget(self, action: #selector(MainViewController.buttonTapped(_:)), for: .touchUpInside)
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(_ button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //UIPageViewControllerのから表示対象を決定する
        if self.viewControllerIndex != page {
            
            //self.pageViewController.setViewControllers([PageSettings.generateViewControllerList()[page]], direction: .forward, animated: true, completion: nil)
            self.pageViewController.setViewControllers([self.generateViewControllerList()[page]], direction: .forward, animated: true, completion: nil)
            
            self.viewControllerIndex = page
            
            //スクロールビューとボタンを押されたボタンに応じて移動する
            self.moveToCurrentButtonScrollView(page)
            self.moveToCurrentButtonLabel(page)
        }
    }
    
    //子UIViewControllerから呼び出し・画面遷移
    func moveToPage(num:Int){
        
        //押されたボタンのタグを取得
        let page: Int = num
        
        //UIPageViewControllerのから表示対象を決定する
        if self.viewControllerIndex != page {
            
            //self.pageViewController.setViewControllers([PageSettings.generateViewControllerList()[page]], direction: .forward, animated: true, completion: nil)
            self.pageViewController.setViewControllers([self.generateViewControllerList()[page]], direction: .forward, animated: true, completion: nil)
            
            self.viewControllerIndex = page
            
            //スクロールビューとボタンを押されたボタンに応じて移動する
            self.moveToCurrentButtonScrollView(page)
            self.moveToCurrentButtonLabel(page)
        }
    }
    
    
    //ボタンのスクロールビューをスライドさせる
    func moveToCurrentButtonScrollView(_ page: Int) {
        
        //Case1. ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (PageSettings.pageScrollNavigationList.count - 1) {
            
            //self.scrollButtonOffsetX = Int(self.view.frame.size.width) / 3 * (page - 1)
            
        //Case2. 一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            self.scrollButtonOffsetX = 0
            
        //Case3. 一番最後のpage番号のときの移動量
        } else if page == (PageSettings.pageScrollNavigationList.count - 1) {
            
            //self.scrollButtonOffsetX = Int(self.view.frame.size.width)
            self.scrollButtonOffsetX = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            
            self.menuScrollView.contentOffset = CGPoint(
                x: CGFloat(self.scrollButtonOffsetX),
                y: CGFloat(0)
            )
            
        }, completion: nil)
        
    }
    
    //動くラベルをスライドさせる
    func moveToCurrentButtonLabel(_ page: Int) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            
            self.slidingLabel.frame = CGRect(
                x: CGFloat(Int(self.view.frame.width) / 3 * page),
                y: CGFloat(PageSettings.slidingLabelY),
                width: CGFloat(Int(self.view.frame.width) / 3),
                height: CGFloat(PageSettings.slidingLabelH)
            )
            
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

