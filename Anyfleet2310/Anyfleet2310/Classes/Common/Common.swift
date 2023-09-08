//
//  Common.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/4/7.
//

import Foundation
import UIKit

class Common {
    /// 手机号前缀，如中国大陆+86，美国+1
    static let phonePrefix = "+1"
    
    /// 推送 DeviceToken
    static let deviceToken = "DeviceToken"
    
    /// API请求成功
    static let apiSuccessCode = 200
    
    /// N/A
    static let nullData = localizedString("no_data")
    
    /// 推送Alarm通知
    static let kPushAlarmNotification: String = "kPushAlarmNotification"
    
    /// 首次接收推送通知
    static let kFirstReceiveNotification: String = "FirstReceiveNotification"
    
    /// 无法连接服务器
    static let unableConnectServer = "Unable to connect to the server, please try again later."
    
    /// 数据解析错误
    static let apiDataError = "Data parsing failure!"
    
    /// loading
    static let loading = localizedString("api_loading")
}

extension Common {
    static func isExist(supView: UIView,
                        viewClass: AnyClass) -> Bool {
        var isExist: Bool = false
        for (_, subView) in supView.subviews.enumerated() {
            if subView.isKind(of: viewClass) {
                // print("已存在 \(viewClass)！")
                isExist = true
                break
            }
        }
        return isExist
    }
    
    static func removeView(supView: UIView,
                           viewClass: AnyClass) {
        for (_, subView) in supView.subviews.enumerated() {
            if subView.isKind(of: viewClass) {
                subView.removeFromSuperview()
                break
            }
        }
    }
    
    static func getHTTPS() -> String {
        let tempNetworkHost = UserDefaults.get(key: "2309_HTTPS")
        return tempNetworkHost
    }
    
    static func saveHTTPS(host: String) {
        UserDefaults.set(value: host, key: "2309_HTTPS")
    }
}

extension Common {
    /// 获取报警信息
    static func getAlarmMessage(_ alarmType: Int) -> String {
        // (-1:无异常, 0:设备拆卸,1:非法闯入,2:蓝牙低电量,3:喇叭低电量,4:主体蓝牙低电量,5喇叭丢失)
        switch alarmType {
        case -1:
            return ""
        case 0:
            return localizedString("vehicle_error_0")
        case 1:
            return localizedString("vehicle_error_1")
        case 2:
            return localizedString("vehicle_error_2")
        case 3:
            return localizedString("vehicle_error_3")
        case 4:
            return localizedString("vehicle_error_4")
        case 5:
            return localizedString("vehicle_error_5")
        default:
            return localizedString("vehicle_error_unknown")
        }
    }
    
    /// 是否为低电量报警
    static func isHasAlarmImages(_ alarmType: Int) -> Bool {
        // alarmType1:非法闯入；才有告警图片
        if alarmType == 1 {
            return true
        }
        return false
    }
    
    /*
     主设备/报警器电量:
     电压<=3.6v；显示1格报警；
     (3.6，3.8]显示2格绿色；
     (3.8,4.0]三格绿色；
     (4.0,...)显示4格
     */
    static func getDeviceBatteryImage(_ bat: Float) -> UIImage {
        var imageName: String = ""
        if bat <= 3.6 {
            imageName = "battery1"
        } else if bat > 3.6, bat <= 3.8 {
            imageName = "battery2"
        } else if bat > 3.8, bat <= 4.0 {
            imageName = "battery3"
        } else {
            imageName = "battery4"
        }
        return UIImage(named: imageName) ?? UIImage()
    }
    
    /// 主机/报警器是否低电量
    static func deviceOrAlarmIsLowPower(_ bat: Float) -> Bool {
        return bat <= 3.6
    }
    
    /*
     统一电量的单位，都为V
     Tag
     BAT<=2.4V        为一格电量(红色)
     2.4<BAT<=2.6V    为两格电量
     2.6<BAT<=3.3V     为三格电量
     */
    static func getTagBatteryImage(_ bat: Float) -> UIImage {
        var imageName: String = ""
        if bat <= 2.4 {
            imageName = "battery1"
        } else if bat > 2.4, bat <= 2.6 {
            imageName = "battery2"
        } else if bat > 2.6, bat <= 3.3 {
            imageName = "battery3"
        } else {
            imageName = "battery4"
        }
        return UIImage(named: imageName) ?? UIImage()
    }
    
    /// 蓝牙Tag是否低电量
    static func tagIsLowPower(_ bat: Float) -> Bool {
        return bat <= 2.4
    }
    
    static func getTagWidth(_ height: CGFloat) -> CGFloat {
        let width: CGFloat = ceil(156.0/270.0 * height) + 1
        return width
    }
}

extension Common {
    static let dateFormat_yyyyMMdd = "yyyy-MM-dd"
    static let dateFormat_yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    static let dateFormat_yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    static let dateFormat_HHmmaa = "HH:mm aa"
    static let dateFormat_HHmm = "HH:mm"
    
    static func currentTimeZoneString() -> String {
        return TimeZone.current.identifier
    }
    
    static func changeTabBarSelectedIndex(_ index: Int) {
        if let keyWindow = UIView.getKeyWindow() {
            let rootVC = keyWindow.rootViewController
            if let tabVC: BaseTabBarViewController = rootVC as? BaseTabBarViewController, tabVC.selectedIndex != index {
                tabVC.selectedIndex = index
            }
        }
    }
}

// MARK: - 颜色
extension Common {
    /// 黑 black
    static func ATColorBlack(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#000000", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// 红 red
    static func ATColorRed(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.red.withAlphaComponent(alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// 白 white
    static func ATColorWhite(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.white.withAlphaComponent(alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// 线颜色 #D0D5DD
    static func ATColorLineColor(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#D0D5DD", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// 蓝色（下划线按钮） #20A0FF
    static func ATColorBlue(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#20A0FF", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// 背景色 #D9D9D9
    static func ELDColorBackgroundColor(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#D9D9D9", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// Title 颜色 #101828
    static func ELDColorTitleColor(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#101828", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// subText 颜色 #475467
    static func ELDColorSubTextColor(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#475467", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
    
    /// alert button textColor #344054
    static func ELDColorBtnTextColor(alpha: CGFloat = 1) -> UIColor {
        let lightColor = UIColor.hexColor(color: "#344054", alpha: alpha)
        return UIColor(light: lightColor, dark: lightColor)
    }
}
