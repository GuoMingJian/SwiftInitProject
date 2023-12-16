//
//  MFStorageView.swift
//  KGPro
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MFStorageView: MFBaseView {
    struct Configuration {
        var used: Double = 8.00
        var total: Double = 10.00
        
        var leftImage: UIImage = kErrorImage
        var rightImage: UIImage = UIImage(named: "rightArrow")!
        
        let greenColor: UIColor = .green
        let yellowColor: UIColor = .orange
        let redColor: UIColor = .red
        let progressHeight: CGFloat = 8
    }
    
    // MARK: -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setCornerRadius(radius: 8)
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var storageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    private lazy var bgProgressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.hexColor(color: "F6F7FB")
        view.setCornerRadius(radius: configuration.progressHeight / 2.0)
        return view
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        view.setCornerRadius(radius: configuration.progressHeight / 2.0)
        return view
    }()
    
    private lazy var viewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.addSubview(leftImageView)
        containerView.addSubview(storageLabel)
        containerView.addSubview(bgProgressView)
        bgProgressView.addSubview(progressView)
        containerView.addSubview(rightImageView)
        containerView.addSubview(viewButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftImageView.widthAnchor.constraint(equalToConstant: 25),
            leftImageView.heightAnchor.constraint(equalTo: leftImageView.widthAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            leftImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            storageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            storageLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 10),
            storageLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -15),
            storageLabel.heightAnchor.constraint(equalToConstant: 18),
            
            bgProgressView.topAnchor.constraint(equalTo: storageLabel.bottomAnchor, constant: 8),
            bgProgressView.leadingAnchor.constraint(equalTo: storageLabel.leadingAnchor),
            bgProgressView.trailingAnchor.constraint(equalTo: storageLabel.trailingAnchor),
            bgProgressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            bgProgressView.heightAnchor.constraint(equalToConstant: configuration.progressHeight),
            
            progressView.topAnchor.constraint(equalTo: bgProgressView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: bgProgressView.leadingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bgProgressView.bottomAnchor),
            progressView.heightAnchor.constraint(equalTo: bgProgressView.heightAnchor),
            
            rightImageView.widthAnchor.constraint(equalToConstant: 16),
            rightImageView.heightAnchor.constraint(equalToConstant: 16),
            rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            viewButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    // MARK: -
    private var configuration: Configuration = Configuration() {
        didSet {
            setupData()
        }
    }
    private var clickBlock: (() -> Void)?
    private var progressWidthConstraint: NSLayoutConstraint!
    
    public func setupViews(configuration: Configuration,
                           clickBlock: @escaping (() -> Void)) {
        self.configuration = configuration
        self.clickBlock = clickBlock
    }
    
    private func setupData() {
        leftImageView.image = configuration.leftImage
        rightImageView.image = configuration.rightImage
        //
        let progress: Double = configuration.used / configuration.total
        var color: UIColor = configuration.redColor
        if progress < 0.5 {
            color = configuration.greenColor
        } else if progress < 0.8 {
            color = configuration.yellowColor
        }
        //
        let usedStr = String(format: "%.2f", configuration.used) + "G"
        let totalStr = String(format: "%.2f", configuration.total) + "G"
        storageLabel.text = "Storage: \(usedStr)/\(totalStr)"
        storageLabel.setAttributes(subStrList: [usedStr], color: color)
        //
        if progressWidthConstraint != nil {
            progressWidthConstraint.isActive = false
        }
        progressWidthConstraint = progressView.widthAnchor.constraint(equalTo: bgProgressView.widthAnchor, multiplier: progress)
        progressWidthConstraint.isActive = true
        progressWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
        //
        progressView.backgroundColor = color
    }
    
    // MARK: - actions
    @objc private func viewButtonAction() {
        if let block = clickBlock {
            block()
        }
    }
}
