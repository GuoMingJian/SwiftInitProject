//
//  MJExtension.swift
//  MJKit
//
//  Created by 郭明健 on 2023/6/20.
//

import UIKit
// import CommonCrypto
import Photos           // UIImage
import QuartzCore       // CALayer

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
    
    // MARK: - Inter
    /// Inter-Regular
    /// - Parameter fontSize: 字体大小
    /// - Returns: descriptionUIFont
    static func InterRegular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// Inter-Medium
    /// - Parameter fontSize: 字体大小
    /// - Returns: descriptionUIFont
    static func InterMedium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// Inter-Bold
    /// - Parameter fontSize: 字体大小
    /// - Returns: descriptionUIFont
    static func InterBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// Inter-Light
    /// - Parameter fontSize: 字体大小
    /// - Returns: descriptionUIFont
    static func InterLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

// MARK: - UIView
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
                    dotWidth: CGFloat = 10,
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

// MARK: - Array
extension Array where Element: Equatable {
    public mutating func remove(_ item: Element) {
        if let idx = firstIndex(of: item) {
            remove(at: idx)
        }
    }
    
    public mutating func remove(_ items: [Element]) {
        for item in items {
            remove(item)
        }
    }
    
    public mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
    
    func safeObject(at index: Array.Index) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
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
}

// MARK: - UIImageView
/// 扩展-添加圆角
extension UIImageView {
    /// 添加圆角
    func addCorners(radius: CGFloat) {
        self.image = self.image?.addCorners(radius: radius, sizetoFit: self.bounds.size)
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
    
    /// 给Image添加圆角
    func addCorners(radius: CGFloat,
                    sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                                            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()!.clip()
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
    /// 二维码生成
    static func setupQRCodeImage(_ text: String,
                                 image: UIImage?) -> UIImage {
        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        // 将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        // 取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            // 生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            // 如果有一个头像的话，将头像加入二维码中心
            if var image = image {
                // 白色圆边
                // image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
                // 白色圆角矩形边
                image = rectangleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
                // 合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 70, height: 70)
                
                return newImage
            }
            return qrCodeImage
        }
        //
        return UIImage()
    }
    
    /// 生成高清的UIImage
    private static func setupHighDefinitionUIImage(_ image: CIImage,
                                                   size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion)
        bitmapRef.draw(bitmapImage, in: integral)
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    /// 生成矩形边框
    private static func rectangleImageWithImage(_ sourceImage: UIImage,
                                                borderWidth: CGFloat,
                                                borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let bezierPath = UIBezierPath.init(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height), cornerRadius: 1)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// 生成圆形边框
    private static func circleImageWithImage(_ sourceImage: UIImage,
                                             borderWidth: CGFloat,
                                             borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width : sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    private static func syntheticImage(_ image: UIImage,
                                       iconImage:UIImage,
                                       width: CGFloat,
                                       height: CGFloat) -> UIImage{
        // 开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        // 绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        // 取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        // 返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    /// Save image to album.
    @objc public class func saveImageToAlbum(image: UIImage,
                                             completion: ((Bool, PHAsset?) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .denied || status == .restricted {
            completion?(false, nil)
            return
        }
        
        var placeholderAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let newAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset
        }) { suc, _ in
            DispatchQueue.main.async {
                if suc {
                    let asset = self.getAsset(from: placeholderAsset?.localIdentifier)
                    completion?(suc, asset)
                } else {
                    completion?(false, nil)
                }
            }
        }
    }
    
    private class func getAsset(from localIdentifier: String?) -> PHAsset? {
        guard let id = localIdentifier else {
            return nil
        }
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        if result.count > 0 {
            return result[0]
        }
        return nil
    }
    
    /// base64 String 转 Image
    static func form(base64String: String) -> UIImage {
        var data = base64String.data(using: String.Encoding.utf8)
        var imageData = Data.init(base64Encoded: data!, options: .ignoreUnknownCharacters)
        if imageData == nil {
            let newStr = base64String + "=="
            data = newStr.data(using: String.Encoding.utf8)
            imageData = Data.init(base64Encoded: data!, options: .ignoreUnknownCharacters)
            // 如果数据不正确，添加"=="重试
        }
        var image: UIImage?
        if imageData != nil {
            image = UIImage(data: imageData!) // 转换内容
        } else {
            image = UIImage.init()
        }
        return image!
    }
    
    /// Image 转 base64 String
    func toBase64String() -> String {
        let imageData = self.pngData()
        let base64String = "data:image/png;base64," + (imageData?.base64EncodedString() ?? "") + "=="
        return base64String
    }
}

// MARK: - Date
extension Date {
    static func getCurrentDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.init(identifier: getSystemLanguageIdentifier())
        
        return dateFormatter
    }
    
    static func getSystemLanguageIdentifier() -> String {
        let languageIdentifier: String = NSLocale.preferredLanguages.first ?? "en_US"
        return languageIdentifier
    }
    
    static func getCurrentDateFormatter(timeZone: TimeZone) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.init(identifier: getSystemLanguageIdentifier())
        dateFormatter.timeZone = timeZone
        
        return dateFormatter
    }
    
