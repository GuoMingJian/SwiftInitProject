//
//  MFExtension.swift
//  KGPro
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

// MARK: - UIColor - 颜色
extension UIColor {
    var hexString: String? {
        if let components = cgColor.components, components.count >= 3 {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return String(format: "#%02x%02x%02x", (Int)(r * 256), (Int)(g * 256), (Int)(b * 256))
        }
        return nil
    }
    
    /// 使用rgb方式生成自定义颜色
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    convenience init(_ r: CGFloat,
                     _ g: CGFloat,
                     _ b: CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /// 使用rgba方式生成自定义颜色
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    ///   - alpha: alpha
    convenience init(_ r: CGFloat,
                     _ g: CGFloat,
                     _ b: CGFloat,
                     _ alpha: CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// SwifterSwift: Create a UIColor with different colors for light and dark mode.
    ///
    /// - Parameters:
    ///     - light: Color to use in light/unspecified mode.
    ///     - dark: Color to use in dark mode.
    convenience init(light: UIColor,
                     dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    /// 16进制生成自定义颜色
    /// - Parameters:
    ///   - color: 颜色字符串
    ///   - alpha: 透明度
    /// - Returns: UIColor
    static func hexColor(color: String,
                         alpha: CGFloat) -> UIColor {
        var colorString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if colorString.count < 6 {
            return UIColor.clear
        }
        
        if colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        
        if colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
        
        if colorString.count < 6 {
            return UIColor.clear
        }
        
        var rang = NSRange()
        rang.location = 0
        rang.length = 2
        
        let rString = (colorString as NSString).substring(with: rang)
        rang.location = 2
        let gString = (colorString as NSString).substring(with: rang)
        rang.location = 4
        let bString = (colorString as NSString).substring(with: rang)
        
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        
        return UIColor(CGFloat(r), CGFloat(g), CGFloat(b), alpha)
    }
    
    /// 16进制生成自定义颜色
    /// - Parameter color: 颜色字符串
    /// - Returns: UIColor
    static func hexColor(color: String) -> UIColor {
        return hexColor(color: color, alpha: 1.0)
    }
    
    /// 随机颜色
    static func randomColor() -> UIColor {
        return UIColor(CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)))
    }
}

// MARK: - UIFont - 字体
extension UIFont {
    // MARK: - PingFang
    /// PingFangSC-Light
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// PingFangSC-Regular
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFRegular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// PingFangSC-Medium
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFMedium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// PingFangSC-Semibold
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFSemibold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// PingFangSC-Ultralight
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFUltralight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Ultralight", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// PingFangSC-Thin
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont
    static func PFThin(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

// MARK: - UIView
extension UIView {
    /// Xib初始化
    func initFromNib() -> UIView {
        let str : String = NSStringFromClass(self.classForCoder)
        if let classStr: String = (str as NSString).components(separatedBy: ".").last {
            return UINib.init(nibName: classStr, bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        } else {
            return self
        }
    }
}

extension UIView {
    enum ViewSide {
        case left, right, top, bottom
    }
    
    /// 添加边框
    func addBorder(side: ViewSide,
                   color: UIColor,
                   thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch side {
        case .left:
            border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0.0, width: thickness, height: frame.height)
        case .top:
            border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0.0, y: frame.height - thickness, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
    
    /// 添加边框
    func addBorder(sideList: [ViewSide],
                   color: UIColor,
                   thickness: CGFloat) {
        for (_, side) in sideList.enumerated() {
            addBorder(side: side, color: color, thickness: thickness)
        }
    }
    
    /// 设置边框
    func setBorderStyle(borderWidth: CGFloat,
                        borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    /// 设置子views边框随机颜色
    func setViewsRandomBorder(borderWidth: CGFloat = 0.5) {
        self.setBorderStyle(borderWidth: borderWidth, borderColor: UIColor.randomColor())
        subviews.forEach {
            $0.setViewsRandomBorder(borderWidth: borderWidth)
            $0.setBorderStyle(borderWidth: borderWidth, borderColor: UIColor.randomColor())
        }
    }
    
    /// 获取所有子View
    func getAllSubViews(rootView: UIView) -> Array<UIView> {
        var viewList: Array<UIView> = Array()
        for view in rootView.subviews {
            if view.subviews.count > 0 {
                viewList.append(contentsOf: getAllSubViews(rootView: view))
            } else {
                viewList.append(view)
            }
        }
        return viewList
    }
    
    /// 清除所有子View
    func removeAllSubViews() {
        subviews.forEach {
            $0.removeAllSubViews()
            $0.removeFromSuperview()
        }
    }
    
    /// 清除所有约束
    func cleanupConstraints() {
        removeConstraints(constraints)
        subviews.forEach { view in
            view.removeConstraints(view.constraints)
        }
    }
    
    /// 设置圆角
    func setCornerRadius(radius: CGFloat = 5) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 切圆角
    func setCornerRadius(conrners: UIRectCorner ,
                         radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 设置渐变色 [不起效果，需要验证]
    func setGradient(startColor: UIColor,
                     endColor: UIColor,
                     startPoint: CGPoint,
                     endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor, endColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        layer.insertSublayer(gradient, at: 0)
    }
    
    /// 添加阴影
    func addShadow(color: UIColor,
                   shadowOpacity: Float,
                   shadowRadius: CGFloat,
                   shadowOffset: CGSize,
                   cornerRadius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.cornerRadius = cornerRadius
    }
    
    /// 获取 keyWindow
    static func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 获取当前控制器
    static func topMostController() -> UIViewController {
        var topViewController: UIViewController?
        
        let keyWindow = UIView.getKeyWindow()
        topViewController = keyWindow?.rootViewController
        
        while(true) {
            if let vc = topViewController?.presentedViewController {
                topViewController = vc
            } else if let vc = topViewController, vc.isKind(of: UINavigationController.classForCoder()) {
                topViewController = (vc as! UINavigationController).topViewController
            } else if let vc = topViewController, vc.isKind(of: UITabBarController.classForCoder()) {
                topViewController = (vc as! UITabBarController).selectedViewController
            } else {
                break
            }
        }
        
        return topViewController ?? UIViewController()
    }
    
    /// 设置状态栏颜色
    static func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let tag = 987654321
            let keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            if let statusBar = keyWindow?.viewWithTag(tag) {
                statusBar.backgroundColor = color
            } else {
                let statusBar = UIView(frame: keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
                if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = color
                }
                statusBar.tag = tag
                keyWindow?.addSubview(statusBar)
            }
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = color
            }
        }
    }
    
    /// 获取状态栏颜色
    static func getStatusBarBackgroundColor() -> UIColor? {
        if #available(iOS 13.0, *) {
            let tag = 987654321
            let keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar.backgroundColor
            } else {
                let statusBar = UIView(frame: keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
                return statusBar.backgroundColor
            }
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            return statusBar.backgroundColor
        }
    }
    
    /// 获取控件截图
    public func screenshotsImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    /// 旋转角度
    func rotationAngle(angle: CGFloat) {
        let value = angle / 360
        self.transform = CGAffineTransformMakeRotation(CGFloat(.pi * 2 * value))
    }
    
    /// 缩放动画
    public func setScale(x: CGFloat,
                         y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
    
    /// 位移动画，由下到上
    public func showMove(duration: TimeInterval = 0.2,
                         bgView: UIView? = nil,
                         bgColor: UIColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5)) {
        bgView?.backgroundColor = .clear
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let height: CGFloat = self.height
        //
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.transform = self.transform.translatedBy(x: 0, y: height)
        } completion: { isFinish1 in
            if isFinish1 {
                UIView.animate(withDuration: duration) {
                    self.transform = self.transform.translatedBy(x: 0, y: -height)
                } completion: { isFinish2 in
                    if isFinish2 {
                        bgView?.backgroundColor = bgColor
                    }
                }
            }
        }
    }
    
    public func dismissMove(duration: TimeInterval = 0.2,
                            bgView: UIView? = nil) {
        bgView?.backgroundColor = .clear
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let height: CGFloat = self.height
        //
        UIView.animate(withDuration: duration) { [self] in
            self.transform = self.transform.translatedBy(x: 0, y: height)
        } completion: { [self] isFinish in
            if isFinish {
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
    
    /// 放大动画展示
    public func showScale(duration: TimeInterval = 0.2,
                          bgView: UIView? = nil,
                          bgColor: UIColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.5),
                          isShowZoomAnimation: Bool = false) {
        if isShowZoomAnimation {
            bgView?.backgroundColor = .clear
            self.setScale(x: 0, y: 0)
            UIView.animate(withDuration: duration) { [self] in
                self.setScale(x: 1, y: 1)
            } completion: { [self] _ in
                //
                UIView.animate(withDuration: duration) { [self] in
                    self.setScale(x: 0.8, y: 0.8)
                } completion: { [self] _ in
                    //
                    UIView.animate(withDuration: duration) { [self] in
                        self.setScale(x: 1, y: 1)
                    } completion: { isFinish in
                        if isFinish {
                            bgView?.backgroundColor = bgColor
                        }
                    }
                }
            }
        } else {
            bgView?.backgroundColor = .clear
            self.setScale(x: 0, y: 0)
            UIView.animate(withDuration: duration) { [self] in
                self.setScale(x: 1, y: 1)
                bgView?.backgroundColor = bgColor
            }
        }
    }
    
    /// 缩小动画隐藏
    public func dismissScale(duration: TimeInterval = 0.2,
                             bgView: UIView? = nil) {
        bgView?.backgroundColor = .clear
        UIView.animate(withDuration: duration) { [self] in
            self.setScale(x: 0.1, y: 0.1)
        } completion: { [self] isFinish in
            if isFinish {
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
    
    /// 设置渐变色
    public func setGradientColor(startColor: UIColor,
                                 endColor: UIColor) {
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let gradientImage = UIImage.gradientImageWithBounds(bounds: self.bounds, colors: [startColor.cgColor, endColor.cgColor])
        //
        if self.isKind(of: UILabel.classForCoder()) {
            let label: UILabel = self as! UILabel
            label.textColor = UIColor(patternImage: gradientImage)
        } else if self.isKind(of: UIButton.classForCoder()) {
            let button: UIButton = self as! UIButton
            button.setBackgroundImage(gradientImage, for: .normal)
        }
    }
}

// MARK: - UIView -> Frame
extension UIView {
    var origin: CGPoint {
        set {
            self.frame.origin = newValue
        }
        get {
            self.frame.origin
        }
    }
    
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            self.frame.size
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            self.frame.size.height
        }
    }
    
    /// 上
    var top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            self.frame.origin.y
        }
    }
    
    /// 左
    var left: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            self.frame.origin.x
        }
    }
    
