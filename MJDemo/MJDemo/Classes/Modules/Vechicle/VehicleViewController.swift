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
    
    // MARK: -
    override func configNavigationBar() {
        super.configNavigationBar()
        title = localizedString("tabbar_01")
    }
    
    override func setupViews() {
        //
        view.addSubview(storageView)
        view.addSubview(messageButton)
        
        NSLayoutConstraint.activate([
            storageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            storageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            storageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            messageButton.topAnchor.constraint(equalTo: storageView.bottomAnchor, constant: 30),
            messageButton.heightAnchor.constraint(equalToConstant: 40),
            messageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    // MARK: -
    private func setupData() {
        setupStorageViewData()
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
    
    @objc private func messageButtonAction() {
        let vc = MessageCenterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
