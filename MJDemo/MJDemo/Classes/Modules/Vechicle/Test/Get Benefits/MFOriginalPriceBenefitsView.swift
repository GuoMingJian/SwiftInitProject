//
//  MFOriginalPriceBenefitsView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/17.
//

import UIKit

class MFOriginalPriceBenefitsView: BaseView {
    enum BenefitsType: Int {
        case oneDeviceOfYear = 0
        case oneDeviceOfQuarter = 1
        case oneDeviceOfMonth = 2
        
        public func getString() -> String {
            switch self {
            case .oneDeviceOfYear:
                return "1-Year Plan for 1 Device"
            case .oneDeviceOfQuarter:
                return "1-Quarter Plan for 1 Device"
            case .oneDeviceOfMonth:
                return "1-Month Plan for 1 Device"
            }
        }
    }
    
    struct Configuration {
        var isCanBuy: Bool = true
        var type: BenefitsType = .oneDeviceOfMonth
        var deletePrice: Double = 0
        var nowPrice: Double = 0
        var monthPrice: Double = 0
        var totalPriceStr: String = "Billed annually at"
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
}
