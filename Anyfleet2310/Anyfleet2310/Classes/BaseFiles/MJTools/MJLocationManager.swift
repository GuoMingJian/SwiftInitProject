//
//  MJLocationManager.swift
//  AnytrekELD
//
//  Created by 郭明健 on 2023/7/29.
//

import UIKit
import CoreLocation

// MARK: - 获取数据格式
import HandyJSON
extension MJLocationManager {
    struct ELDLocationModel: HandyJSON {
        var longitude: Double = -1
        var latitude: Double = -1
        var address: String = ""
        var detailedAddress: String = ""
    }
}

// MARK: - 
class MJLocationManager: NSObject {
    // 单例模式
    static var shared: MJLocationManager {
        struct Static {
            static var instance: MJLocationManager?
        }
        if Static.instance == nil {
            Static.instance = MJLocationManager()
            //
            Static.instance?.setup()
            //
            Static.instance?.locationAuthorize(completed: { isAuthorize in
                if !isAuthorize {
                    let currentVC = UIView.topMostController()
                    MJAuthorize.goToSetting(appAuthorityKind: .Map, currentVC: currentVC)
                }
            })
        }
        //
        return Static.instance!
    }
    
    // MARK: -
    /// 定位管理器
    private let locationManager: CLLocationManager = CLLocationManager()
    
    typealias LocationBlock = (_ index: Int, _ locationModel: ELDLocationModel) -> Void
    /// 返回数据 Block
    private var locationBlock: LocationBlock?
    private var failureBlock: (() -> Void)?
    
    private func locationAuthorize(completed: @escaping (_ isAuthorize: Bool) -> Void) {
        let granted = CLLocationManager.authorizationStatus()
        // 定位权限判断
        switch granted {
        case .denied:
            /// 未授权
            completed(false)
        case .notDetermined :
            /// 不确定
            completed(false)
        case .authorizedAlways :
            /// 一直允许
            completed(true)
        case .authorizedWhenInUse :
            /// 使用期间允许
            completed(true)
        case .restricted :
            /// 受限的
            completed(false)
        @unknown default:
            completed(false)
        }
    }
    
    /// 初始化配置
    private func setup() {
        locationManager.delegate = self
        /* 定位精度
         kCLLocationAccuracyBestForNavigation ：精度最高，一般用于导航
         kCLLocationAccuracyBest ： 精确度最佳
         kCLLocationAccuracyNearestTenMeters ：精确度10m以内
         kCLLocationAccuracyHundredMeters ：精确度100m以内
         kCLLocationAccuracyKilometer ：精确度1000m以内
         kCLLocationAccuracyThreeKilometers ：精确度3000m以内
         */
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 更新距离
        locationManager.distanceFilter = 5.0
        // 发送授权申请
        locationManager.requestAlwaysAuthorization()
        // 运行app退到后台更新定位信息
        locationManager.allowsBackgroundLocationUpdates = false
        // 进入后台不停止
        locationManager.pausesLocationUpdatesAutomatically = false
        //
        // CLLocationManager.locationServicesEnabled() // 可以定位
    }
    
    // MARK: - 获取定位
    /// 请求最新定位
    public func startRequestLocation(locationBlock: LocationBlock? = nil,
                                     failureBlock: (() -> Void)?) {
        self.locationBlock = locationBlock
        self.failureBlock = failureBlock
        //
        if CLLocationManager.authorizationStatus() == .denied {
            // 拒绝授权
            locationManager.requestWhenInUseAuthorization()
        } else {
            // 开始定位
            locationManager.startUpdatingLocation()
        }
    }
    