    /// 下
    var bottom: CGFloat {
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
        get {
            self.frame.origin.y + self.frame.size.height
        }
    }
    
    /// 右
    var right: CGFloat {
        set {
            self.frame.origin.x += newValue - (self.frame.origin.x + self.frame.size.width)
        }
        get {
            self.frame.origin.x + self.frame.size.width
        }
    }
    
    /// 左上
    var topLeft: CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
    }
    
    /// 左下
    var bottomLeft: CGPoint {
        let x = self.frame.origin.x
        let y = self.frame.origin.y + self.frame.size.height
        return CGPoint(x: x, y: y)
    }
    
    /// 右上
    var topRight: CGPoint {
        let x = self.frame.origin.x + self.frame.size.width
        let y = self.frame.origin.y
        return CGPoint(x: x, y: y)
    }
    
    /// 右下
    var bottomRight: CGPoint {
        let x = self.frame.origin.x + self.frame.size.width
        let y = self.frame.origin.y + self.frame.size.height
        return CGPoint(x: x, y: y)
    }
}

// MARK: - UIView -> 未读消息，红点
extension UIView {
    /// 未读消息（小红点）
    func showRedDot(dotColor: UIColor = .red,
                    dotWidth: CGFloat = 9,
                    xOffset: CGFloat = 1,
                    yOffset: CGFloat = 1) {
        hiddenRedDot()
        self.layoutIfNeeded()
        //
        let dotView = UIView()
        dotView.setCornerRadius(radius: CGFloat(dotWidth / 2.0))
        dotView.backgroundColor = dotColor
        dotView.tag = 1991
        self.addSubview(dotView)
        //
        let superWidth = self.frame.size.width
        let x: CGFloat = superWidth - (dotWidth / 2 - xOffset)
        let y: CGFloat = -(dotWidth / 2 - yOffset)
        let rect: CGRect = CGRect(x: x, y: y, width: dotWidth, height: dotWidth)
        dotView.frame = rect
    }
    
