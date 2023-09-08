//
//  WelcomeViewController.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/22.
//

import UIKit

class WelcomeViewController: BaseLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleBlock()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(blackButton)
        containerView.addSubview(whiteButton)
        // 先屏蔽
        whiteButton.isHidden = true
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            whiteButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            whiteButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            whiteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: kButtonLeftSpac),
            whiteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -kButtonLeftSpac),
            
            blackButton.bottomAnchor.constraint(equalTo: whiteButton.topAnchor, constant: -15),
            blackButton.heightAnchor.constraint(equalTo: whiteButton.heightAnchor),
            blackButton.widthAnchor.constraint(equalTo: whiteButton.widthAnchor),
            blackButton.centerXAnchor.constraint(equalTo: whiteButton.centerXAnchor),
            
            logoImageView.bottomAnchor.constraint(equalTo: blackButton.topAnchor, constant: -35),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1/kLogoAspectRatio)
        ])
    }

    // MARK: - private
    private func handleBlock() {
        self.blackButtonBlock = {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        self.whiteButtonBlock = {
            // 注册
        }
    }
}
