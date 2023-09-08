//
//  APNsModel.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/4/19.
//

import UIKit
import HandyJSON

class APNsModel: HandyJSON {
    required init() {}
    
    var aps: APS = APS()
}

struct APS: HandyJSON {
    var contentAvailable: String = "0"
    var alert: Alert = Alert()
    var badge: Int?
    var sound: String = "default"
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.contentAvailable <-- "content-available"
    }
}

struct Alert: HandyJSON {
    var title: String?
    var body: String?
}

/*
 {
     "aps": {
         "content-available": 0,
         "alert": {
             "title": "报警通知",
             "body": "设备id:14发生异常，请及时查看。",
         },
         "badge": 1,
         "sound": "default"
     }
 }
 */