    /// 隐藏小红点
    func hiddenRedDot() {
        let dotView = self.viewWithTag(1991)
        if dotView != nil {
            dotView!.removeFromSuperview()
        }
    }
    
    /// 显示未读消息，unreadCount <= 0 时，隐藏
    func showUnreadMsgCount(unreadCount: Int,
                            txtFont: UIFont = UIFont.PFMedium(fontSize: 10),
                            xOffset: CGFloat = 1,
                            yOffset: CGFloat = 1) {
        hiddenUnreadMsgDot()
        if unreadCount <= 0 {
            return
        }
        
        var dotWidth: CGFloat = 16
        if unreadCount > 9, unreadCount < 99 {
            dotWidth = 18
        }
        if unreadCount >= 99 {
            dotWidth = 22
        }
        
        self.layoutIfNeeded()
        //
        let dotView = UIView()
        dotView.setCornerRadius(radius: CGFloat(dotWidth / 2.0))
        dotView.backgroundColor = UIColor.red
        dotView.tag = 1992
        self.addSubview(dotView)
        //
        let superWidth = self.frame.size.width
        let x: CGFloat = superWidth - (dotWidth / 2 - xOffset)
        let y: CGFloat = -(dotWidth / 2 - yOffset)
        let rect: CGRect = CGRect(x: x, y: y, width: dotWidth, height: dotWidth)
        dotView.frame = rect
        //
        let label = UILabel()
        label.text = "\(unreadCount)"
        if unreadCount >= 99 {
            label.text = "99+"
        }
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = txtFont
        label.textAlignment = .center
        dotView.addSubview(label)
        //
        label.frame = dotView.bounds
    }
    
