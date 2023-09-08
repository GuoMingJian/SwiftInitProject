//
//  BaseModel.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/27.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {
    var code: Int = -1
    var message: String = ""
    
    func mapping(mapper: HelpingMapper) {
    }
    
    required init() {}
}
