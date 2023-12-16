//
//  NotificationViewController.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class NotificationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        title = localizedString("tabbar_02")
    }

}