    /// 隐藏未读消息
    func hiddenUnreadMsgDot() {
        let dotView = self.viewWithTag(1992)
        if dotView != nil {
            dotView!.removeFromSuperview()
        }
    }
}

// MARK: - Date
extension Date {
    static func getDateFormatter(timeZone: TimeZone,
                                 dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    /// Date->String
    static func dateToString(date: Date,
                             dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    /// String -> Date
    static func stringToDate(dateString: String,
                             dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return Date()
    }
    
    /// 时间戳 转 字符串
    static func timestampToString(timestamp: Int,
                                  dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let newTimestamp = updateTimestamp(timestamp)
        let date = Date(timeIntervalSince1970: TimeInterval(newTimestamp))
        let dateString = dateToString(date: date, dateFormat: dateFormat)
        return dateString
    }
    
    /// 时间戳 转 字符串
    static func timestampToString(timestampStr: String,
                                  dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        var newTimestamp = timestampStr
        if newTimestamp.count > 10 {
            newTimestamp = (newTimestamp as NSString).substring(to: 10)
        }
        let timeInt: Int = Int(newTimestamp) ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timeInt))
        let dateString = dateToString(date: date, dateFormat: dateFormat)
        return dateString
    }
    
    static func updateTimestamp(_ timestamp: Int) -> Int {
        var temp = "\(timestamp)"
        if temp.count > 10 {
            // 13位 转 10位
            temp = (temp as NSString).substring(to: 10)
        }
        let newTimestamp: Int = Int(temp) ?? 0
        return newTimestamp
    }
    