    static func getDateFormatter(timeZone: TimeZone,
                                 dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    static func getUTCDateFormatter(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = utcTimeZone()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    /// UTC TimeZone
    static func utcTimeZone() -> TimeZone {
        let timeZone: TimeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return timeZone
    }
    
    /// string -> UTC date
    static func getUTCDate(dateString: String,
                           dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return getDateFrom(dateString: dateString, dateFormat: dateFormat, timeZone: utcTimeZone())
    }
    
    /// date -> UTC date
    static func getUTCDate(date: Date,
                           dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateString = getStringFrom(date: date, dateFormat: dateFormat, timeZone: utcTimeZone())
        let newDate = getDateFrom(dateString: dateString ?? "", dateFormat: dateFormat, timeZone: utcTimeZone())
        return newDate
    }
    
    /// date -> UTC string
    static func getUTCString(date: Date,
                             dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        return getStringFrom(date: date, dateFormat: dateFormat, timeZone: utcTimeZone())
    }
    
    static func getDateFrom(dateString: String,
                            dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                            timeZone: TimeZone) -> Date? {
        var dateToReturn: Date?
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: timeZone.identifier)
        formatter.dateFormat = dateFormat
        dateToReturn = formatter.date(from: dateString)
        return dateToReturn
    }
    
    static func getStringFrom(date: Date,
                              dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                              timeZone: TimeZone) -> String? {
        var stringToReturn: String?
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: timeZone.identifier)
        formatter.dateFormat = dateFormat
        stringToReturn = formatter.string(from: date)
        
        return stringToReturn
    }
    
