//
//  BaseNavigationController.swift
//
//  Created by 郭明健 on 2020/8/20.
//  Copyright © 2020 GuoMingJian. All rights reserved.
//

import UIKit

public var backImageName = "back.png"

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    public var isShowBottomLine: Bool = true
    /// 导航栏返回block
    public var backBlock: (()->())?
    
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 232/255, green: 234/255, blue: 238/255, alpha: 1)
        return view
    }()
    
    static var speaceItem: UIBarButtonItem = {
        let speaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        speaceItem.width = 8
        return speaceItem
    }()
    
    static var backItem: UIBarButtonItem = {
        return BaseNavigationController().getBarItem(imgName: backImageName)
    }()
    
    func getBarItem(imgName: String) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let img = UIImage(named: imgName)
        btn.setImage(img, for: .normal)
        btn.setImage(img, for: .highlighted)
        btn.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        //
        let backItem = UIBarButtonItem(customView: btn)
        return backItem
    }
    
    @objc func clickCloseButton() {
        if backBlock != nil {
            // print("自定义处理返回。")
            backBlock!()
        } else {
            if viewControllers.count > 0 {
                self.popViewController(animated: true)
            }
        }
    }
    
    //MARK:-
    public func setupUI() {
        // 状态栏背景色
        UINavigationBar.appearance().barTintColor = kNavigationColor
        UINavigationBar.appearance().backgroundColor = kNavigationColor
        self.navigationBar.barTintColor = kNavigationColor
        self.navigationBar.backgroundColor = kNavigationColor
        // 字体颜色大小
        let titleColor = UIColor.black
        self.navigationBar.titleTextAttributes = [.foregroundColor: titleColor, .font: UIFont.PFMedium(fontSize: 16)]
        // 添加阴影
        addShadow()
    }
    
    private func addShadow() {
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 1.0
        self.navigationBar.layer.shadowOpacity = 0.1
        
        if isShowBottomLine {
            self.navigationBar.addSubview(bottomLineView)
            
            NSLayoutConstraint.activate([
                bottomLineView.leadingAnchor.constraint(equalTo: self.navigationBar.leadingAnchor),
                bottomLineView.trailingAnchor.constraint(equalTo: self.navigationBar.trailingAnchor),
                bottomLineView.bottomAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
                bottomLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItems = [BaseNavigationController.speaceItem, BaseNavigationController.backItem]
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK:- 自定义导航栏：改变状态栏颜色
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

// MARK: -
// MARK: - 导航侧滑返回手势状态
@available(iOS 7.0, *)
extension UIViewController {
    private struct AssociatedKeys {
        static var popEnabled: Bool = true
    }
    
    /// 是否可右滑返回上一页，默认可以
    public var mj_PopEnabled: Bool {
        get {
            guard let popEnabled = objc_getAssociatedObject(self,  &AssociatedKeys.popEnabled) as? Bool else {
                return true
            }
            return popEnabled
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.popEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: -
    @objc
    /// 导航侧滑返回手势状态
    public var navigationInteractivePopEnabled: Bool {
        return mj_PopEnabled
    }
    
    /// 更新导航侧滑返回手势状态
    public func setNeedsNavigationInteractivePopEnabledUpdate() {
        guard let navigation = navigationController else { return }
        guard let top = navigation.topViewController else { return }
        guard top == self || top.children.contains(self) else { return }
        navigation.interactivePopGestureRecognizer?.isEnabled = navigationInteractivePopEnabled
    }
}

@available(iOS 7.0, *)
extension UINavigationController {
    
    @objc
    open override var navigationInteractivePopEnabled: Bool {
        return topViewController?.navigationInteractivePopEnabled ?? true
    }
}

@available(iOS 7.0, *)
extension UITabBarController {
    
    @objc
    open override var navigationInteractivePopEnabled: Bool {
        return selectedViewController?.navigationInteractivePopEnabled ?? true
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    @objc
    @available(iOS 2.0, *)
    open func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        return true
    }
    
    @objc
    @available(iOS 2.0, *)
    open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true
    }
    
    @objc
    @available(iOS 2.0, *)
    open func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        interactivePopGestureRecognizer?.isEnabled = topViewController?.navigationInteractivePopEnabled ?? false
    }
    
    @objc
    @available(iOS 2.0, *)
    open func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        interactivePopGestureRecognizer?.isEnabled = topViewController?.navigationInteractivePopEnabled ?? false
    }
}
