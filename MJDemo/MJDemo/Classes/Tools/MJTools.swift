//
//  MJTools.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

// MARK: - 常量定义
/// App导航栏颜色
public let kNavigationColor: UIColor = .white
/// 背景色
public let kBackgroundColor: UIColor = .white
/// 分割线颜色
public let kBottomLineColor: UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

public let kErrorImage: UIImage = UIImage(named: "imageError")!

/// 状态栏高度
public let kStatusBarHeight = getStatusBarHeight()
/// 状态栏高度
func getStatusBarHeight() -> CGFloat {
    var statusBarHeight = 0.0
    if #available(iOS 13.0, *) {
        if let statusBarManager: UIStatusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            statusBarHeight = Double(Int(statusBarManager.statusBarFrame.size.height))
        }
    } else {
        statusBarHeight = Double(UIApplication.shared.statusBarFrame.size.height)
    }
    return statusBarHeight
}
/// 导航栏Bar高度
public let kNavigationBarHeight = UINavigationController().navigationBar.frame.height
/// 导航高度
public let kNavigationHeight = (kStatusBarHeight + kNavigationBarHeight)
/// TabBar高度
public let kTabBarHeight = UITabBarController().tabBar.frame.height
/// 屏幕宽
public let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高
public let kScreenHeight = UIScreen.main.bounds.size.height
/// 顶部安全间距
public let kTopSafeAreaHeight: CGFloat = {
    var topSafeAreaHeight: CGFloat = 0.0
    if #available(iOS 11.0, *) {
        topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
    }
    return topSafeAreaHeight
}()
/// 底部安全间距
public let kBottomSafeAreaHeight: CGFloat = {
    var bottomSafeAreaHeight: CGFloat = 0.0
    if #available(iOS 11.0, *) {
        bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
    }
    return bottomSafeAreaHeight
}()
