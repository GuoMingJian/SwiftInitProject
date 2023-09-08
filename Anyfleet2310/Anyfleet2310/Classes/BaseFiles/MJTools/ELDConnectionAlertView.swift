//
//  ELDConnectionAlertView.swift
//  AnytrekELD
//
//  Created by 郭明健 on 2023/7/11.
//

import UIKit

class ELDConnectionAlertView: UIView {
    struct Configuration {
        var bgColor: UIColor = Common.ELDColorBackgroundColor(alpha: 0.5)
        var alertBgColor: UIColor = .white
        
        var image: UIImage? = nil // UIImage(named: "warningYellow") ?? UIImage()
        var imageWidth: CGFloat = 65
        
        var alertLeading: CGFloat = 30
        var imageTop: CGFloat = 10
        var titleTop: CGFloat = 10
        var titleLeading: CGFloat = 20
        var subTitleTop: CGFloat = 5
        var tableViewTop: CGFloat = 5
        var tableViewBottom: CGFloat = 10
        var buttonHeight: CGFloat = 45
        var radius: CGFloat = 12
        
        var animationTimeInterval: TimeInterval = 0.2
        
        var title: String = "Title"
        var titleColor: UIColor = Common.ATColorBlack()
        var titleFont: UIFont = UIFont.PFMedium(fontSize: 18)
        
        var subTitle: String = "Sub Title"
        var subTitleColor: UIColor = Common.ELDColorSubTextColor()
        var subTitleFont: UIFont = UIFont.PFRegular(fontSize: 14)
        
        var tableViewCellFont: UIFont = UIFont.PFMedium(fontSize: 15)
        var tableViewCellColor: UIColor = Common.ATColorBlack()
        var cellHeight: CGFloat = 30
        var maxCellCount: Int = 4
        var dataSource: [String] = []
        var selectedValue: String = ""
        
        var cancelButtonText: String = "Cancel"
        var confirmButtonText: String = "Save"
        var buttonFont: UIFont = UIFont.PFMedium(fontSize: 16)
        var buttonColor: UIColor = Common.ELDColorBtnTextColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    public lazy var bgContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
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
        //
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConnectionCell.classForCoder(), forCellReuseIdentifier: ConnectionCell.description())
        return tableView
    }()
    
    // MARK: -
    public var configuration: Configuration! {
        didSet {
            setupData()
        }
    }
    private var atView: UIView!
    private var selectedBlock: ((_ index: Int, _ name: String) -> Void)?
    private var currentIndex: Int = -1
    
    // MARK: - public
    public func setupViews(atView: UIView,
                           configuration: Configuration,
                           selectedBlock: @escaping (_ index: Int, _ name: String) -> Void) {
        self.configuration = configuration
        self.atView = atView
        self.selectedBlock = selectedBlock
        //
        setupViews()
    }
    
    // MARK: - private
    private func setupData() {
        bgContainerView.backgroundColor = configuration.bgColor
        containerView.backgroundColor = configuration.alertBgColor
        
        imageView.image = configuration.image
        
        titleLabel.text = configuration.title
        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor
        
        subTitleLabel.text = configuration.subTitle
        subTitleLabel.font = configuration.subTitleFont
        subTitleLabel.textColor = configuration.subTitleColor
        
        cancelButton.setTitle(configuration.cancelButtonText, for: .normal)
        cancelButton.titleLabel?.font = configuration.buttonFont
        cancelButton.setTitleColor(configuration.buttonColor, for: .normal)
        
        confirmButton.setTitle(configuration.confirmButtonText, for: .normal)
        confirmButton.titleLabel?.font = configuration.buttonFont
        confirmButton.setTitleColor(configuration.buttonColor, for: .normal)
        
        //
        for (index, item) in configuration.dataSource.enumerated() {
            if item == configuration.selectedValue {
                let indexPath = IndexPath(row: index, section: 0)
                self.currentIndex = index
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [self] in
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                })
            }
        }
    }
    
    private func setupViews() {
        containerView.setCornerRadius(radius: configuration.radius)
        
        atView.addSubview(self)
        addSubview(bgContainerView)
        bgContainerView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: atView.topAnchor),
            self.leadingAnchor.constraint(equalTo: atView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: atView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: atView.bottomAnchor),
            
            bgContainerView.topAnchor.constraint(equalTo: topAnchor),
            bgContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: bgContainerView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bgContainerView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: bgContainerView.leadingAnchor, constant: configuration.alertLeading),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: configuration.imageTop),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: configuration.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: configuration.imageWidth),
            //            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: configuration.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: configuration.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -configuration.titleLeading),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: configuration.subTitleTop),
            subTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: configuration.titleLeading),
            subTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -configuration.titleLeading),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: configuration.buttonHeight),
            cancelButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            
            confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: configuration.buttonHeight),
            
            confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let containerViewWidth = containerView.width
        var tbHeight: CGFloat = 0
        
        for (_, item) in configuration.dataSource.enumerated() {
            tbHeight += item.textHeight(font: configuration.tableViewCellFont, width: containerViewWidth) + 20
        }
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -configuration.tableViewBottom),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: configuration.tableViewTop),
            tableView.heightAnchor.constraint(equalToConstant: tbHeight)
        ])
        
        DispatchQueue.main.async { [self] in
            self.layoutIfNeeded()
            self.setNeedsLayout()
            cancelButton.addBorder(side: .top, color: Common.ATColorLineColor(), thickness: 1)
            cancelButton.addBorder(side: .right, color: Common.ATColorLineColor(), thickness: 1)
            confirmButton.addBorder(side: .top, color: Common.ATColorLineColor(), thickness: 1)
        }
    }
    
    @objc private func cancelAction() {
        dismissScale(duration: configuration.animationTimeInterval, bgView: self.bgContainerView)
    }
    
    @objc private func confirmAction() {
        if currentIndex >= 0, currentIndex <= configuration.dataSource.count - 1 {
            let name = configuration.dataSource[currentIndex]
            
            if selectedBlock != nil {
                selectedBlock!(currentIndex, name)
            }
            cancelAction()
        } else {
            MJTipView.show("请选择车辆！")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ELDConnectionAlertView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConnectionCell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.description(), for: indexPath) as! ConnectionCell
        
        if indexPath.row <= configuration.dataSource.count - 1 {
            let text = configuration.dataSource[indexPath.row]
            
            cell.titleLabel.text = text
            cell.titleLabel.font = configuration.tableViewCellFont
            cell.titleLabel.textColor = configuration.tableViewCellColor
            cell.titleLabel.textAlignment = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        //
        if indexPath.row <= configuration.dataSource.count - 1 {
            let text = configuration.dataSource[indexPath.row]
            configuration.selectedValue = text
        }
    }
}

class ConnectionCell: BaseTableViewCell {
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.PFRegular(fontSize: 16)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        containerView.backgroundColor = .clear
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])
    }
}
