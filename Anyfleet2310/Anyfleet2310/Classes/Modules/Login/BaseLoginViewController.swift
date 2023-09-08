//
//  BaseLoginViewController.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/22.
//

import UIKit

class BaseLoginViewController: BaseViewController {
    private let tfBackgroundColor: UIColor = UIColor.hexColor(color: "F6F7F8")
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "background"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "loginBack"), for: .normal)
        button.addTarget(self, action: #selector(backButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.PFMedium(fontSize: 25)
        return label
    }()
    
    public lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.hexColor(color: "969FAB")
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    public lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.backgroundColor = tfBackgroundColor
        textField.setCornerRadius(radius: 10)
        textField.setTextLeftSpac(15)
        textField.font = UIFont.PFRegular(fontSize: 16)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - phoneNumber TextField
    
    public lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your user name" // "Enter your phone number"
        textField.backgroundColor = tfBackgroundColor
        textField.setCornerRadius(radius: 10)
        textField.setTextLeftSpac(15)
        textField.font = UIFont.PFRegular(fontSize: 16)
        textField.clearButtonMode = .whileEditing
        //        textField.keyboardType = .numberPad
        //
        //        textField.setTextLeftSpac(52)
        //        textField.addSubview(telContainerView)
        //        NSLayoutConstraint.activate([
        //            telContainerView.topAnchor.constraint(equalTo: textField.topAnchor),
        //            telContainerView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10),
        //            telContainerView.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        //        ])
        return textField
    }()
    
    public lazy var telHeadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.PFRegular(fontSize: 14)
        label.text = Common.phonePrefix
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.hexColor(color: "DBDDDD")
        return view
    }()
    
    public lazy var telContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.addSubview(telHeadLabel)
        view.addSubview(lineView)
        NSLayoutConstraint.activate([
            telHeadLabel.topAnchor.constraint(equalTo: view.topAnchor),
            telHeadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            telHeadLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            lineView.topAnchor.constraint(equalTo: view.topAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: telHeadLabel.trailingAnchor, constant: 10),
            lineView.widthAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }()
    
    // MARK: -
    
    public lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your password"
        textField.backgroundColor = tfBackgroundColor
        textField.setCornerRadius(radius: 10)
        textField.setTextLeftSpac(15)
        textField.font = UIFont.PFRegular(fontSize: 16)
        //textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    public lazy var forgotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.hexColor(color: "666C75"), for: .normal)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.PFRegular(fontSize: 15)
        button.addTarget(self, action: #selector(forgotButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    public lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Confirm password"
        textField.backgroundColor = tfBackgroundColor
        textField.setCornerRadius(radius: 10)
        textField.setTextLeftSpac(15)
        textField.font = UIFont.PFRegular(fontSize: 16)
        //textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    public lazy var successIconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "successIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var blackButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.setTitle("Login", for: .normal)
        button.setCornerRadius(radius: 10)
        button.addTarget(self, action: #selector(blackButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    public lazy var whiteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.hexColor(color: "C3C6CA")
        button.setTitle("Register", for: .normal)
        button.setCornerRadius(radius: 10)
        button.setBorderStyle(borderWidth: 1, borderColor: .black)
        button.addTarget(self, action: #selector(whiteButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - bottomView
    public lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.addSubview(bottomLabel)
        view.addSubview(bottomButton)
        
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            bottomButton.topAnchor.constraint(equalTo: view.topAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: bottomLabel.trailingAnchor, constant: 3)
        ])
        
        return view
    }()
    
    public lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    public lazy var bottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.hexColor(color: "3D98F1"), for: .normal)
        button.addTarget(self, action: #selector(bottomButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: -
    
    public let kBackBtnHeight: CGFloat = 41
    public let kButtonHeight: CGFloat = 56
    public let kTextFieldHeight: CGFloat = 56
    public let kButtonLeftSpac: CGFloat = 20
    /// logo 宽高比
    public let kLogoAspectRatio: CGFloat = 255 / 129
    
    public let kPasswordEyeTag: Int = 100
    public let kConfirmPasswordEyeTag: Int = 101
    
    /// 返回按钮Block
    public var backButtonBlock: (() -> Void)?
    
    /// 登录按钮Block
    public var blackButtonBlock: (() -> Void)?
    
    /// 注册按钮Block
    public var whiteButtonBlock: (() -> Void)?
    
    /// 最底部按钮Block
    public var bottomButtonBlock: (() -> Void)?
    
    /// 忘记密码按钮Block
    public var forgotButtonBlock: (() -> Void)?
    
    /// 是否明文按钮Block
    public var exChangePasswordEncryptionBlock: ((_ eyeButton: UIButton) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    // MARK: - actions
    @objc private func backButtonClickAction() {
        if backButtonBlock != nil {
            backButtonBlock!()
        }
    }
    
    @objc public func blackButtonClickAction() {
        if blackButtonBlock != nil {
            blackButtonBlock!()
        }
    }
    
    @objc private func whiteButtonClickAction() {
        if whiteButtonBlock != nil {
            whiteButtonBlock!()
        }
    }
    
    @objc private func bottomButtonClickAction() {
        if bottomButtonBlock != nil {
            bottomButtonBlock!()
        }
    }
    
    @objc private func forgotButtonClickAction() {
        if forgotButtonBlock != nil {
            forgotButtonBlock!()
        }
    }
    
    @objc private func exChangePasswordEncryption(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //
        if exChangePasswordEncryptionBlock != nil {
            exChangePasswordEncryptionBlock!(sender)
        }
    }
    
    // MARK: - Private
    public func addEyeButton(atView: UIView,
                             textField: UITextField,
                             btnTag: Int) {
        //
        let btn: MJEnlargeButton = MJEnlargeButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = btnTag
        btn.enlargeInset = 10
        btn.setImage(UIImage(named: "closeEye"), for: .normal)
        btn.setImage(UIImage(named: "openEye"), for: .selected)
        btn.isSelected = false
        btn.addTarget(self, action: #selector(exChangePasswordEncryption(sender:)), for: .touchUpInside)
        //
        atView.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -20),
            btn.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 23),
            btn.heightAnchor.constraint(equalTo: btn.widthAnchor)
        ])
    }
}
