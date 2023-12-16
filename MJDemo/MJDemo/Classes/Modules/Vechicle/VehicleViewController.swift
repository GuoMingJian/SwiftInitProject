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
    
    // MARK: -
    override func configNavigationBar() {
        super.configNavigationBar()
        title = localizedString("tabbar_01")
    }
    
    override func setupViews() {
        view.backgroundColor = UIColor.hexColor(color: "F4F7FA")
        //
        view.addSubview(storageView)
        NSLayoutConstraint.activate([
            storageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            storageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            storageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
}