    /// 反地理编码
    public func getLocationWithString(_ value: String,
                                      locationBlock: ((_ list: [ELDLocationModel]) -> Void)? = nil) {
        CLGeocoder().geocodeAddressString(value) { placemarks, error in
            if error != nil {
                return
            }
            // 反地理编码成功
            guard let allMark = placemarks else { return }
            
            var modelList: [ELDLocationModel] = []
            for (_, mark) in allMark.enumerated() {
                let province: String = mark.administrativeArea ?? ""
                let city: String = mark.locality ?? ""
                
                var subLocality: String = mark.subLocality ?? ""
                var name: String = mark.name ?? ""
                
                let addressStr = province + city
                var detailedAddress = province + city
                
                subLocality = (subLocality as NSString).replacingOccurrences(of: province, with: "")
                subLocality = (subLocality as NSString).replacingOccurrences(of: city, with: "")
                detailedAddress.append(subLocality)
                
                name = (name as NSString).replacingOccurrences(of: province, with: "")
                name = (name as NSString).replacingOccurrences(of: city, with: "")
                name = (name as NSString).replacingOccurrences(of: subLocality, with: "")
                detailedAddress.append(name)
                
                // longitude latitude
                let longitude = mark.location?.coordinate.longitude ?? -1
                let latitude = mark.location?.coordinate.latitude ?? -1
                //
                var isExist: Bool = false
                for (_, item) in modelList.enumerated() {
                    if item.address.elementsEqual(addressStr) {
                        isExist = true
                        break
                    }
                }
                if !isExist {
                    var model = ELDLocationModel()
                    model.longitude = longitude
                    model.latitude = latitude
                    model.address = addressStr
                    model.detailedAddress = detailedAddress
                    //
                    modelList.append(model)
                }
            }
            
            if let block = locationBlock {
                block(modelList)
            }
        }
    }
    
    public func getLocationInfo(index: Int = 0,
                                longitude: Double,
                                latitude: Double,
                                locationBlock: @escaping LocationBlock) {
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        //
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
            self.handleLocation(index: index, currentLocation: currentLocation, placemarks: placemarks, locationBlock: locationBlock)
        }
    }
    
    public func handleLocation(index: Int,
                               currentLocation: CLLocation,
                               placemarks: [CLPlacemark]?,
                               locationBlock: LocationBlock? = nil) {
        guard let allMark = placemarks else { return }
        
        if allMark.count > 0 {
            /*
             name:Optional("宝安大道6373号")
             thoroughfare:Optional("宝安大道")
             subThoroughfare:Optional("6373号")
             locality:Optional("深圳市")
             subLocality:Optional("宝安区")
             administrativeArea:Optional("广东省")
             subAdministrativeArea:nil
             postalCode:nil
             isoCountryCode:Optional("CN")
             country:Optional("中国")
             inlandWater:nil
             ocean:nil
             areasOfInterest:Optional(["卓越时代创新园"])
             */
            let mark: CLPlacemark = allMark.first!
            let country: String = mark.country ?? ""
            let province: String = mark.administrativeArea ?? ""
            let city: String = mark.locality ?? ""
            let subLocality: String = mark.subLocality ?? ""
            let thoroughfare: String = mark.thoroughfare ?? ""
            let subThoroughfare: String = mark.subThoroughfare ?? ""
            let addressStr = country + province + city + subLocality + thoroughfare + subThoroughfare
            //
            if let block = locationBlock {
                var model = ELDLocationModel()
                model.longitude = currentLocation.coordinate.longitude
                model.latitude = currentLocation.coordinate.latitude
                model.address = addressStr
                model.detailedAddress = addressStr
                block(index, model)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MJLocationManager: CLLocationManagerDelegate {
    /// 定位改变
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let curLocation: CLLocation = locations.first!
        let longitude = curLocation.coordinate.longitude
        let latitude = curLocation.coordinate.latitude
        
        // print("经度：" + String(curLocation.coordinate.longitude) + " 纬度：" + String(curLocation.coordinate.latitude))
        CLGeocoder().reverseGeocodeLocation(curLocation) {[weak self] (placemarks, error) in
            if error != nil {
                return
            }
            // 反地理编码成功
            guard let allMark = placemarks else { return }
            
            if allMark.count > 0 {
                let mark: CLPlacemark = allMark.first!
                let province: String = mark.administrativeArea ?? ""
                let city: String = mark.locality ?? ""
                let addressStr = province + city
                
                if let block = self?.locationBlock {
                    var model = ELDLocationModel()
                    model.longitude = longitude
                    model.latitude = latitude
                    model.address = addressStr
                    block(0, model)
                }
            }
            
            self?.locationManager.stopUpdatingLocation()
        }
    }
    
    /// 授权
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .notDetermined {
                print("MJLocationManager -> 定位未授权！")
            } else if manager.authorizationStatus == .restricted {
                // 受限制
            } else if manager.authorizationStatus == .denied {
                // 被拒绝
            } else {
                startRequestLocation(locationBlock: self.locationBlock, failureBlock: self.failureBlock)
            }
        } else {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("MJLocationManager -> 定位失败！")
        locationManager.stopUpdatingLocation()
        if let block = failureBlock {
            block()
        }
    }
}
