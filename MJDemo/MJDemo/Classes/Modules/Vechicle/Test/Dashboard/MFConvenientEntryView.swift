//
//  MFConvenientEntryView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/17.
//

import UIKit

class MFConvenientEntryView: BaseView {
    // MARK: -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setCornerRadius(radius: 10)
        return view
    }()
    
//    private lazy var liveScreenImageView: UIImageView = {
//        let imageView: UIImageView = UIImageView(frame: CGRectZero)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private lazy var recSurroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var takePhotosImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 15)
        return label
    }
    
//    private lazy var liveScreenLabel: UILabel = {
//        let label = getLabel()
//        return label
//    }()
    
    private lazy var recSurroundLabel: UILabel = {
        let label = getLabel()
        return label
    }()
    
    private lazy var takePhotosLabel: UILabel = {
        let label = getLabel()
        return label
    }()
    
//    private lazy var liveScreenButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tag = 0
//        button.addTarget(self, action: #selector(itemAction(button:)), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var recSurroundButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(itemAction(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var takePhotosButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(itemAction(button:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: -
    private let iconHeight: CGFloat = 25
    private let topOffset: CGFloat = 10
    private let itemOffset: CGFloat = 6
    private let leading: CGFloat = 16
    private let textHeight: CGFloat = 20
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        
//        containerView.addSubview(liveScreenImageView)
//        containerView.addSubview(liveScreenLabel)
//        containerView.addSubview(liveScreenButton)
        
        containerView.addSubview(recSurroundImageView)
        containerView.addSubview(recSurroundLabel)
        containerView.addSubview(recSurroundButton)
        
        containerView.addSubview(takePhotosImageView)
        containerView.addSubview(takePhotosLabel)
        containerView.addSubview(takePhotosButton)
        
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
//            recSurroundLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            recSurroundLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            recSurroundLabel.heightAnchor.constraint(equalToConstant: textHeight),
            recSurroundLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -topOffset),
            
            recSurroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topOffset),
            recSurroundImageView.bottomAnchor.constraint(equalTo: recSurroundLabel.topAnchor, constant: -itemOffset),
            recSurroundImageView.centerXAnchor.constraint(equalTo: recSurroundLabel.centerXAnchor),
            recSurroundImageView.widthAnchor.constraint(equalToConstant: iconHeight),
            recSurroundImageView.heightAnchor.constraint(equalToConstant: iconHeight),
            
            recSurroundButton.bottomAnchor.constraint(equalTo: recSurroundLabel.bottomAnchor),
            recSurroundButton.leadingAnchor.constraint(equalTo: recSurroundLabel.leadingAnchor),
            recSurroundButton.trailingAnchor.constraint(equalTo: recSurroundLabel.trailingAnchor),
            recSurroundButton.topAnchor.constraint(equalTo: recSurroundImageView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
//            takePhotosLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -leading),
            takePhotosLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            takePhotosLabel.heightAnchor.constraint(equalToConstant: textHeight),
            takePhotosLabel.topAnchor.constraint(equalTo: recSurroundLabel.topAnchor),
            
            takePhotosImageView.topAnchor.constraint(equalTo: recSurroundImageView.topAnchor),
            takePhotosImageView.centerXAnchor.constraint(equalTo: takePhotosLabel.centerXAnchor),
            takePhotosImageView.widthAnchor.constraint(equalToConstant: iconHeight),
            takePhotosImageView.heightAnchor.constraint(equalToConstant: iconHeight),
            
            takePhotosButton.bottomAnchor.constraint(equalTo: takePhotosLabel.bottomAnchor),
            takePhotosButton.leadingAnchor.constraint(equalTo: takePhotosLabel.leadingAnchor),
            takePhotosButton.trailingAnchor.constraint(equalTo: takePhotosLabel.trailingAnchor),
            takePhotosButton.topAnchor.constraint(equalTo: takePhotosImageView.topAnchor),
        ])
        
//        NSLayoutConstraint.activate([
//            liveScreenLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
//            liveScreenLabel.heightAnchor.constraint(equalToConstant: textHeight),
//            liveScreenLabel.topAnchor.constraint(equalTo: recSurroundLabel.topAnchor),
//            
//            liveScreenImageView.topAnchor.constraint(equalTo: recSurroundImageView.topAnchor),
//            liveScreenImageView.centerXAnchor.constraint(equalTo: liveScreenLabel.centerXAnchor),
//            liveScreenImageView.widthAnchor.constraint(equalToConstant: iconHeight),
//            liveScreenImageView.heightAnchor.constraint(equalToConstant: iconHeight),
//            
//            liveScreenButton.bottomAnchor.constraint(equalTo: liveScreenLabel.bottomAnchor),
//            liveScreenButton.leadingAnchor.constraint(equalTo: liveScreenLabel.leadingAnchor),
//            liveScreenButton.trailingAnchor.constraint(equalTo: liveScreenLabel.trailingAnchor),
//            liveScreenButton.topAnchor.constraint(equalTo: liveScreenImageView.topAnchor),
//        ])
    }
    
    // MARK: -
    private var selectedBlock: ((_ index: Int) -> Void)?
    
    public func setupViews(selectedBlock: @escaping ((_ index: Int) -> Void)) {
        self.selectedBlock = selectedBlock
        setupData()
    }
    
    private func setupData() {
//        liveScreenLabel.text = "Live Screen"
        recSurroundLabel.text = "Rec Surround"
        takePhotosLabel.text = "Take Photos"
        
//        liveScreenImageView.image = kErrorImage
        recSurroundImageView.image = kErrorImage
        takePhotosImageView.image = kErrorImage
        
//        addLine()
    }
    
//    private func addLine() {
//        let font1 = UIFont.PFMedium(fontSize: 15)
//        let font2 = UIFont.PFRegular(fontSize: 14)
//        let deletePrice = "$85.99"
//        let previousPrice = "$59.99/\(deletePrice)"
//        
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: previousPrice, attributes: [NSAttributedString.Key.font: font1])
//        
//        let rang = previousPrice.range(of: deletePrice)
//        
//        attributeString.addAttributes([NSAttributedString.Key.baselineOffset : 0,
//                                       NSAttributedString.Key.strikethroughStyle : 1.5,
//                                       NSAttributedString.Key.foregroundColor : UIColor.lightGray,
//                                       NSAttributedString.Key.font : font2], range: rang)
//        //
//        liveScreenLabel.attributedText = attributeString
//    }
    
    // MARK: - actions
    @objc private func itemAction(button: UIButton) {
        if let block = selectedBlock {
            block(button.tag)
        }
    }
}
