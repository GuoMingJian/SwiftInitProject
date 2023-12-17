//
//  MFLatestKeylogsView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/17.
//

import UIKit

class MFLatestKeylogsView: BaseView {
    struct ViewData {
        var icon: UIImage = kErrorImage
        var title: String = ""
        var time: String = ""
    }
    
    struct Configuration {
        var dataList: [ViewData] = []
    }
    
    // MARK: -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setCornerRadius(radius: 10)
        return view
    }()
    
    private lazy var itemsView: UIStackView = {
        let view = UIStackView.stackView(axis: .vertical)
        return view
    }()
    
    private func getLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = font
        return label
    }
    
    private func getItemView(data: ViewData) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: data.icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = getLabel(font: UIFont.PFRegular(fontSize: 15))
        titleLabel.text = data.title
        
        let timeLabel = getLabel(font: UIFont.PFRegular(fontSize: 13))
        timeLabel.text = data.time
        timeLabel.textColor = UIColor.hexColor(color: "B9BABC")
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        
        let iconWidth: CGFloat = 35
        let textHeight: CGFloat = 20
        let itemOffset: CGFloat = 0
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: iconWidth),
            imageView.heightAnchor.constraint(equalToConstant: iconWidth),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: textHeight),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: itemOffset),
            timeLabel.heightAnchor.constraint(equalToConstant: textHeight),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    // MARK: -
    override func setupViews() {
        addSubview(containerView)
        containerView.addSubview(itemsView)
        
        let margin: CGFloat = 8
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemsView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            itemsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            itemsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            itemsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -margin),
        ])
    }
    
    private var configuration: Configuration = Configuration() {
        didSet {
            setupData()
        }
    }
    private var itemViewList: [UIView] = []
    
    private func setupData() {
        itemViewList.removeAll()
        itemsView.removeAllSubViews()
        //
        let itemOffset: CGFloat = 8
        for (_, data) in configuration.dataList.enumerated() {
            let tempView = getItemView(data: data)
            itemViewList.append(tempView)
            itemsView.addArrangedSubview(tempView)
            itemsView.setCustomSpacing(itemOffset, after: tempView)
        }
    }
    
    public func setupViews(configuration: Configuration) {
        self.configuration = configuration
    }
}
