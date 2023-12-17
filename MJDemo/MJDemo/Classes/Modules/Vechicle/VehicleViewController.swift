//
//  VehicleViewController.swift
//  Anyfleet2310
//
//  Created by 郭明健 on 2023/9/8.
//

import UIKit

class VehicleViewController: BaseViewController {
    private lazy var storageView: MFStorageView = {
        let view = MFStorageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Message Center", for: .normal)
        button.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var convenientEntryView: MFConvenientEntryView = {
        let view = MFConvenientEntryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var latestKeylogsView: MFLatestKeylogsView = {
        let view = MFLatestKeylogsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var appsView: AppsView = {
        let view = AppsView().initFromNib() as! AppsView
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -
    override func configNavigationBar() {
        super.configNavigationBar()
        title = localizedString("tabbar_01")
    }
    
    override func setupViews() {
        //
        view.addSubview(storageView)
        view.addSubview(messageButton)
        view.addSubview(convenientEntryView)
        view.addSubview(latestKeylogsView)
        view.addSubview(appsView)
        appsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            storageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            storageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            storageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            messageButton.topAnchor.constraint(equalTo: storageView.bottomAnchor, constant: 10),
            messageButton.heightAnchor.constraint(equalToConstant: 40),
            messageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            convenientEntryView.topAnchor.constraint(equalTo: messageButton.bottomAnchor, constant: 10),
            convenientEntryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            convenientEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            latestKeylogsView.topAnchor.constraint(equalTo: convenientEntryView.bottomAnchor, constant: 10),
            latestKeylogsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latestKeylogsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            appsView.topAnchor.constraint(equalTo: latestKeylogsView.bottomAnchor, constant: 10),
            appsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            appsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    // MARK: -
    private func setupData() {
        setupStorageViewData()
        setupConvenientEntryViewData()
        setupLatestKeylogsViewData()
        
        appsView.clickAppBlock = { index in
            MJTipView.show("index: \(index)")
        }
    }
    
    private func setupStorageViewData() {
        var config = MFStorageView.Configuration()
        config.used = 7
        storageView.setupViews(configuration: config) { [weak self] in
            guard let self = self else { return }
            let vc = ManageStorageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupConvenientEntryViewData() {
        convenientEntryView.setupViews { index in
            MJTipView.show("index: \(index)")
        }
    }
    
    private func setupLatestKeylogsViewData() {
        var config = MFLatestKeylogsView.Configuration()
        var dataList: [MFLatestKeylogsView.ViewData] = []
        
        var data = MFLatestKeylogsView.ViewData()
        data.title = "tips for first date"
        data.time = "2023-11-21 17:27:32"
        dataList.append(data)
        
        data = MFLatestKeylogsView.ViewData()
        data.title = "Alisa's party at 6pm tonight1233eeeeerrtyy4567888i7o"
        data.time = "2023-11-21 17:27:32"
        dataList.append(data)
        
        data = MFLatestKeylogsView.ViewData()
        data.title = "vruv@qq.com"
        data.time = "2023-11-21 17:27:32"
        dataList.append(data)
        
        config.dataList = dataList
        latestKeylogsView.setupViews(configuration: config)
    }
    
    @objc private func messageButtonAction() {
        let vc = MessageCenterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