    /// Date->String
    static func dateToString(date: Date,
                             dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    /// Date->String
    static func dateToString(date: Date,
                             dateFormatter: DateFormatter = getCurrentDateFormatter()) -> String {
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
    
    /// String -> Date
    static func stringToDate(dateString: String,
                             dateFormatter: DateFormatter = getCurrentDateFormatter()) -> Date {
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
    
    /// 时间戳 转 字符串
    static func timestampToString(timestamp: Int,
                                  dateFormatter: DateFormatter = getCurrentDateFormatter()) -> String {
        let newTimestamp = updateTimestamp(timestamp)
        let date = Date(timeIntervalSince1970: TimeInterval(newTimestamp))
        let dateString = dateToString(date: date, dateFormatter: dateFormatter)
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
    
    /// 获取与当前年份相差值，负数为前x年，正数为后x年
    static func newYearWithCount(date: Date,
                                 count: Int) -> String {
        let calender = Calendar(identifier: .gregorian)
        var components = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        var newYear = ""
        if components.year != nil {
            components.year! += count
            if let newData = calender.date(from: components) {
                newYear = dateToString(date: newData, dateFormat: "yyyy")
            }
        }
        return newYear
    }
    
    /// 获取与当前天数相差值，负数为前x天，正数为后x天
    static func newDayWithCount(date: Date,
                                count: Int,
                                dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let calender = Calendar(identifier: .gregorian)
        var components = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        var result = ""
        if components.day != nil {
            components.day! += count
            if let newData = calender.date(from: components) {
                result = dateToString(date: newData, dateFormat: dateFormat)
            }
        }
        return result
    }
    
    /// 获取与当前天数相差值，负数为前x天，正数为后x天
    static func newDayWithCount(date: Date,
                                count: Int,
                                dateFormatter: DateFormatter) -> String {
        let calender = Calendar(identifier: .gregorian)
        var components = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        var result = ""
        if components.day != nil {
            components.day! += count
            if let newData = calender.date(from: components) {
                result = dateToString(date: newData, dateFormatter: dateFormatter)
            }
        }
        return result
    }
    
    func isGreater(than date: Date) -> Bool {
        return self >= date
    }
    
    func isSmaller(than date: Date) -> Bool {
        return self < date
    }
    
    func isEqual(to date: Date) -> Bool {
        return self == date
    }
}

// MARK: - String
extension String {
    /// 将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    /// 将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
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
    func toDictionary() -> NSDictionary {
        if let jsonData: Data = self.data(using: .utf8) {
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            if dict != nil {
                return dict as! NSDictionary
            }
        }
        return NSDictionary()
    }
    
    /// JsonString 转 NSArray
    func toArray() -> NSArray {
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
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
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
        let letters : NSString = "0123456789"
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
    func textWidth(font: UIFont,
                   height: CGFloat) -> CGFloat {
        
        let width = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                      options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)
                                      , attributes: [NSAttributedString.Key.font:font], context: nil).size.width
        return width
    }
}

// MARK: - String -> MD5
extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let message = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return [UInt8](bytes)
        }
        
        let MD5Calculator = MD5(message)
        let MD5Data = MD5Calculator.calculate()
        
        var MD5String = String()
        for c in MD5Data {
            MD5String += String(format: "%02x", c)
        }
        return MD5String
    }
}

// array of bytes, little-endian representation
func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)
    
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value
    
    let bytes = valuePointer.withMemoryRebound(to: UInt8.self, capacity: totalBytes) { (bytesPointer) -> [UInt8] in
        var bytes = [UInt8](repeating: 0, count: totalBytes)
        for j in 0..<min(MemoryLayout<T>.size, totalBytes) {
            bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
        }
        return bytes
    }
    
    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()
    
    return bytes
}

extension Int {
    // Array of bytes with optional padding (little-endian)
    func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
}

extension NSMutableData {
    // Convenient way to append bytes
    func appendBytes(_ arrayOfBytes: [UInt8]) {
        append(arrayOfBytes, length: arrayOfBytes.count)
    }
}

protocol HashProtocol {
    var message: [UInt8] { get }
    // Common part for hash calculation. Prepare header data.
    func prepare(_ len: Int) -> [UInt8]
}

extension HashProtocol {
    func prepare(_ len: Int) -> [UInt8] {
        var tmpMessage = message
        
        // Step 1. Append Padding Bits
        tmpMessage.append(0x80) // append one bit (UInt8 with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.count
        var counter = 0
        
        while msgLength % len != (len - 8) {
            counter += 1
            msgLength += 1
        }
        
        tmpMessage += [UInt8](repeating: 0, count: counter)
        return tmpMessage
    }
}

func toUInt32Array(_ slice: ArraySlice<UInt8>) -> [UInt32] {
    var result = [UInt32]()
    result.reserveCapacity(16)
    
    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: MemoryLayout<UInt32>.size) {
        let d0 = UInt32(slice[idx.advanced(by: 3)]) << 24
        let d1 = UInt32(slice[idx.advanced(by: 2)]) << 16
        let d2 = UInt32(slice[idx.advanced(by: 1)]) << 8
        let d3 = UInt32(slice[idx])
        let val: UInt32 = d0 | d1 | d2 | d3
        
        result.append(val)
    }
    return result
}

struct BytesIterator: IteratorProtocol {
    
    let chunkSize: Int
    let data: [UInt8]
    
    init(chunkSize: Int, data: [UInt8]) {
        self.chunkSize = chunkSize
        self.data = data
    }
    
    var offset = 0
    
    mutating func next() -> ArraySlice<UInt8>? {
        let end = min(chunkSize, data.count - offset)
        let result = data[offset..<offset + end]
        offset += result.count
        return result.count > 0 ? result : nil
    }
}

