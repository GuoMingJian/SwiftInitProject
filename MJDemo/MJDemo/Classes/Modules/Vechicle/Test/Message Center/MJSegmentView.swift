//
//  MJSegmentView.swift
//  Anyfleet2310
//
//  Created by 郭明健 on 2023/9/18.
//

import UIKit

class MJSegmentView: BaseView {
    struct Configuration {
        var leftText: String = ""
        var rightText: String = ""
        var itemTopOffset: CGFloat = 15
        var itemSpac: CGFloat = 25
        var selectedIndex: Int = 0
        var selectedColor: UIColor = UIColor.hexColor(color: "4481F1")
        var selectedFont: UIFont = UIFont.PFMedium(fontSize: 16)
        var normalColor: UIColor = .black
        var normalFont: UIFont = UIFont.PFRegular(fontSize: 15)
    }
    // MARK: -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftButton: MJEnlargeButton = {
        let button = MJEnlargeButton(type: .custom)
        button.enlargeInset = 10
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: MJEnlargeButton = {
        let button = MJEnlargeButton(type: .custom)
        button.enlargeInset = 10
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var vLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: -
    private var configuration: Configuration = Configuration() {
        didSet {
            setupData()
        }
    }
    private var didChangedSelected: ((_ index: Int) -> Void)?
    
    override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(leftButton)
        containerView.addSubview(vLineView)
        containerView.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            vLineView.widthAnchor.constraint(equalToConstant: 1),
            vLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            vLineView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            vLineView.heightAnchor.constraint(equalToConstant: 20),
            
            leftButton.trailingAnchor.constraint(equalTo: vLineView.leadingAnchor, constant: -configuration.itemSpac),
            leftButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 30),
            leftButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: configuration.itemTopOffset),
            
            rightButton.leadingAnchor.constraint(equalTo: vLineView.trailingAnchor, constant: configuration.itemSpac),
            rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            rightButton.heightAnchor.constraint(equalTo: leftButton.heightAnchor),
        ])
    }
    
    // MARK: - public
    public func setupViews(configuration: Configuration,
                           didChangedSelected: @escaping ((_ index: Int) -> Void)) {
        self.configuration = configuration
        self.didChangedSelected = didChangedSelected
    }
    
    public func updateRedDot(index: Int, 
                             isShow: Bool) {
        if index == 0 {
            if isShow {
                leftButton.showRedDot(xOffset: 5, yOffset: 8)
            } else {
                leftButton.hiddenRedDot()
            }
        } else {
            if isShow {
                rightButton.showRedDot(xOffset: 5, yOffset: 8)
            } else {
                rightButton.hiddenRedDot()
            }
        }
    }
    
    public func clickPageIndex(_ index: Int) {
        if index < 0 || index > 1 {
            return
        }
        updateSelectedViewLayoutConstraint(index)
    }
    
    // MARK: -
    private func setupData() {
        leftButton.setTitle(configuration.leftText, for: .normal)
        rightButton.setTitle(configuration.rightText, for: .normal)
        clickPageIndex(configuration.selectedIndex)
    }
    
    // MARK: - actions
    @objc private func leftButtonAction() {
        updateSelectedViewLayoutConstraint(0)
        
        if let block = didChangedSelected {
            block(0)
        }
    }
    
    @objc private func rightButtonAction() {
        updateSelectedViewLayoutConstraint(1)
        
        if let block = didChangedSelected {
            block(1)
        }
    }
    
    private func updateSelectedViewLayoutConstraint(_ index: Int) {
        if index == 0 {
            leftButton.setTitleColor(configuration.selectedColor, for: .normal)
            rightButton.setTitleColor(configuration.normalColor, for: .normal)
            leftButton.titleLabel?.font = configuration.selectedFont
            rightButton.titleLabel?.font = configuration.selectedFont
        } else {
            rightButton.setTitleColor(configuration.selectedColor, for: .normal)
            leftButton.setTitleColor(configuration.normalColor, for: .normal)
            rightButton.titleLabel?.font = configuration.selectedFont
            leftButton.titleLabel?.font = configuration.selectedFont
        }
    }
    
}