    /// 时间戳 转 date
    static func timestampToDate(timestamp: Int) -> Date {
        let newTimestamp = updateTimestamp(timestamp)
        let date = Date(timeIntervalSince1970: TimeInterval(newTimestamp))
        return date
    }
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: String {
        let time = self.timeIntervalSince1970
        let timeString = String(format: "%0.f", time)
        return timeString
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var msTimeStamp: String {
        let time = self.timeIntervalSince1970 * 1000
        let timeString = String(format: "%0.f", time)
        return timeString
    }
    
    func isGreater(than date: Date) -> Bool {
        return self > date
    }
    
    func isSmaller(than date: Date) -> Bool {
        return self < date
    }
    
    func isEqual(to date: Date) -> Bool {
        return self == date
    }
}

// MARK: - UILabel
extension UILabel {
    /// 富文本
    public func setAttributes(subStrList: Array<String>,
                              color: UIColor) {
        let text: String = self.text!
        let font: UIFont = self.font
        let attM: NSMutableAttributedString = NSMutableAttributedString(string: text)
        for str in subStrList {
            var rangeList: Array<NSRange> = Array()
            var supStr = text
            var index: Int = 0
            while supStr.count > 0 {
                if supStr.contains(str) {
                    var range = (supStr as NSString).range(of: str)
                    supStr = (supStr as NSString).substring(from: range.location + range.length)
                    //
                    range.location += index
                    index = range.location + range.length
                    rangeList.append(range)
                } else {
                    supStr = ""
                }
            }
            //
            let att = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color]
            for range in rangeList {
                attM.addAttributes(att, range: range)
            }
        }
        self.attributedText = attM
    }
}

// MARK: String -> 特殊处理
extension String {
    /// 去除字符串中的所有空格
    /// - Returns: 返回处理后的结果
    public func trimmingAllWhiteSpaces() -> String {
        let tempStr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return tempStr.replacingOccurrences(of: " ", with: "")
    }
    
    /// 判断是否是空符串（去除空格之后）
    public func isEmptyString() -> Bool {
        return self.trimmingAllWhiteSpaces().isEmpty
    }
    
    /// 移除末尾0
    static func removeZero(double: Double) -> String {
        let string = String(format: "%f", double)
        return removeZero(string: string)
    }
    
    /// 移除末尾0
    static func removeZero(string: String) -> String {
        let result = string
        if result.contains(".") {
            var newResult = result
            var i = 1
            while i < result.count {
                if newResult.hasSuffix("0") {
                    newResult.remove(at: newResult.index(before: newResult.endIndex))
                    i = i + 1
                } else {
                    break
                }
            }
            if newResult.hasSuffix(".") {
                newResult.remove(at: newResult.index(before: newResult.endIndex))
            }
            return newResult
        } else {
            return result
        }
    }
    
    /// 字符串Base64编码
    /// - Returns: 编码后的字符串
    public func Base64Encoding() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    public func toInt() -> Int {
        var value: Int = 0
        value = Int(self) ?? 0
        return value
    }
    
    public func toDecimal() -> String {
        let largeNumber: NSNumber = NSDecimalNumber(string: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: largeNumber)
        return formattedNumber ?? ""
    }
    
    /// app 版本号
    static func appVersion() -> String {
        let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return appVersion
    }
    
    /// app Build号
    static func appBuild() -> String {
        let appBuild: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return appBuild
    }
    
