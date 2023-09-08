//
//  VehicleViewController.swift
//  Anyfleet2310
//
//  Created by 郭明健 on 2023/9/8.
//

import UIKit

class VehicleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        title = localizedString("tabbar_01")
    }

}
