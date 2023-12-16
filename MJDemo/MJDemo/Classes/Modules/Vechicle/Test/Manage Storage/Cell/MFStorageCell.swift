//
//  MFStorageCell.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MFStorageCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCornerRadius(radius: colorViewWidth / 2.0)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    // MARK: -
    let colorViewWidth: CGFloat = 15
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(colorView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: colorViewWidth),
            colorView.heightAnchor.constraint(equalToConstant: colorViewWidth),
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor, constant: -5),
            
            subTitleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -10),
            subTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    public func updateInfo(color: UIColor,
                           name: String,
                           value: String) {
        colorView.backgroundColor = color
        titleLabel.text = name
        subTitleLabel.text = value
    }

}