    // MARK: - 沙盒目录
    /// Document 目录
    static func getDocumentPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documnetPath = documentPaths[0]
        return documnetPath
    }
    
    /// Library 目录
    static func getLibraryPath() -> String {
        let libraryPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let libraryPath = libraryPaths[0]
        return libraryPath
    }
    
    /// Temp 目录
    static func getTempPath() -> String {
        let tempPath = NSTemporaryDirectory()
        return tempPath
    }
    
    /// Library/Caches目录
    static func getLibraryCachePath() -> String {
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = cachePaths[0]
        return cachePath
    }
    
    // MARK: - JSON
    /// JsonString 转 NSDictionary
    public func toDictionary() -> NSDictionary {
        if let jsonData: Data = self.data(using: .utf8) {
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            if dict != nil {
                return dict as! NSDictionary
            }
        }
        return NSDictionary()
    }
    
    /// JsonString 转 NSArray
    public func toArray() -> NSArray {
        if let jsonData: Data = self.data(using: .utf8) {
            let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            if array != nil {
                return array as! NSArray
            }
        }
        return NSArray()
    }
    
    /// NSDictionary 转 JsonString
    static func dictionaryToJson(dictionary: NSDictionary) -> String {
        if !JSONSerialization.isValidJSONObject(dictionary) {
            print("无法解析出JSONString")
            return ""
        }
        let data: NSData = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    /// NSArray 转 JsonString
    static func arrayToJson(array: NSArray) -> String {
        if !JSONSerialization.isValidJSONObject(array) {
            print("无法解析出JSONString")
            return ""
        }
        
        let data: NSData = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    /// Dictionary -> Data
    static func dictionaryToData(jsonDic: Dictionary<String, Any>) -> Data? {
        if !JSONSerialization.isValidJSONObject(jsonDic) {
            print("解析失败：不是一个有效的json对象！")
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        // Data转换成String打印输出
        // let str = String(data:data!, encoding: String.Encoding.utf8)
        // 输出json字符串
        // print("Json Str:\(str!)")
        return data
    }
    
    /// Data -> Dictionary
    static func dataToDictionary(data: Data) -> Dictionary<String, Any>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch _ {
            print("Data -> Dictionary 解析失败！")
            return nil
        }
    }
    
    /// Dictionary 转 model
    static func performTransToModelObject<T: Decodable>(type: T.Type,
                                                        dictionary: Dictionary<String, Any>) throws -> T? {
        do {
            if let jsonData: Data = String.dictionaryToData(jsonDic: dictionary) {
                let obj = try JSONDecoder().decode(type.self, from: jsonData)
                return obj
            }
        } catch {
            print("Decode Error>>> \(error)")
        }
        return nil
    }
    
    /// NSArray 转 model
    static func performTransToModelObject<T: Decodable>(type: T.Type,
                                                        array: NSArray) throws -> T? {
        do {
            let json = String.arrayToJson(array: array)
            let dictionary: Dictionary<String, Any> = json.dictionary ?? [:]
            if let jsonData: Data = String.dictionaryToData(jsonDic: dictionary) {
                let obj = try JSONDecoder().decode(type.self, from: jsonData)
                return obj
            }
        } catch {
            print("Decode Error>>> \(error)")
        }
        return nil
    }
    
    // MARK: - 随机字符串
    static func randomString(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func randomIntString(length: Int) -> Int {
        let letters: NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return Int(randomString) ?? 0
    }
    
    // MARK: -
    public func drawText(text: NSString,
                         rect: CGRect,
                         font: UIFont,
                         color: UIColor) {
        let textAttributedString: Dictionary<NSAttributedString.Key, Any> = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        text.draw(in: rect, withAttributes: textAttributedString)
    }
    
    /// 文本的高度
    public func textHeight(font: UIFont,
                           width: CGFloat) -> CGFloat {
        
        let height = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                       options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesDeviceMetrics.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue),
                                       attributes: [NSAttributedString.Key.font: font], context: nil).size.height
        return height
    }
    
    /// 文本的宽度
    public func textWidth(font: UIFont,
                          height: CGFloat) -> CGFloat {
        
        let width = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                      options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)
                                      , attributes: [NSAttributedString.Key.font:font], context: nil).size.width
        return width
    }
}

extension Int {
    /// 转字符串
    public func toString() -> String {
        let str = String(format: "%d", self)
        return str
    }
}

