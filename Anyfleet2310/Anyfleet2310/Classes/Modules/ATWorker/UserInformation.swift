//
//  UserInformation.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/7/3.
//

import UIKit

class UserInformation: NSObject {
    var isLogin: Bool = false
    var userId: String = ""
    var userName: String = ""
    
    // 单例模式
    static var shared: UserInformation {
        struct Static {
            static var instance: UserInformation?
        }
        if Static.instance == nil {
            Static.instance = UserInformation()
            //
            Static.instance?.getUserInfo()
        }
        //
        return Static.instance!
    }
    
    // MARK: -
    public func getUserInfo() {
        let userId = UserDefaults.get(key: "AT_UserId")
        //
        self.userId = userId
        self.isLogin = (userId.count > 0)
        //
        let userName = UserDefaults.get(key: "AT_UserName")
        self.userName = userName
    }
    
    public func saveUserId(userId: String) {
        UserDefaults.set(value: userId, key: "AT_UserId")
        //
        if userId.count > 0 {
            self.isLogin = true
            self.userId = userId
        } else {
            self.isLogin = false
            self.userId = userId
        }
    }
    
    public func saveUserName(_ name: String) {
        UserDefaults.set(value: name, key: "AT_UserName")
        self.userName = name
    }
}
