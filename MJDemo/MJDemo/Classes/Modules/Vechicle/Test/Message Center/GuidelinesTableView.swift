//
//  GuidelinesTableView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class GuidelinesTableView: BaseView {
    struct GuidelinesData {
        /// 是否已读
        var isRead: Bool = true
        var bgImage: UIImage = kErrorImage
        var bgUrl: String = ""
        var title: String = ""
        var time: String = ""
    }
    
    struct Configuration {
        var dataList: [GuidelinesData] = []
    }
    
    // MARK: -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = true
        tableView.separatorStyle = .none
        //
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GuidelinesCell.classForCoder(), forCellReuseIdentifier: GuidelinesCell.description())
        return tableView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    // MARK: -
    private var configuration: Configuration = Configuration() {
        didSet {
            setupData()
        }
    }
    
    private var didSelectedBlock: ((_ index: Int) -> Void)?
    
    private func setupData() {
        tableView.reloadData()
    }
    
    public func setupViews(configuration: Configuration,
                           didSelectedBlock: @escaping ((_ index: Int) -> Void)) {
        self.configuration = configuration
        self.didSelectedBlock = didSelectedBlock
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GuidelinesTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuration.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GuidelinesCell = tableView.dequeueReusableCell(withIdentifier: GuidelinesCell.description(), for: indexPath) as! GuidelinesCell
        cell.selectionStyle = .none
        //
        cell.backgroundColor = .clear
        cell.bottomLineView.isHidden = true
        
        let data = configuration.dataList[indexPath.row]
        cell.updateInfo(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if let block = didSelectedBlock {
            block(index)
        }
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

