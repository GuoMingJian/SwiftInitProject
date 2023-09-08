//
//  MJAuthorize.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/9/4.
//

import UIKit
import Photos

class MJAuthorize: NSObject {
    // MARK: - 相册权限
    static func photoAuthorize(completed: @escaping (_ isAuthorize: Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            completed(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            completed(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    completed(status == PHAuthorizationStatus.authorized)
                }
            })
        case .limited:
            completed(true)
        @unknown default:
            completed(false)
        }
    }
    
    //MARK: - 相机权限
    static func cameraAuthorize(completed: @escaping (_ isAuthorize: Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            completed(true)
        case .denied:
            completed(false)
        case .restricted:
            completed(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completed(granted)
                }
            })
        @unknown default:
            completed(false)
        }
    }
    
    // MARK: - APP系统设置权限界面
    static func jumpToSystemSetting() {
        guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appSetting)
        }
    }
}

// MARK: - 提示用户打开app需要的权限，并在用户同意后，跳转到对应的setting页面
extension MJAuthorize {
    enum AppAuthority: String {
        /// 相册
        case PhotoLibrary
        /// 相机
        case Camera
        /// 地图定位
        case Map
        /// 蓝牙
        case BlueTooth
        
        func getAuthorityStr() -> String {
            switch self {
            case .PhotoLibrary:
                return "Photo album"
            case.Camera:
                return "Camera"
            case.Map:
                return "Map"
            case .BlueTooth:
                return "Bluetooth"
            }
        }
    }
    
    /// 跳转到系统设置
    /// - Parameter appAuthorityKind: 请求何种权限
    static func goToSetting(appAuthorityKind: AppAuthority,
                            currentVC: UIViewController) {
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: appAuthorityKind.getAuthorityStr(),
                                                    message: "Request open permission " + appAuthorityKind.getAuthorityStr(),
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "Setting", style: .default, handler: {
                (action) -> Void in
                let url = URL(string: UIApplication.openSettingsURLString)
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                            (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            currentVC.present(alertController, animated: true, completion: nil)
        })
    }
}
