//
//  BaseTableViewCell.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/2/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    enum BaseHeaderFooterType: Int {
        case header = 0
        case footer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 默认不显示系统的右箭头(如果header/footer有高度的情况，系统右箭头出现不居中问题)
        self.accessoryType = .none
        self.contentView.isHidden = true
        
        setupViews()
        updateLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// header/footer 背景色
    public var headerFooterViewBackgroundColor: UIColor = UIColor(red: 234 / 255, green: 234 / 255, blue: 234 / 255, alpha: 1)
    /// 分割线 背景色
    public var bottomLineViewBackgroundColor: UIColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    
    public var headerHeight: CGFloat = 0
    public var footerHeight: CGFloat = 0
    public var headerHeightConstraint: NSLayoutConstraint!
    public var footerHeightConstraint: NSLayoutConstraint!
    
    public var rightImageViewWidth: CGFloat = 16
    public var rightImageViewHeight: CGFloat = 20
    
    public lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = headerFooterViewBackgroundColor
        view.isHidden = false
        return view
    }()
    
    public lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = headerFooterViewBackgroundColor
        view.isHidden = false
        return view
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    /// 底部分割线
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.hexColor(color: "D0D5DD")
        return view
    }()
    
    /// 自定义右箭头
    public lazy var rightImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rightArrow")
        imageView.isHidden = true
        return imageView
    }()
    
    public lazy var redDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.setCornerRadius(radius: 5)
        return view
    }()
    
    // MARK: - 
    public func setupViews() {
        showRightArrowImageView(false)
        
        addSubview(headerView)
        addSubview(containerView)
        containerView.addSubview(bottomLineView)
        containerView.addSubview(rightImageView)
        addSubview(footerView)
    }
    
    public func updateLayoutConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: rightImageViewWidth),
            rightImageView.heightAnchor.constraint(equalToConstant: rightImageViewHeight)
        ])
        
        if headerHeightConstraint != nil {
            headerHeightConstraint.isActive = false
        }
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        
        if footerHeightConstraint != nil {
            footerHeightConstraint.isActive = false
        }
        footerHeightConstraint = footerView.heightAnchor.constraint(equalToConstant: footerHeight)
        footerHeightConstraint.isActive = true
    }
    
    // MARK: - 显示或隐藏 cell 的 headerView / footerView
    /// 显示或隐藏 cell 的 headerView / footerView
    public func showHeaderFooterView(_ type: BaseHeaderFooterType,
                                     isShow: Bool,
                                     viewHeight: CGFloat = 10,
                                     backgroundColor: UIColor = UIColor(red: 234 / 255, green: 234 / 255, blue: 234 / 255, alpha: 1)) {
        switch type {
        case .header:
            headerView.isHidden = !isShow
            headerView.backgroundColor = backgroundColor
            headerHeight = viewHeight
        case .footer:
            footerView.isHidden = !isShow
            footerView.backgroundColor = backgroundColor
            footerHeight = viewHeight
        }
        updateLayoutConstraints()
    }
    
    // MARK: - 是否显示右箭头
    /// 是否显示右箭头
    public func showRightArrowImageView(_ isShow: Bool = true) {
        rightImageView.isHidden = !isShow
    }
}