struct BytesSequence: Sequence {
    let chunkSize: Int
    let data: [UInt8]
    
    func makeIterator() -> BytesIterator {
        return BytesIterator(chunkSize: chunkSize, data: data)
    }
}

func rotateLeft(_ value: UInt32, bits: UInt32) -> UInt32 {
    return ((value << bits) & 0xFFFFFFFF) | (value >> (32 - bits))
}

class MD5: HashProtocol {
    
    static let size = 16 // 128 / 8
    let message: [UInt8]
    
    init (_ message: [UInt8]) {
        self.message = message
    }
    
    // specifies the per-round shift amounts
    private let shifts: [UInt32] = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]
    
    // binary integer part of the sines of integers (Radians)
    private let sines: [UInt32] = [0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
                                   0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                                   0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
                                   0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                                   0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
                                   0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
                                   0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
                                   0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                                   0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
                                   0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                                   0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x4881d05,
                                   0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                                   0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
                                   0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                                   0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
                                   0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]
    
    private let hashes: [UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    
    func calculate() -> [UInt8] {
        var tmpMessage = prepare(64)
        tmpMessage.reserveCapacity(tmpMessage.count + 4)
        
        // hash values
        var hh = hashes
        
        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits = (message.count * 8)
        let lengthBytes = lengthInBits.bytes(64 / 8)
        tmpMessage += lengthBytes.reversed()
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        
        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            let M = toUInt32Array(chunk)
            assert(M.count == 16, "Invalid array")
            
            // Initialize hash value for this chunk:
            var A: UInt32 = hh[0]
            var B: UInt32 = hh[1]
            var C: UInt32 = hh[2]
            var D: UInt32 = hh[3]
            
            var dTemp: UInt32 = 0
            
            // Main loop
            for j in 0 ..< sines.count {
                var g = 0
                var F: UInt32 = 0
                
                switch j {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft((A &+ F &+ sines[j] &+ M[g]), bits: shifts[j])
                A = dTemp
            }
            
            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        
        hh.forEach {
            let itemLE = $0.littleEndian
            let r1 = UInt8(itemLE & 0xff)
            let r2 = UInt8((itemLE >> 8) & 0xff)
            let r3 = UInt8((itemLE >> 16) & 0xff)
            let r4 = UInt8((itemLE >> 24) & 0xff)
            result += [r1, r2, r3, r4]
        }
        return result
    }
}

// MARK: String -> 获取字符串中一段字符串的相关操作
extension String {
    /// 获取字符串某个索引的字符（从前往后）
    /// - Parameter index: 索引值 是从0开始算的
    /// - Returns: 处理后的字符串
    public func getCharAdvance(index: Int) -> String {
        assert(index < self.count, "哦呵~ 字符串索引越界了！")
        let positionIndex = self.index(self.startIndex, offsetBy: index)
        let char = self[positionIndex]
        return String(char)
    }
    
    /// 获取字符串第一个字符
    /// - Returns: 处理后的字符串
    public func getFirstChar() -> String {
        return getCharAdvance(index: 0)
    }
    
    /// 获取字符串某个索引的字符（从后往前）
    /// - Parameter index: 索引值
    /// - Returns: 处理后的字符串
    public func getCharReverse(index: Int) -> String {
        assert(index < self.count, "哦呵~ 字符串索引越界了！")
        //在这里做了索引减1，因为endIndex获取的是 字符串最后一个字符的下一位
        let positionIndex = self.index(self.endIndex, offsetBy: -index - 1)
        let char = self[positionIndex]
        return String(char)
    }
    
    /// 获取字符串最后一个字符
    /// - Returns: 处理后的字符串
    public func getLastChar() -> String {
        return getCharReverse(index: 0)
    }
    
    /// 获取某一串字符串按索引值 （前闭后开 包含前边不包含后边）
    /// - Parameters:
    ///   - start: 开始的索引
    ///   - end: 结束的索引
    /// - Returns: 处理后的字符串
    public func subString(startIndex: Int,
                          endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String (self[start ..< end])
    }
    
    /// 获取某一串字符串按数量
    /// - Parameters:
    ///   - startIndex: 开始索引
    ///   - count: 截取个数
    /// - Returns: 处理后的字符串
    public func subString(startIndex: Int,
                          count: Int) -> String {
        return subString(startIndex: startIndex, endIndex: startIndex + count)
    }
    
    /// 截取字符串从某个索引开始截取 包含当前索引
    /// - Parameter startIndex: 开始索引
    /// - Returns: 截取后的字符串
    public func subStringFrom(startIndex: Int) -> String {
        return subString(startIndex: startIndex, endIndex: self.count)
    }
    
    /// 截取字符串（从开始截取到想要的索引位置）不包含当前索引
    /// - Parameter endIndex: 结束索引
    /// - Returns: 截取后的字符串
    public func subStringTo(endIndex: Int) -> String {
        return subString(startIndex: 0, endIndex: endIndex)
    }
    
    /// 利用subscript 获取某个位置的字符串
    subscript(index: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex ..< endIndex])
    }
}

