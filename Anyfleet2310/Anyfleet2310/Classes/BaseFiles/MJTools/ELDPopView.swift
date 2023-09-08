//
//  ELDPopView.swift
//  AnytrekELD
//
//  Created by 郭明健 on 2023/7/20.
//

/*
 var config = ELDPopView.Configuration()
 config.startPoint = bottomPoint
 config.popViewWidth = locationBgView.width
 config.dataSource = dataSource
 
 popView = ELDPopView()
 popView.show(configuration: config) { index, value in
 didSelected(index)
 }
 */

import UIKit

class ELDPopView: UIView {
    struct Configuration {
        var startPoint: CGPoint = .zero
        var popViewWidth: CGFloat = 50
        
        var dataSource: [String] = []
        var iconList: [UIImage?] = []
        var currentSelectedIndex: Int = -1
        
        /// 默认最多显示几行
        let maxRowCount: Int = 5
        var radius: CGFloat = 5
        let cellHeight: CGFloat = 45
        
        var bgColor: UIColor = Common.ATColorWhite()
        var textFont: UIFont = UIFont.PFMedium(fontSize: 15)
        var textColor: UIColor = Common.ATColorBlack()
        var lineColor: UIColor = Common.ATColorLineColor()
    }
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = true
        tableView.bounces = true
        tableView.separatorStyle = .none
        //
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.01, height: 0.01))
        // 取消顶部留白
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        //
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ELDPopViewCell.classForCoder(), forCellReuseIdentifier: ELDPopViewCell.description())
        return tableView
    }()
    
    // MARK: -
    public var configuration: Configuration! {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var didSelectedBlock: ((_ index: Int, _ value: String) -> Void)?
    
    // MARK: - public
    public func show(configuration: Configuration,
                     didSelectedBlock: @escaping ((_ index: Int, _ value: String) -> Void)) {
        self.configuration = configuration
        self.didSelectedBlock = didSelectedBlock
        //
        setupViews()
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
    // MARK: - private
    private func setupViews() {
        if let keyWindow = UIView.getKeyWindow() {
            keyWindow.addSubview(self)
            self.frame = keyWindow.bounds
            self.backgroundColor = Common.ATColorWhite(alpha: 0.2)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            tapGesture.delegate = self
            self.addGestureRecognizer(tapGesture)
            //
            self.addSubview(tableView)
            //
            let rowCount = min(configuration.maxRowCount, configuration.dataSource.count)
            let popViewHeight: CGFloat = CGFloat(rowCount) * configuration.cellHeight
            let startPoint = configuration.startPoint
            let rect: CGRect = CGRect(x: startPoint.x, y: startPoint.y, width: configuration.popViewWidth, height: popViewHeight)
            tableView.frame = rect
            //
            tableView.setCornerRadius(radius: configuration.radius)
            tableView.setBorderStyle(borderWidth: 1, borderColor: Common.ATColorLineColor())
        }
    }
    
    // MARK: - actions
    @objc private func tapAction() {
        dismiss()
    }
}

extension ELDPopView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil {
            if touch.view!.isDescendant(of: tableView) {
                return false
            }
        }
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ELDPopView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ELDPopViewCell = tableView.dequeueReusableCell(withIdentifier: ELDPopViewCell.description(), for: indexPath) as! ELDPopViewCell
        if indexPath.row < configuration.dataSource.count {
            let text = configuration.dataSource[indexPath.row]
            let isCurrent = (indexPath.row == configuration.currentSelectedIndex)
            var image: UIImage? = nil
            if indexPath.row < configuration.iconList.count {
                image = configuration.iconList[indexPath.row]
            }
            cell.updateInfo(text: text, cellHeight: configuration.cellHeight, image: image, isCurrentItem: isCurrent, isShowLine: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < configuration.dataSource.count {
            let text = configuration.dataSource[indexPath.row]
            //
            if let block = didSelectedBlock {
                block(indexPath.row, text)
            }
        }
        dismiss()
    }
}

// MARK: - ELDPopViewCell
class ELDPopViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Common.ATColorBlack()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.PFMedium(fontSize: 15)
        return label
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -
    private let topOffset: CGFloat = 8
    private let leftOffset: CGFloat = 16
    private let iconWidth: CGFloat = 15
    
    // MARK: -
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(rightImageView)
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topOffset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftOffset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topOffset),
            
            rightImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            rightImageView.heightAnchor.constraint(equalTo:  rightImageView.widthAnchor),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            rightImageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -leftOffset),
            
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func updateInfo(text: String,
                           cellHeight: CGFloat,
                           image: UIImage?,
                           isCurrentItem: Bool = false,
                           isShowLine: Bool = true,
                           lineColor: UIColor = Common.ATColorLineColor()) {
        titleLabel.text = text
        titleLabel.textColor = isCurrentItem ? Common.ATColorBlue() : Common.ATColorBlack()
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: cellHeight - 2 * topOffset)
        ])
        
        rightImageView.image = image
        
        lineView.backgroundColor = lineColor
        lineView.isHidden = !isShowLine
    }
}
