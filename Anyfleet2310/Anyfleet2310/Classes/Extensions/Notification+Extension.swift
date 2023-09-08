//
//  Notification+Extension.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/4/21.
//

import Foundation

/// 通知
extension Notification.Name {
    struct Normal {
        /// APP 由后台进入到前台
        public static let APPEnterForegroundNotification = Notification.Name(rawValue: "APPEnterForegroundNotification")
    }
}