// MARK: String -> 计算字符串的尺寸
extension String {
    /// 计算字体的宽度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - height: label高度
    /// - Returns: 字体宽度
    public func caclulateTextWidth(font: UIFont,
                                   height: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: 100000, height: height), options: option, attributes: attributes, context: nil)
        return rect.size.width;
    }
    
    /// 计算字体的高度
    /// - Parameters:
    ///   - font: 字体大小
    ///   - width: 文字宽度
    /// - Returns: 字体高度
    public func caclulateTextHeight(font: UIFont,
                                    width: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: width, height: 100000), options: option, attributes: attributes, context: nil)
        return rect.size.width;
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
    
    /// 手机号加密
    /// - Returns: 隐藏后的手机号
    public func encodeTelphone() -> String {
        let phoneStr = self.trimmingAllWhiteSpaces()
        if phoneStr.count == 11 {
            let start = self.index(self.startIndex, offsetBy: 3)
            let endIndex = self.index(self.startIndex, offsetBy: self.count - 4)
            return self.replacingCharacters(in: start ..< endIndex, with: "****")
        } else {
            return self
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

// MARK: - 正则表达式
extension String {
    func isEmail() -> Bool {
        if self.count == 0 {
            return false
        }
        let emailRegex = "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+$"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func isNumber() -> Bool {
        let pattern = "^[0-9]+$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    
    /// 包含emoji表情
    var containsEmoji: Bool {
        return contains{ $0.isEmoji }
    }
    
    public func defaultString() -> String {
        if self.count == 0 {
            return "--"
        }
        return self
    }
}

extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
        (firstProperties.isEmojiPresentation ||
         firstProperties.generalCategory == .otherSymbol)
    }
    
    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
        unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }
    
    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}

// MARK: - UITextField
extension UITextField {
    /// 设置placeholder颜色
    func setPlaceholder(color: UIColor) {
        if let subStr = self.placeholder, let font = self.font {
            let range: NSRange = (subStr as NSString).range(of: subStr)
            
            self.setPlaceholder(range: range, color: color, font: font)
        }
    }
    
    /// 设置placeholder颜色、字体
    func setPlaceholder(color: UIColor,
                        fontSize: CGFloat) {
        if let subStr = self.placeholder, let pointSize = self.font?.pointSize {
            let range: NSRange = (subStr as NSString).range(of: subStr)
            
            let tempSize = (fontSize < 5) ? pointSize : fontSize
            let font = UIFont.systemFont(ofSize: tempSize)
            
            self.setPlaceholder(range: range, color: color, font: font)
        }
    }
    
    /// 设置placeholder部分字符串的颜色、字体
    func setPlaceholder(subStr: String,
                        color: UIColor,
                        fontSize: CGFloat = 1) {
        if let placeholder = self.placeholder, let pointSize = self.font?.pointSize {
            let range: NSRange = (placeholder as NSString).range(of: subStr)
            let tempSize = (fontSize < 5) ? pointSize : fontSize
            let font = UIFont.systemFont(ofSize: tempSize)
            
            self.setPlaceholder(range: range, color: color, font: font)
        }
    }
    
    /// 设置placeholder部分字符串的颜色、字体
    func setPlaceholder(range: NSRange,
                        color: UIColor,
                        font: UIFont) {
        let placeholderLength = self.placeholder?.count ?? 0
        if range.location != NSNotFound, range.location < placeholderLength, (range.location + range.length <= placeholderLength) {
            let attStr = NSMutableAttributedString()
            if let oldAttStr = self.attributedPlaceholder {
                // 保留之前的attributedPlaceholder
                attStr.append(oldAttStr)
            }
            let att = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color]
            attStr.setAttributes(att, range: range)
            self.attributedPlaceholder = attStr
        }
    }
    
    /// 设置Text左边间距
    func setTextLeftSpac(_ spac: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, spac, 1)
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    /// 设置字符间距
    func setTextSpac(_ spac: CGFloat) {
        if let text = self.text, let font = self.font {
            let att: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: NSNumber(value: spac)]
            self.attributedText = NSAttributedString(string: text, attributes: att)
        }
    }
    
    func addToolbarInputAccessoryView(barButtonItems: [UIBarButtonItem],
                                      textColor: UIColor? = nil,
                                      toolbarHeight: CGFloat = 44,
                                      backgroundColor: UIColor = .lightText) {
        let toolbar = UIToolbar()
        
        toolbar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: toolbarHeight)
        toolbar.items = barButtonItems
        toolbar.isTranslucent = false
        toolbar.barTintColor = backgroundColor
        if let aTextColor = textColor {
            toolbar.tintColor = aTextColor
        }
        
        inputAccessoryView = toolbar
    }
}

