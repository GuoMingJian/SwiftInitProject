//
//  MainTabBarViewController.swift
//
//  Created by 郭明健 on 2020/8/20.
//  Copyright © 2020 GuoMingJian. All rights reserved.
//

import UIKit
import Foundation

class BaseTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func createTabBarViewController() -> BaseTabBarViewController {
        // 车辆
        let vehicle = MJTabBarChildController(viewControllerClass: "VehicleViewController", title: localizedString("tabbar_01"), normalImageName: "tabbar_01_normal", selectedImageName: "tabbar_01_selected")
        // 通知
        let notification = MJTabBarChildController(viewControllerClass: "NotificationViewController", title: localizedString("tabbar_02"), normalImageName: "tabbar_02_normal", selectedImageName: "tabbar_02_selected")
        // 我的
        let mine = MJTabBarChildController(viewControllerClass: "MineViewController", title: localizedString("tabbar_03"), normalImageName: "tabbar_03_normal", selectedImageName: "tabbar_03_selected")
        //
        var childs: [MJTabBarChildController] = []
        childs.append(vehicle)
        childs.append(notification)
        childs.append(mine)
        let mainTabBarVC = BaseTabBarViewController()
        mainTabBarVC.setupTabBarChildViewControllerList(childs: childs)
        
        return mainTabBarVC
    }
    
    // MARK: -
    func setupTabBarChildViewControllerList(childs: [MJTabBarChildController]) {
        for (index, item) in childs.enumerated() {
            if let viewController: UIViewController = getViewControllerFormString(stringName: item.viewControllerClass) {
                let font = UIFont.InterBold(fontSize: CGFloat(item.fontSize))
                let normalTextColor = UIColor.hexColor(color: item.normalTextColor)
                let selectedTextColor: UIColor = UIColor.hexColor(color: item.selectedTextColor) // UIColor.hexColor(color: "#0BA5EC")
                //
                viewController.tabBarItem.title = item.title
                viewController.tabBarItem.tag = index
                viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
                viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .selected)
                viewController.tabBarItem.image = UIImage(named: item.normalImageName)?.withTintColor(normalTextColor, renderingMode: .alwaysOriginal)
                viewController.tabBarItem.selectedImage = UIImage(named: item.normalImageName)?.withTintColor(selectedTextColor, renderingMode: .alwaysOriginal)
                //
                let navigationVC = BaseNavigationController(rootViewController: viewController)
                self.addChild(navigationVC)
            }
        }
        self.setupTabBarStyle()
    }
    
    fileprivate func setupTabBarStyle() {
        self.delegate = self
        self.selectedIndex = 0
        // 移除顶部线条
        self.tabBar.shadowImage = UIImage()
        // 设置背景图片
        self.tabBar.backgroundImage = UIImage.creatColorImage(.white)
        // 添加阴影
        self.tabBar.layer.shadowColor = UIColor.hexColor(color: "EEEEEE", alpha: 0.5).cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.tabBar.layer.shadowRadius = 1
        self.tabBar.layer.shadowOpacity = 0.1
        // 字体颜色
        self.tabBar.tintColor = UIColor.hexColor(color: "#0BA5EC")
        self.tabBar.unselectedItemTintColor = UIColor.hexColor(color: "#98A2B3")
        //
        if #available(iOS 13.0, *) {
            // 设置tabBar背景为白色
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            let bgColor: UIColor = .white // UIColor(241, 240, 240)
            appearance.backgroundColor = bgColor
            //            appearance.backgroundImage = UIImage.creatColorImage(bgColor)
            //            appearance.shadowImage = UIImage.creatColorImage(bgColor)
            self.tabBar.standardAppearance = appearance
            //
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
            }
        } else {
        }
    }
}

// MARK: - private functions

extension BaseTabBarViewController {
    func getViewControllerFormString(stringName: String) -> UIViewController? {
        var viewController: UIViewController?
        // 命名空间
        if let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            // class
            if let childVcClass = NSClassFromString(nameSpage + "." + stringName) {
                // 根据类型创建对应的对象
                if let childVcType = childVcClass as? UIViewController.Type {
                    viewController = childVcType.init()
                }
            }
        }
        return viewController
    }
}

// MARK: - Public
extension UITabBarController {
    /// 设置 tabbar 未读消息数[系统]
    public func showSystemUnreadMessage(index: Int,
                                        badgeValue: String?) {
        if let tabBarItems: [UITabBarItem] = self.tabBar.items {
            if index < tabBarItems.count {
                let alarmTabbar: UITabBarItem = tabBarItems[index]
                alarmTabbar.badgeValue = badgeValue
            }
        }
    }
    
    /// 设置 tabbar 未读消息数
    public func showUnreadMessage(index: Int,
                                  badgeValue: Int,
                                  xOffset: CGFloat = 1,
                                  yOffset: CGFloat = 1) {
        if let imageView: UIImageView = getTabbarImageView(index: index) {
            imageView.showUnreadMsgCount(unreadCount: badgeValue, xOffset: xOffset, yOffset: yOffset)
        }
    }
    
    /// 显示未读小红点
    public func showRedDot(index: Int,
                           xOffset: CGFloat = 1,
                           yOffset: CGFloat = 1) {
        if let imageView: UIImageView = getTabbarImageView(index: index) {
            imageView.showRedDot(xOffset: xOffset, yOffset: yOffset)
        }
    }
    
    /// 隐藏未读小红点
    public func hiddenRedDot(index: Int) {
        if let imageView: UIImageView = getTabbarImageView(index: index) {
            imageView.hiddenRedDot()
        }
    }
    
    // MARK: - Private
    /// 获取 tabbar
    private func getTabbar(index: Int) -> UITabBarItem? {
        if let tabBarItems: [UITabBarItem] = self.tabBar.items {
            if index < tabBarItems.count {
                let alarmTabbar: UITabBarItem = tabBarItems[index]
                return alarmTabbar
            }
        }
        return nil
    }
    
    /// 获取 tabbar imageView
    private func getTabbarImageView(index: Int) -> UIImageView? {
        if let tabbar: UITabBarItem = getTabbar(index: index) {
            guard let view = tabbar.value(forKey: "view") as? UIView else {
                return nil
            }
            let imageView = view.subviews.compactMap { $0 as? UIImageView }.first
            return imageView
        }
        return nil
    }
}

// MARK: - UITabBarControllerDelegate

extension BaseTabBarViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}

// MARK: -

struct MJTabBarChildController {
    let viewControllerClass: String
    let title: String
    let normalImageName: String
    let selectedImageName: String
    let fontSize: Int
    let normalTextColor: String
    let selectedTextColor: String
    
    init(viewControllerClass: String,
         title: String,
         normalImageName: String,
         selectedImageName: String,
         fontSize: Int = 12,
         normalTextColor: String = "#98A2B3",
         selectedTextColor: String = "#0BA5EC") {
        self.viewControllerClass = viewControllerClass
        self.title = title
        self.normalImageName = normalImageName
        self.selectedImageName = selectedImageName
        self.fontSize = fontSize
        self.normalTextColor = normalTextColor
        self.selectedTextColor = selectedTextColor
    }
}
