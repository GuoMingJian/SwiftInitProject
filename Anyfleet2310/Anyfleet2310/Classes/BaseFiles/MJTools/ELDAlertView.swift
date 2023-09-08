//
//  ELDAlertView.swift
//  AnytrekELD
//
//  Created by 郭明健 on 2023/7/10.
//

import UIKit

class ELDAlertView: UIView {
    struct Configuration {
        var alertLeading: CGFloat = 30
        var leading: CGFloat = 16
        var imageTopSpac: CGFloat = 10
        var titleTopSpac: CGFloat = 10
        var subTitleTopSpac: CGFloat = 10
        var subTitleBottomSpac: CGFloat = 20
        
        var animationTimeInterval: TimeInterval = 0.2
        
        var topImage: UIImage? = nil
        var topImageWidth: CGFloat = 48
        
        var bgColor: UIColor = Common.ELDColorBackgroundColor(alpha: 0.5)
        var alertBgColor: UIColor = .white
        var radius: CGFloat = 12
        var buttonHeight: CGFloat = 45
        
        var title: String = "Title"
        var titleColor: UIColor = Common.ELDColorTitleColor()
        var titleFont: UIFont = UIFont.PFMedium(fontSize: 18)
        
        var subTitle: String = "subTitle"
        var subTitleColor: UIColor = Common.ELDColorSubTextColor()
        var subTitleFont: UIFont = UIFont.PFRegular(fontSize: 15)
        
        var buttonFont: UIFont = UIFont.PFMedium(fontSize: 16)
        var buttonTextArray: [String] = ["OK"]
    }
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    public lazy var bgContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView.stackView(axis: .vertical, spacing: 4)
        return view
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    //    private lazy var subTitleTextField: UITextField = {
    //        let textField = UITextField()
    //        textField.translatesAutoresizingMaskIntoConstraints = false
    //        textField.backgroundColor = .white
    //        textField.clearButtonMode = .whileEditing
    //        textField.setTextLeftSpac(5)
    //        textField.setCornerRadius(radius: 5)
    //        textField.setBorderStyle(borderWidth: 1, borderColor: Common.ATColorLineColor())
    //        return textField
    //    }()
    
    private func getButton(tag: Int,
                           text: String,
                           textColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.addTarget(self, action: #selector(clickButtonAction(button:)), for: .touchUpInside)
        return button
    }
    
    // MARK: -
    private var configuration: Configuration!
    private var clickButtonBlock: ((_ index: Int, _ subTitle: String) -> Void)?
    
    // MARK: - public
    public func setupViews(atView: UIView,
                           configuration: Configuration,
                           clickButtonBlock: @escaping ((_ index: Int, _ subTitle: String) -> Void)) {
        self.configuration = configuration
        self.clickButtonBlock = clickButtonBlock
        //
        atView.addSubview(self)
        addSubview(bgContainerView)
        bgContainerView.backgroundColor = configuration.bgColor
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: atView.topAnchor),
            self.leadingAnchor.constraint(equalTo: atView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: atView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: atView.bottomAnchor),
            
            bgContainerView.topAnchor.constraint(equalTo: topAnchor),
            bgContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        bgContainerView.addSubview(containerView)
        containerView.setCornerRadius(radius: configuration.radius)
        containerView.backgroundColor = configuration.alertBgColor
        
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(topImageView)
        imageContainerView.isHidden = (configuration.topImage == nil) ? true : false
        topImageView.image = configuration.topImage
        containerView.addArrangedSubview(imageContainerView)
        containerView.setCustomSpacing(configuration.titleTopSpac, after: imageContainerView)
        
        containerView.addArrangedSubview(titleLabel)
        titleLabel.text = configuration.title
        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor
        containerView.setCustomSpacing(configuration.subTitleTopSpac, after: titleLabel)
        
        containerView.addArrangedSubview(subTitleLabel)
        subTitleLabel.text = configuration.subTitle
        subTitleLabel.font = configuration.subTitleFont
        subTitleLabel.textColor = configuration.subTitleColor
        containerView.setCustomSpacing(configuration.subTitleBottomSpac, after: subTitleLabel)
        //        containerView.addArrangedSubview(subTitleTextField)
        //        subTitleTextField.text = configuration.subTitle
        //        subTitleTextField.font = configuration.subTitleFont
        //        subTitleTextField.textColor = configuration.subTitleColor
        //        containerView.setCustomSpacing(configuration.subTitleBottomSpac, after: subTitleTextField)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: bgContainerView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bgContainerView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: bgContainerView.leadingAnchor, constant: configuration.alertLeading),
            
            topImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: configuration.imageTopSpac),
            topImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            topImageView.widthAnchor.constraint(equalToConstant: configuration.topImageWidth),
            topImageView.heightAnchor.constraint(equalToConstant: configuration.topImageWidth),
            topImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: configuration.leading),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -configuration.leading),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: configuration.leading),
            subTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -configuration.leading),
            //            subTitleTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: configuration.leading),
            //            subTitleTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -configuration.leading),
            //            subTitleTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        if imageContainerView.isHidden {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: configuration.titleTopSpac),
            ])
        }
        
        for (index, btnText) in configuration.buttonTextArray.enumerated() {
            let button = getButton(tag: index, text: btnText, textColor: configuration.titleColor)
            containerView.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: configuration.buttonHeight)
            ])
            
            if index == configuration.buttonTextArray.count - 1 {
                NSLayoutConstraint.activate([
                    button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
                ])
            }
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.setNeedsLayout()
                button.addBorder(side: .top, color: Common.ATColorLineColor(), thickness: 1)
            }
        }
    }
    
    // MARK: - private
    
    @objc private func clickButtonAction(button: UIButton) {
        if clickButtonBlock != nil {
            clickButtonBlock!(button.tag, subTitleLabel.text ?? "")
        }
        dismissScale(duration: configuration.animationTimeInterval, bgView: self.bgContainerView)
    }
}