// MARK: - CALayer
extension CALayer {
    /// 抖动动画
    func shake(width: CGFloat = 8,
               duration: CGFloat = 0.3,
               repeatCount: Float = 2) {
        let keyAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        keyAnimation.values = [-width, 0, width, 0, -width, 0, width, 0]
        keyAnimation.duration = duration
        keyAnimation.repeatCount = repeatCount
        keyAnimation.isRemovedOnCompletion = true
        //
        self.add(keyAnimation, forKey: "shake")
    }
    
    /// 旋转动画
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        //
        self.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 停止所有动画
    func stopAnimation() {
        self.removeAllAnimations()
    }
}

// MARK: - Data
extension Data {
    /// Hexadecimal string representation of `Data` object.
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}

extension NSData {
    func castToCPointer<T>() -> T {
        var bytes = self.bytes
        let val = withUnsafePointer(to: &bytes) { (temp) in
            return unsafeBitCast(temp, to: T.self)
        }
        return val
    }
}

// MARK: - UIAlertAction
extension UIAlertAction {
    /// 获取所有的属性
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            let pro: Ivar = ivars[i]
            guard let ivarName = ivar_getName(pro) else {
                continue
            }
            guard let name = String(utf8String: ivarName) else {
                continue
            }
            result.append(name)
        }
        return result
    }
    
    /// 是否存在某个属性
    func isPropertyExisted(_ propertyName: String) -> Bool {
        for name in UIAlertAction.propertyNames {
            if name == propertyName {
                return true
            }
        }
        return false
    }
    
    /// 设置自定义颜色
    func setTextColor(_ color: UIColor) {
        let key = "_titleTextColor"
        guard isPropertyExisted(key) else {
            return
        }
        self.setValue(color, forKey: key)
    }
}

// MARK: - UserDefaults
extension UserDefaults {
    /// 设置 UserDefaults key-value
    static func set(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// 获取 UserDefaults key-value
    static func get(key: String) -> String {
        if let value: String = UserDefaults.standard.object(forKey: key) as? String {
            return value
        } else {
            UserDefaults.set(value: "", key: key)
            return ""
        }
    }
}

// MARK: - Bool
extension Bool {
    /// Bool 转 String (YES/NO)
    public func toString() -> String {
        return self ? "Yes" : "No"
    }
    
    /// Bool 转 Int (1/0)
    public func toInt() -> Int {
        return self ? 1 : 0
    }
}

// MARK: - Int
extension Int {
    public func toString() -> String {
        return String(self)
    }
}
