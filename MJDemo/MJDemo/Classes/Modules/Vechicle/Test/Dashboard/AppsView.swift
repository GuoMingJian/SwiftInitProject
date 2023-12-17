//
//  AppsView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/17.
//

import UIKit

class AppsView: UIView {
    @IBOutlet weak var whatsAppView: UIView!
    @IBOutlet weak var callLogsView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var photosView: UIView!
    @IBOutlet weak var recCallsView: UIView!
    @IBOutlet weak var screenshotsView: UIView!
    
    @IBOutlet weak var whatsAppImageView: UIImageView!
    @IBOutlet weak var whatsLabel: UILabel!
    @IBOutlet weak var whatsCountLabel: UILabel!
    
    @IBOutlet weak var callImageView: UIImageView!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var callCountLabel: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageCountLabel: UILabel!
    
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var photosCountLabel: UILabel!
    
    @IBOutlet weak var recImageView: UIImageView!
    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var recCountLabel: UILabel!
    
    @IBOutlet weak var screenshotsImageView: UIImageView!
    @IBOutlet weak var screenshotsLabel: UILabel!
    @IBOutlet weak var screenshotsCountLabel: UILabel!
    
    public var clickAppBlock: ((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        whatsAppView.setCornerRadius(radius: 10)
        callLogsView.setCornerRadius(radius: 10)
        messageView.setCornerRadius(radius: 10)
        photosView.setCornerRadius(radius: 10)
        recCallsView.setCornerRadius(radius: 10)
        screenshotsView.setCornerRadius(radius: 10)
    }
    
    // MARK: - actions
    @IBAction func clickAppItemAction(_ sender: UIButton) {
        if let block = clickAppBlock {
            block(sender.tag)
        }
    }
}
