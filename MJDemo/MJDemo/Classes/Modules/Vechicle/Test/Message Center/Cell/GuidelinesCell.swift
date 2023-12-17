//
//  GuidelinesCell.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class GuidelinesCell: BaseTableViewCell {
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 15)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.hexColor(color: "BBBBBB")
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 14)
        return label
    }()
    
    // MARK: -
    private let leading: CGFloat = 16
    private let topOffset: CGFloat = 6
    private let imageHeight: CGFloat = 60
    private let imageWidth: CGFloat = 120
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(subContainerView)
        subContainerView.addSubview(bgImageView)
        subContainerView.addSubview(titleLabel)
        subContainerView.addSubview(timeLabel)
        containerView.addSubview(redDotView)
        
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            subContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topOffset),
            subContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            subContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -leading),
            subContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -topOffset),
            
            bgImageView.topAnchor.constraint(equalTo: subContainerView.topAnchor, constant: 10),
            bgImageView.leadingAnchor.constraint(equalTo: subContainerView.leadingAnchor, constant: 10),
            bgImageView.bottomAnchor.constraint(equalTo: subContainerView.bottomAnchor, constant: -10),
            bgImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            bgImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            
            titleLabel.topAnchor.constraint(equalTo: bgImageView.topAnchor, constant: -3),
            titleLabel.leadingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: subContainerView.trailingAnchor),
            
            //            timeLabel.topAnchor.constraint(lessThanOrEqualTo: timeLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: bgImageView.bottomAnchor, constant: 3),
        ])
        
        NSLayoutConstraint.activate([
            redDotView.widthAnchor.constraint(equalToConstant: 10),
            redDotView.heightAnchor.constraint(equalTo: redDotView.widthAnchor),
            redDotView.topAnchor.constraint(equalTo: subContainerView.topAnchor, constant: -3),
            redDotView.trailingAnchor.constraint(equalTo: subContainerView.trailingAnchor, constant: 3)
        ])
    }
    
    public func updateInfo(data: GuidelinesTableView.GuidelinesData) {
        bgImageView.kf.setImage(with: URL(string: data.bgUrl), placeholder: kErrorImage)
        titleLabel.text = data.title
        timeLabel.text = data.time
        if data.isRead {
            redDotView.isHidden = true
        } else {
            redDotView.isHidden = false
        }
    }
}
