//
//  MFStorageBuyNowView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MFStorageBuyNowView: MFBaseView {
    struct Configuration {
        var basicStorage: String = "5.00G"
        var extraStorage: String = "5.00G"
        var remaining: String = "5.00G"
        var avgText: String = "$4.99/Mo"
        //
        var basicText = "Basic Storage"
        var extraText = "Extra Storage"
        var remainingText = "Remaining"
        //
        var valueFont: UIFont = UIFont.PFMedium(fontSize: 17)
        var defaultFont: UIFont = UIFont.PFRegular(fontSize: 14)
        var radius: CGFloat = 10
        var bottomBgColor: UIColor = UIColor.hexColor(color: "FCECD8")
        var buttonHeight: CGFloat = 30
        var buttonTopOffset: CGFloat = 10
        var iconWidth: CGFloat = 30
        var buyNowButtonWidth: CGFloat = 80
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setCornerRadius(radius: configuration.radius)
        return view
    }()
    
    private lazy var basicValueLabel: UILabel = {
        let label = getLabel(font: configuration.valueFont)
        return label
    }()
    
    private lazy var basicLabel: UILabel = {
        let label = getLabel(font: configuration.defaultFont)
        label.text = configuration.basicText
        return label
    }()
    
    private lazy var extraValueLabel: UILabel = {
        let label = getLabel(font: configuration.valueFont)
        return label
    }()
    
    private lazy var extraLabel: UILabel = {
        let label = getLabel(font: configuration.defaultFont)
        label.text = configuration.extraText
        return label
    }()
    
    private lazy var remainingValueLabel: UILabel = {
        let label = getLabel(font: configuration.valueFont)
        return label
    }()
    
    private lazy var remainingLabel: UILabel = {
        let label = getLabel(font: configuration.defaultFont)
        label.text = configuration.remainingText
        return label
    }()
    
    private func getLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = font
        return label
    }
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCornerRadius(radius: configuration.radius)
        view.backgroundColor = configuration.bottomBgColor
        //
        view.addSubview(iconImageView)
        view.addSubview(extraStorageLabel)
        view.addSubview(avgLabel)
        view.addSubview(buyNowButton)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            iconImageView.widthAnchor.constraint(equalToConstant: configuration.iconWidth),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            extraStorageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            extraStorageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            
            avgLabel.leadingAnchor.constraint(equalTo: extraStorageLabel.trailingAnchor, constant: 5),
            avgLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            avgLabel.trailingAnchor.constraint(equalTo: buyNowButton.leadingAnchor, constant: -10),
            
            buyNowButton.widthAnchor.constraint(equalToConstant: configuration.buyNowButtonWidth),
            buyNowButton.heightAnchor.constraint(equalToConstant: configuration.buttonHeight),
            buyNowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buyNowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: configuration.buttonTopOffset),
            buyNowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var extraStorageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFMedium(fontSize: 15)
        return label
    }()
    
    private lazy var avgLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFMedium(fontSize: 18)
        return label
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.PFMedium(fontSize: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.setCornerRadius(radius: 5)
        button.addTarget(self, action: #selector(buyNowButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: -
    override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.addSubview(basicValueLabel)
        containerView.addSubview(basicLabel)
        containerView.addSubview(extraValueLabel)
        containerView.addSubview(extraLabel)
        containerView.addSubview(remainingValueLabel)
        containerView.addSubview(remainingLabel)
        containerView.addSubview(bottomContainerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // extra
            extraValueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            extraValueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            extraLabel.topAnchor.constraint(equalTo: extraValueLabel.bottomAnchor, constant: 5),
            extraLabel.centerXAnchor.constraint(equalTo: extraValueLabel.centerXAnchor),
            
            // basic
            basicValueLabel.topAnchor.constraint(equalTo: extraValueLabel.topAnchor),
            
            basicLabel.topAnchor.constraint(equalTo: extraLabel.topAnchor),
            basicLabel.centerXAnchor.constraint(equalTo: basicValueLabel.centerXAnchor),
            basicLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            basicLabel.widthAnchor.constraint(equalTo: extraLabel.widthAnchor),
            
            // remaining
            remainingValueLabel.topAnchor.constraint(equalTo: extraValueLabel.topAnchor),
            
            remainingLabel.topAnchor.constraint(equalTo: extraLabel.topAnchor),
            remainingLabel.centerXAnchor.constraint(equalTo: remainingValueLabel.centerXAnchor),
            remainingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            remainingLabel.widthAnchor.constraint(equalTo: extraLabel.widthAnchor),
            
            //
            bottomContainerView.topAnchor.constraint(equalTo: extraLabel.bottomAnchor, constant: 15),
            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    private var configuration: Configuration = Configuration() {
        didSet {
            setupData()
        }
    }
    
    private var buyNowBlock: (() -> Void)?
    
    public func setupViews(configuration: Configuration,
                           buyNowBlock: @escaping (() -> Void)) {
        self.configuration = configuration
        self.buyNowBlock = buyNowBlock
    }
    
    private func setupData() {
        basicValueLabel.text = configuration.basicStorage
        extraValueLabel.text = configuration.extraStorage
        remainingValueLabel.text = configuration.remaining
        
        basicLabel.text = configuration.basicText
        extraLabel.text = configuration.extraText
        remainingLabel.text = configuration.remainingText
        
        extraStorageLabel.text = "\(configuration.extraText):"
        avgLabel.text = configuration.avgText
        buyNowButton.setTitle("Buy Now", for: .normal)
        iconImageView.image = kErrorImage
        
        //
        let startColor: UIColor = UIColor.hexColor(color: "F09C4A")
        let endColor: UIColor = UIColor.hexColor(color: "EC6742")
        avgLabel.setGradientColor(startColor: startColor, endColor: endColor)
        
        buyNowButton.setGradientColor(startColor: startColor, endColor: endColor)
    }

    // MARK: - actions
    @objc private func buyNowButtonAction() {
        if let block = buyNowBlock {
            block()
        }
    }
}
