//
//  ManageStorageViewController.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class ManageStorageViewController: BaseViewController {
    struct Configuration {
        
    }
    
    // MARK: -
    private lazy var pieChartView: MJPieChartView = {
        let view = MJPieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var storageBuyNowView: MFStorageBuyNowView = {
        let view = MFStorageBuyNowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = UIColor.hexColor(color: "F4F7FA")
        
        view.addSubview(pieChartView)
        view.addSubview(storageBuyNowView)
        
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 200),
            
            storageBuyNowView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 15),
            storageBuyNowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            storageBuyNowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func configNavigationBar() {
        title = "Manage Storage"
    }
    
    // MARK: -
    private func setupData() {
        setupPieChartViewData()
        setupBuyNowViewData()
    }
    
    private func setupPieChartViewData() {
        var config = MJPieChartView.Configuration()
        
        var dataList: [MJPieChartView.MJPieChartData] = []
        for _ in 0...9 {
            var pieData: MJPieChartView.MJPieChartData = MJPieChartView.MJPieChartData()
            pieData.value = Double(arc4random() % 100)
            pieData.color = UIColor.randomColor()
            dataList.append(pieData)
        }
        
        config.dataList = dataList
        config.subTitle = "Total Used:"
        config.title = "3.99GB,\n88% with 4GB"
        pieChartView.setupViews(configuration: config)
    }
    
    private func setupBuyNowViewData() {
        let config = MFStorageBuyNowView.Configuration()
        storageBuyNowView.setupViews(configuration: config) { [weak self] in
            guard let _ = self else { return }
            MJTipView.show("Boy Now!")
        }
    }
}
