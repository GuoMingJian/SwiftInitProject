//
//  BaseViewController.swift
//
//  Created by 郭明健 on 2020/8/25.
//  Copyright © 2020 GuoMingJian. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        adaptDynamicColor()
        configNavigationBar()
        setupViews()
        //
        mj_PopEnabled = false
    }
    
    /// 适配深色、浅色模式
    func adaptDynamicColor() {
        self.view.backgroundColor = UIColor.hexColor(color: "F4F7FA")
        setNavigationBarBackgroundColor(view: self.navigationController?.navigationBar)
    }
    
    /// 配置导航栏
    func configNavigationBar() {
    }
    
    /// 界面初始化
    func setupViews() {
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /// 设置导航栏背景色
    func setNavigationBarBackgroundColor(view: UIView?,
                                         color: UIColor = kNavigationColor) {
        view?.backgroundColor = color
        view?.tintColor = color
        view?.subviews.forEach {
            setNavigationBarBackgroundColor(view: $0, color: color)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
