//
//  ATWorker.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/6/29.
//

import UIKit
import Alamofire

class ATWorker: NSObject {
    // MARK: -
    static func handleResponse(data: [String: Any]?,
                               error: AFError?) -> BaseModel {
        let model: BaseModel = BaseModel()
        if let baseModel: BaseModel = BaseModel.deserialize(from: data) {
            model.code = baseModel.code
            model.message = baseModel.message
        } else {
            // model.message = error?.localizedDescription ?? error?.errorDescription ?? error.debugDescription
            model.message = Common.unableConnectServer
        }
        return model
    }
    
    // MARK: - 登录
    // 2309test5091 / 123456
    static func requestLogin(loading: String? = Common.loading,
                             userName: String,
                             password: String,
                             success: @escaping ((_ model: LoginModel) -> Void),
                             failure: @escaping ((_ errorMsg: String) -> Void)) {
        var passwordMD5 = password.md5
        passwordMD5 = passwordMD5.md5
        
        var parameters: [String: Any] = [:]
        parameters["username"] = userName
        parameters["password"] = passwordMD5
        
        AFNetwork.shared.request(loading: loading, method: .get, url: API.login, parameters: parameters) { response, data, error in
            let baseModel = handleResponse(data: data, error: error)
            if baseModel.code == 200 {
                // success
                if let model: LoginModel = LoginModel.self.deserialize(from: data) {
                    success(model)
                } else {
                    let dataDeserializeError = "\(API.login)  ==> \(Common.apiDataError)"
                    failure(dataDeserializeError)
                }
            } else {
                failure(baseModel.message)
            }
        }
    }
    
    // MARK: - 上传 DeviceToken
    static func requestUploadDeviceToken() {
        if UserInformation.shared.userId.count > 0 {
            // 上传 DeviceToken
            ATWorker.requestUpdateDeviceToken(loading: nil) {
            } failure: { error in
                // MJTipView.show(error)
            }
        }
    }
    
    /// 更新 deviceToken
    static func requestUpdateDeviceToken(loading: String? = Common.loading,
                                         success: @escaping (() -> Void),
                                         failure: @escaping ((_ errorMessage: String) -> Void)) {
        var parameters: [String: Any] = [:]
        parameters["userId"] = UserInformation.shared.userId
        parameters["deviceToken"] = UserDefaults.get(key: Common.deviceToken)
        parameters["timezone"] = TimeZone.current.identifier
        
        AFNetwork.shared.request(loading: loading, method: .post, url: API.updateDeviceToken, parameters: parameters) { response, data, error in
            let baseModel = handleResponse(data: data, error: error)
            if baseModel.code == 200 {
                success()
            } else {
                failure(baseModel.message)
            }
        }
    }
    
//    // MARK: - 车辆信息列表
//    /// 车辆信息列表
//    static func requestVehicleLists(loading: String? = Common.loading,
//                                    success: @escaping ((_ model: TruckListsModel) -> Void),
//                                    failure: @escaping ((_ errorMessage: String) -> Void)) {
//        var parameters: [String: Any] = [:]
//        parameters["userId"] = UserInfo.shared.userId
//        AFNetwork.shared.request(loading: loading, method: .post, url: API.vehicleLists, parameters: parameters) { response, data, error in
//            let baseModel = handleResponse(data: data, error: error)
//            if baseModel.code == 200 {
//                // success
//                if let model: TruckListsModel = TruckListsModel.self.deserialize(from: data) {
//                    success(model)
//                } else {
//                    let dataDeserializeError = "\(API.vehicleLists)  ==> \(Common.apiDataError)"
//                    failure(dataDeserializeError)
//                }
//            } else {
//                failure(baseModel.message)
//            }
//        }
//
//        //        getMockData(loading: loading, fileName: "TruckLists") { data in
//        //            if let model: TruckListsModel = TruckListsModel.self.deserialize(from: data) {
//        //                success(model)
//        //            }
//        //        }
//    }
    
    // MARK: - Mock Data
    static func getMockData(loading: String? = nil,
                            fileName: String,
                            success: @escaping ((_ data: [String: Any]) -> Void)) {
        let tag = String.randomIntString(length: 10)
        if loading != nil {
            showLoading(Common.loading, tag: tag)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            dismissLoading(tag: tag)
            if let dict = BaseTools.getDictionaryFormJsonFile(fileName: fileName) {
                success(dict)
            }
        })
    }
}
