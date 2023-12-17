//
//  MessagesCell.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit
import Kingfisher

class MessagesCell: BaseTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: -
    private lazy var subContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCornerRadius(radius: 10)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.PFRegular(fontSize: 15)
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.hexColor(color: "BBBBBB")
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 15)
        return label
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.hexColor(color: "BBBBBB")
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 15)
        return label
    }()
    
    // MARK: -
    private let leading: CGFloat = 16
    private let topOffset: CGFloat = 6
    private let bottomOffset: CGFloat = 12
    private let bgImageHeight: CGFloat = 130
    private let textViewHeight: CGFloat = 70
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(subContainerView)
        subContainerView.addSubview(bgImageView)
        subContainerView.addSubview(bottomContainerView)
        
        bottomContainerView.addSubview(textView)
        bottomContainerView.addSubview(timeLabel)
        bottomContainerView.addSubview(viewsLabel)
        
        containerView.addSubview(redDotView)
        
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            subContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topOffset),
            subContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            subContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -leading),
            subContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -topOffset),
            
            bgImageView.topAnchor.constraint(equalTo: subContainerView.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: subContainerView.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: subContainerView.trailingAnchor),
            bgImageView.heightAnchor.constraint(equalToConstant: bgImageHeight),
            
            bottomContainerView.topAnchor.constraint(equalTo: bgImageView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: subContainerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: subContainerView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: subContainerView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 2),
            textView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: textViewHeight),
            
            timeLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -bottomOffset),
            
            viewsLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            viewsLabel.heightAnchor.constraint(equalTo: timeLabel.heightAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            redDotView.widthAnchor.constraint(equalToConstant: 10),
            redDotView.heightAnchor.constraint(equalTo: redDotView.widthAnchor),
            redDotView.topAnchor.constraint(equalTo: bgImageView.topAnchor, constant: -3),
            redDotView.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: 3)
        ])
    }
    
    public func updateInfo(data: MessagesTableView.MessageData) {
        bgImageView.kf.setImage(with: URL(string: data.bgUrl), placeholder: kErrorImage)
        textView.insertPicture(data.typeImage)
        textView.insertString(data.title)
        timeLabel.text = data.time
        viewsLabel.text = data.viewsCount.toString() + " Views"
        if data.isRead {
            redDotView.isHidden = true
        } else {
            redDotView.isHidden = false
        }
    }
}
