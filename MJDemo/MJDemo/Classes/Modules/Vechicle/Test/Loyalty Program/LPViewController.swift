//
//  LPViewController.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/17.
//

import UIKit

class LPViewController: BaseViewController {
    
    private lazy var floatingMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //
        let panGes: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragAction(pan:)))
        view.addGestureRecognizer(panGes)
        //
        view.addSubview(floatingMenuImageView)
        NSLayoutConstraint.activate([
            floatingMenuImageView.topAnchor.constraint(equalTo: view.topAnchor),
            floatingMenuImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            floatingMenuImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            floatingMenuImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
    
    private lazy var floatingMenuImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "floatingMenu")
        return imageView
    }()
    
    // MARK: -
    private let menuWidth: CGFloat = 60
    /// 悬浮菜单边界安全间距
    private let kFloatingMenuSafeSpac: CGFloat = 16
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(floatingMenuView)
        
        NSLayoutConstraint.activate([
            floatingMenuView.widthAnchor.constraint(equalToConstant: menuWidth),
            floatingMenuView.heightAnchor.constraint(equalTo: floatingMenuView.widthAnchor),
            floatingMenuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingMenuView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func configNavigationBar() {
        title = "Loyalty Program"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 拖拽悬浮菜单
    @objc func dragAction(pan: UIPanGestureRecognizer) {
        // 计算边界
        let dragViewSize: CGSize = (pan.view?.frame.size)!
        let minX: CGFloat = dragViewSize.width / 2 + kFloatingMenuSafeSpac
        let maxX: CGFloat = (pan.view?.superview?.frame.size.width)! - minX
        let minY: CGFloat = dragViewSize.height / 2 + kNavigationHeight + kFloatingMenuSafeSpac
        let maxY: CGFloat = (pan.view?.superview?.frame.size.height)! - (dragViewSize.height / 2 + kTabBarHeight + kFloatingMenuSafeSpac)
        //
        if pan.state == .began || pan.state == .changed {
            pan.view?.alpha = 0.7
            //
            var newPosition = pan.translation(in: pan.view)
            newPosition.x += pan.view!.center.x
            newPosition.y += pan.view!.center.y
            // 判断是否越界
            newPosition.x = newPosition.x < minX ? minX : newPosition.x
            newPosition.x = newPosition.x > maxX ? maxX : newPosition.x
            newPosition.y = newPosition.y < minY ? minY : newPosition.y
            newPosition.y = newPosition.y > maxY ? maxY : newPosition.y
            //
            pan.view?.center = newPosition
            pan.setTranslation(CGPoint.zero, in: pan.view)
        }
        if pan.state == .ended {
            pan.view?.alpha = 1
            //
            if let dragView = pan.view {
                let currentPoint: CGPoint = dragView.center
                var newPosition = currentPoint
                // 计算中心点与屏幕最近的边
                let top: CGFloat = currentPoint.y - minY
                let left: CGFloat = currentPoint.x - minX
                let bottom: CGFloat = maxY - currentPoint.y
                let right: CGFloat = maxX - currentPoint.x
                let mostSmall = [top, left, bottom, right].sorted().first
                //                if mostSmall == top {
                //                    newPosition.y = minY
                //                } else if mostSmall == left {
                //                    newPosition.x = minX
                //                } else if mostSmall == bottom {
                //                    newPosition.y = maxY
                //                } else {
                //                    newPosition.x = maxX
                //                }
                // 默认只向右吸附！
                newPosition.x = maxX
                // 靠边悬停
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    dragView.center = newPosition
                    pan.setTranslation(CGPoint.zero, in: pan.view)
                }) { (finish) in
                }
            }
        }
    }
}
