//
//  AppDelegate.swift
//  Anyfleet2310
//
//  Created by 郭明健 on 2023/9/8.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 多语言
        MJLanguageManager.shared.initAppLanguage()
        MJLanguageManager.shared.setLanguage(language: .English)
        // 键盘弹出回缩
        configIQKeyboardManager()
        // 谷歌地图
        configGoogleMaps()
        // 推送
        initNotificationCenter()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceId = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.set(value: deviceId, key: Common.deviceToken)
        
        if AFNetwork.shared.isLog {
            print(deviceId)
            print("****** push DeviceToken ******")
        }
    }
}

extension AppDelegate {
    /// 配置键盘回缩
    func configIQKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.enableAutoToolbar = true
        keyboardManager.keyboardDistanceFromTextField = 30.0
        keyboardManager.toolbarDoneBarButtonItemText = localizedString("toolbar_done")
        keyboardManager.toolbarManageBehaviour = .byPosition
    }
    
    /// 配置谷歌地图
    func configGoogleMaps() {
        // 国内手机调试注意要开启VPN翻墙
        GMSServices.provideAPIKey(APPKEY.googleMaps)
    }
}

// MARK: - 远程通知
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        //
        handlePush(userInfo: userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        guard let _ = userInfo["aps"] as? [String: AnyObject] else {
            return .failed
        }
        //
        handlePush(userInfo: userInfo)
        
        return .newData
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        handlePush(userInfo: userInfo)
        
        if #available(iOS 14.0, *) {
            return [[.alert, .badge, .sound]]
        } else {
            // Fallback on earlier versions
            return [[.badge, .sound]]
        }
    }
    
    // MARK: -
    /// 推送通知授权
    private func initNotificationCenter() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (isSucceseed: Bool, error: Error?) in
            if AFNetwork.shared.isLog {
                if isSucceseed == true {
                    print("推送通知授权成功！")
                } else {
                    print("推送通知授权失败！error = \(String(describing: error))")
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func handlePush(userInfo: [AnyHashable: Any]) {
    }
}

