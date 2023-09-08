//
//  MJTipView.swift
//  MJSwiftKit
//
//  Created by 郭明健 on 2019/4/11.
//  Copyright © 2019 GuoMingJian. All rights reserved.
//

import UIKit

public let kMJTipViewTag: Int = 987

class MJTipView: UIView {
    /// 提示框显示位置，默认居中
    enum MJAlignment : Int {
        case center = 0
        case top = 1
        case bottom = 2
    }
    
    /// 提示框与屏幕的间距（默认30px）
    var spaceOfWindow: CGFloat?
    /// 文本与提示框的间距（默认15px）
    var spaceOfTipView: CGFloat?
    /// 文本字体
    var font: UIFont?
    
    private var label: UILabel?
    private var timeInterval: TimeInterval?
    private var currentAlignment: MJAlignment?
    private var currentContent: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Public
extension MJTipView {
    /// 弹出提示框
    static func show(_ text: String,
                     duration: CGFloat = 3.0,
                     alignment: MJAlignment = .center) {
        let tipView = MJTipView.init()
        tipView.showTipView(text: text, duration: duration, alignment: alignment)
    }
    
    /// 移除弹窗
    static func dismiss() {
        let keyWindow = UIView.getKeyWindow()
        if let view = keyWindow?.viewWithTag(kMJTipViewTag), view.isKind(of: MJTipView.self) {
            view.removeFromSuperview()
        }
    }
}

// MARK: - Private
extension MJTipView {
    /// 初始化数据
    func initData() {
        self.spaceOfWindow = 20.0
        self.spaceOfTipView = 20.0
        self.font = UIFont.systemFont(ofSize: 16)
        self.currentAlignment = .center
        self.currentContent = ""
        //
        self.label = UILabel.init()
        self.label?.textAlignment = .center
        self.label?.font = font
        self.label?.numberOfLines = 0
        self.label?.textColor = UIColor.white
        self.addSubview(self.label!)
        //
        self.backgroundColor = UIColor(red: 90 / 255, green: 90 / 255, blue: 90 / 255, alpha: 1)
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = UIColor.black.cgColor
        // 监听横竖屏切换
        NotificationCenter.default.addObserver(self, selector: #selector(orientChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func showTipView(text: String,
                     duration: CGFloat,
                     alignment: MJAlignment) {
        self.currentAlignment = alignment
        self.currentContent = text
        self.timeInterval = duration <= 0 ? Double(2.0) : Double(duration)
        self.updateUI()
        
        if let keyWindow = UIView.getKeyWindow() {
            MJTipView.dismiss()
            //
            self.tag = kMJTipViewTag
            keyWindow.addSubview(self)
        }
        
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: (.now() + timeInterval!)) {
                self.removeFromSuperview()
            }
        }
    }
    
    /// 更新UI
    func updateUI() {
        // 汉字左右对齐
        let attStr = setTextLeftRight(text: self.currentContent!)
        self.label?.attributedText = attStr
        //
        let screenH = UIScreen.main.bounds.size.height
        //        let navigationBarH = UIApplication.shared.statusBarFrame.size.height + UINavigationController.init().navigationBar.frame.height
        let navigationBarH = kNavigationHeight
        let tabBarH = UITabBarController.init().tabBar.frame.height
        //
        //        let supFrame = UIApplication.shared.keyWindow?.frame
        let supFrame = UIView.getKeyWindow()?.frame
        if supFrame == nil {
            return
        }
        let space = (spaceOfWindow! + spaceOfTipView!) * 2
        let size = CGSize.init(width: (supFrame?.size.width)! - space, height: screenH - space)
        let rect = textRect(text: currentContent!, font: font!, displaySize: size)
        
        // 默认居中
        let x = ((supFrame?.size.width)! - (rect.size.width + spaceOfTipView! * 2) ) / 2.0
        var y = ((supFrame?.size.height)! - (rect.size.height + spaceOfTipView! * 2)) / 2.0
        
        switch self.currentAlignment {
        case .center?:
            break
        case .top?:
            y = navigationBarH + spaceOfWindow!
            break
        case .bottom?:
            y = (supFrame?.size.height)! - tabBarH - spaceOfWindow! - (rect.size.height + spaceOfTipView! * 2)
            break
        default:
            break
        }
        
        //
        self.frame = CGRect.init(x: x, y: y, width: (supFrame?.size.width)! - x * 2, height: rect.size.height + spaceOfTipView! * 2)
        //
        self.label?.text = currentContent
        self.label?.frame = CGRect.init(x: spaceOfTipView!, y: spaceOfTipView!, width: self.frame.size.width - spaceOfTipView! * 2, height: self.frame.size.height - spaceOfTipView! * 2)
    }
    
    /// 屏幕旋转处理
    @objc func orientChange() {
        self.updateUI()
    }
    
    /// 移除提示框
    func removeTBTipView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    /// 文本Rect
    func textRect(text: String,
                  font: UIFont,
                  displaySize: CGSize) -> CGRect {
        let attribute = [NSAttributedString.Key.font : font]
        let options : NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading]
        let rect = (text as NSString).boundingRect(with: displaySize, options: options, attributes: attribute, context: nil)
        return rect
    }
    
    /// 汉字左右对齐
    func setTextLeftRight(text: String) -> NSAttributedString {
        let attStrM = NSMutableAttributedString.init(string: text)
        let paragraphM = NSMutableParagraphStyle.init()
        paragraphM.alignment = .justified
        paragraphM.paragraphSpacing = 11.0
        paragraphM.paragraphSpacingBefore = 10.0
        paragraphM.firstLineHeadIndent = 0.0
        paragraphM.headIndent = 0.0
        let dic : [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphM, NSAttributedString.Key.underlineStyle : 0]
        attStrM .setAttributes(dic, range: NSRange.init(location: 0, length: attStrM.length))
        let newStr = attStrM.copy() as! NSAttributedString
        return newStr
    }
}