// MARK: - Encodable
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }
    }
    
    var json: String {
        var json = ""
        if let dict: NSDictionary = self.dictionary as? NSDictionary {
            json = String.dictionaryToJson(dictionary: dict)
        }
        return json
    }
}

// MARK: - UIStackView
extension UIStackView {
    static func stackView(axis: NSLayoutConstraint.Axis,
                          alignment: Alignment = .fill,
                          distribution: Distribution = .fill,
                          spacing: CGFloat = 0.0) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}

// MARK: - 按钮添加下划线
extension UIButton {
    /// 按钮添加下划线
    func addBottomLine(spac: Int = 1) {
        let text: String = self.titleLabel?.text ?? ""
        //
        let str = NSMutableAttributedString(string: text)
        let strRange = NSRange(location: 0, length: str.length)
        // 此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue + spac)
        //
        let lineColor: UIColor = self.titleLabel!.textColor
        let font: UIFont = self.titleLabel!.font
        //
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: lineColor,
                           NSAttributedString.Key.font: font], range: strRange)
        //
        self.setAttributedTitle(str, for: UIControl.State.normal)
    }
    
    func showLoading() {
        let text: String = self.titleLabel?.text ?? ""
        let font: UIFont = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 17)
        let textWidth: CGFloat = ceil(text.textWidth(font: font, height: self.height))
        let offset: CGFloat = 5
        let widthPercent: CGFloat = 1
        let halfIconWidth: CGFloat = 20 * widthPercent / 2
        //
        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activity)
        activity.tag = 1991
        activity.color = .white
        let transform = CGAffineTransformMakeScale(widthPercent, widthPercent)
        activity.transform = transform
        activity.startAnimating()
        //
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: centerXAnchor, constant: textWidth / 2 + halfIconWidth + offset)
        ])
    }
    
    func hiddenLoading() {
        for view in self.subviews {
            if view.tag == 1991, view.isKind(of: UIActivityIndicatorView.classForCoder()) {
                view.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    /// 用颜色创建一张图片
    static func creatColorImage(_ color: UIColor,
                                _ ARect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
        let rect = ARect
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 渐变颜色
    static func gradientImageWithBounds(bounds: CGRect,
                                        colors: [CGColor]) -> UIImage {
        if bounds == .zero {
            return UIImage.creatColorImage(.black)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UITextView {
    /// 插入图片
    public func insertPicture(_ image: UIImage) {
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        // 创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        imgAttachment.image = image
        //        imgAttachment.bounds = CGRect(x: 0, y: -6, width: self.font!.lineHeight,
        //                                      height: self.font!.lineHeight)
        let yOffset: CGFloat = -10
        imgAttachment.bounds = CGRect(x: 0, y: yOffset, width: image.size.width,
                                      height: image.size.height)
        
        let imgAttachmentString: NSAttributedString = NSAttributedString(attachment: imgAttachment)
        
        // 获得目前光标的位置
        let selectedRange = self.selectedRange
        // 插入图片
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        
        let font: UIFont = self.font ?? UIFont.systemFont(ofSize: 16)
        // 设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: font,
                                range: NSMakeRange(0, mutableStr.length))
        // 再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        // 重新给文本赋值
        self.attributedText = mutableStr
        // 恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.selectedRange = newSelectedRange
        // 移动滚动条（确保光标在可视区域内）
        self.scrollRangeToVisible(newSelectedRange)
    }
    
    /// 插入文字
    public func insertString(_ text: String) {
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        // 获得目前光标的位置
        let selectedRange = self.selectedRange
        // 插入文字
        let attStr = NSAttributedString(string: text)
        mutableStr.insert(attStr, at: selectedRange.location)
        
        let font: UIFont = self.font ?? UIFont.systemFont(ofSize: 16)
        
        // 设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: font,
                                range: NSMakeRange(0, mutableStr.length))
        // 再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        // 重新给文本赋值
        self.attributedText = mutableStr
        // 恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.selectedRange = newSelectedRange
    }
}
