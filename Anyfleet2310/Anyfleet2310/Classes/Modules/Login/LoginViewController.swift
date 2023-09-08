//
//  LoginViewController.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/22.
//

import UIKit

class LoginViewController: BaseLoginViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        handleBlock()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(backButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(phoneNumberTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(forgotButton)
        containerView.addSubview(blackButton)
        containerView.addSubview(bottomContainerView)
        
        // 先屏蔽
        forgotButton.isHidden = true
        bottomContainerView.isHidden = true
        
        self.addEyeButton(atView: containerView, textField: passwordTextField, btnTag: kPasswordEyeTag)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: kNavigationBarHeight + 15),
            backButton.widthAnchor.constraint(equalToConstant: kBackBtnHeight),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: kButtonLeftSpac),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: kButtonLeftSpac),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            phoneNumberTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: kTextFieldHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: phoneNumberTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: phoneNumberTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: kTextFieldHeight),
            
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            forgotButton.heightAnchor.constraint(equalToConstant: 35),
            
            blackButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 25),
            blackButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            blackButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            blackButton.heightAnchor.constraint(equalToConstant: kButtonHeight),
            
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            bottomContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    private func initData() {
        titleLabel.text = "Welcome back! Glad to see you, Again!"
        bottomLabel.text = "Don't have an account?"
        bottomButton.setTitle("Register Now", for: .normal)
    }
    
    private func handleBlock() {
        self.backButtonBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        
        // login
        self.blackButtonBlock = { [self] in
            self.view.endEditing(true)
            let userName = phoneNumberTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            //
            ATWorker.requestLogin(userName: userName, password: password) { model in
                UserInformation.shared.saveUserId(userId: model.respons.userId)
                UserInformation.shared.saveUserName(model.respons.username)
                ATWorker.requestUploadDeviceToken()
                self.loginSuccess()
            } failure: { errorMsg in
                MJTipView.show(errorMsg, duration: 2)
            }
        }
        
        self.bottomButtonBlock = {
            // 注册
        }
        
        self.forgotButtonBlock = {
        }
        
        //
        self.exChangePasswordEncryptionBlock = { [weak self] sender in
            guard let self = self else { return }
            
            if sender.tag == self.kPasswordEyeTag {
                self.passwordTextField.isSecureTextEntry = !sender.isSelected
            }
        }
    }
    
    private func loginSuccess() {
        if let keyWindow = UIView.getKeyWindow() {
            let tabBarVC = BaseTabBarViewController.createTabBarViewController()
            tabBarVC.selectedIndex = 0
            keyWindow.rootViewController = tabBarVC
        }
    }
}
