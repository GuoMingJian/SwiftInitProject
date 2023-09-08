//
//  MJTools.swift
//
//  Created by 郭明健 on 2020/8/22.
//  Copyright © 2020 GuoMingJian. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - 常量定义

/// App导航栏颜色
public let kNavigationColor: UIColor = .white //UIColor.hexColor(color: "F7F6FA") //UIColor(49, 123, 248)
/// 背景色
public let kBackgroundColor: UIColor = .white //UIColor.hexColor(color: "F7F8FA")
/// 分割线颜色
public let kBottomLineColor: UIColor = UIColor(240, 240, 240)

public let kImageError: UIImage = UIImage(named: "imageError") ?? UIImage()

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

/// 项目常用方法
class BaseTools: NSObject {
    /// 单例
    static let shared: BaseTools = {
        let shared = BaseTools()
        return shared
    }()
    
    /// 获取keyWindow
    static func keyWindow() -> UIWindow? {
        var keyWindow: UIWindow? = nil
        //
        if #available(iOS 13.0, *) {
            for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    keyWindow = windowScene.windows.first
                    break
                }
            }
            return keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
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
    
    // MARK: - 获取项目目录下的plist文件内容
    /// 获取 Array
    static func getArrayFormFile(fileName: String,
                                 fileType: String = ".plist") -> [Any]? {
        let finalPath: String = getFilePath(fileName: fileName, fileType: fileType)
        if let array: [Any] = NSArray(contentsOfFile: finalPath) as? [Any] {
            return array
        }
        return nil
    }
    
    /// json文件 转 Dictionary
    static func getDictionaryFormJsonFile(fileName: String) -> [String: Any]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                let jsonDictionary: [String: Any] = jsonData as! [String: Any]
                return jsonDictionary
            } catch let error as Error? {
                print("=====>\(fileName).json 文件序列化错误！Error: \(error.debugDescription)")
            }
        }
        return nil
    }
    
    /// 获取 Dictionary
    static func getDictionaryFormFile(fileName: String,
                                      fileType: String = ".plist") -> [String: Any]? {
        
        let finalPath: String = getFilePath(fileName: fileName, fileType: fileType)
        if let dict: [String: Any] = NSDictionary(contentsOfFile: finalPath) as? [String: Any] {
            return dict
        }
        return nil
    }
    
    static func getFilePath(fileName: String,
                            fileType: String = ".plist") -> String {
        let path = Bundle.main.bundlePath
        let fileName: String = "\(fileName)\(fileType)"
        let finalPath: String = (path as NSString).appendingPathComponent(fileName)
        return finalPath
    }
    
    // MARK: - 跳转到指定页面（已存在->pop，不存在->push）
    /// 返回指定页面
    static func backToViewController(naVC: UINavigationController,
                                     toVC: UIViewController) {
        var isExist: Bool = false
        var vcArr: Array<UIViewController> = Array<UIViewController>()
        for vc:UIViewController in naVC.viewControllers {
            vcArr.append(vc)
            //
            if vc.isKind(of: toVC.classForCoder) {
                isExist = true
                break
            }
        }
        if isExist {
            naVC.setViewControllers(vcArr, animated: true)
        } else {
            naVC.pushViewController(toVC, animated: true)
        }
    }
    
    // MARK: - 常用方法
    
    /// 富文本
    static func setAttributes(label: UILabel,
                              subStrList: Array<String>,
                              color: UIColor) {
        let text: String = label.text!
        let font: UIFont = label.font
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
        label.attributedText = attM
    }
    
    /// 富文本
    static func setAttributes(textView: UITextView,
                              subStrList: Array<String>,
                              color: UIColor) {
        let text: String = textView.text!
        let font: UIFont = textView.font!
        let attM: NSMutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
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
        textView.attributedText = attM
    }
    
    /// 按钮添加下划线
    func addLineToButton(btn: UIButton) {
        let text: String = btn.titleLabel?.text ?? ""
        //
        let str = NSMutableAttributedString(string: text)
        let strRange = NSRange(location: 0, length: str.length)
        // 此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        //
        let lineColor: UIColor = btn.titleLabel!.textColor
        let font: UIFont = btn.titleLabel!.font
        //
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: lineColor,
                           NSAttributedString.Key.font: font], range: strRange)
        //
        btn.setAttributedTitle(str, for: UIControl.State.normal)
    }
    
    /// 播放系统提示声音，1007类型QQ声音
    func playSystemSoundNewMessage() {
        // https://www.jianshu.com/p/c41bbb020acb
        // 播放系统提示声音
        let soundID : SystemSoundID = 1007
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 播放系统提示声音，1004 消息发送成功。
    func playSystemSoundSendMessage() {
        // 播放系统提示声音
        let soundID : SystemSoundID = 1004
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 拨打电话
    func callPhone(_ phoneNum: String) {
        guard let url = URL(string: "tel:\(phoneNum)") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - 二维码生成
    
    /// 二维码生成
    func setupQRCodeImage(_ text: String,
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
    func setupHighDefinitionUIImage(_ image: CIImage,
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
    func rectangleImageWithImage(_ sourceImage: UIImage,
                                 borderWidth: CGFloat,
                                 borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height), cornerRadius: 1)
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
    func circleImageWithImage(_ sourceImage: UIImage,
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
    func syntheticImage(_ image: UIImage,
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
}
