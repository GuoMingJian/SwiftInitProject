//
//  LoginModel.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/4/17.
//

import UIKit
import HandyJSON

class LoginModel: BaseModel {
    var respons: User = User()
}

struct User: HandyJSON {
    var userId: String = ""
    var username: String = ""
    // var phoneNumber: String = ""
    // var headImageUrl: String = ""
}
