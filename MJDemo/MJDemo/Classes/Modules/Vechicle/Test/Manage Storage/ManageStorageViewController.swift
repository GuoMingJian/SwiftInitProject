//
//  ManageStorageViewController.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class ManageStorageViewController: BaseViewController {
    struct StorageData {
        var name: String = ""
        var color: UIColor = .orange
        var used: Double = 1.0
        var unit: String = "GB"
        //
        var total: Double = 10
    }
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = true
        tableView.separatorStyle = .none
        //
        tableView.setCornerRadius(radius: 10)
        tableView.backgroundColor = UIColor.hexColor(color: "F4F7FA")
        //
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MFStorageCell.classForCoder(), forCellReuseIdentifier: MFStorageCell.description())
        tableView.register(MFStorageFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: MFStorageFooterView.description())
        return tableView
    }()
    
    // MARK: -
    private var dataSource: [StorageData] = []
    private var firstCell: MFStorageCell?
    private var lastCell: MFStorageCell?
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(pieChartView)
        view.addSubview(storageBuyNowView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 200),
            
            storageBuyNowView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 15),
            storageBuyNowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            storageBuyNowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: storageBuyNowView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: storageBuyNowView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: storageBuyNowView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstCell != nil {
            firstCell!.setCornerRadius(conrners: [.topLeft, .topRight], radius: 10)
        }
        if lastCell != nil {
            lastCell!.setCornerRadius(conrners: [.bottomLeft, .bottomRight], radius: 10)
        }
    }
    
    // MARK: -
    private func setupData() {
        var nameList: [String] = ["Photo",
                                  "Social Apps",
                                  "Record Surround",
                                  "Videos Preview",
                                  "Record Calls",
                                  "Capture Screenshots",
                                  "Take Photos"]
        nameList.append("Remaining")
        
        let Remaining: Double = 0.65
        
        for (index, _) in nameList.enumerated() {
            var storageData: StorageData = StorageData()
            storageData.color = UIColor.randomColor()
            storageData.name = nameList[index]
            if index != nameList.count - 1 {
                storageData.used = Double(arc4random() % 20) / 10.0
            } else {
                storageData.used = Remaining
            }
            //
            dataSource.append(storageData)
        }
        
        var sum: Double = 0
        for (_, item) in dataSource.enumerated() {
            sum += item.used
        }
        
        for (index, item) in dataSource.enumerated() {
            var newItem = item
            newItem.total = sum
            //
            dataSource.remove(at: index)
            dataSource.insert(newItem, at: index)
        }
        
        setupPieChartViewData()
        setupBuyNowViewData()
    }
    
    private func setupPieChartViewData() {
        var config = MJPieChartView.Configuration()
        
        var dataList: [MJPieChartView.MJPieChartData] = []
        
        for (_, item) in dataSource.enumerated() {
            var pieData: MJPieChartView.MJPieChartData = MJPieChartView.MJPieChartData()
            pieData.value = item.used
            pieData.color = item.color
            dataList.append(pieData)
        }
        
        if dataSource.count > 0 {
            let sum = dataSource.first!.total
            let sumStr = String(format: "%.2f", sum)
            
            let remaining: Double = dataSource.last!.used
            
            let used = sum - remaining
            let usedStr = String(format: "%.2f", used)
            
            let percent: Double = used / sum
            let percentInt: Int = Int(percent * 100)
            
            config.dataList = dataList
            config.subTitle = "Total Used:"
            config.title = "\(usedStr)GB,\n\(percentInt)% with \(sumStr)GB"
            pieChartView.setupViews(configuration: config)
        }
    }
    
    private func setupBuyNowViewData() {
        let config = MFStorageBuyNowView.Configuration()
        storageBuyNowView.setupViews(configuration: config) { [weak self] in
            guard let _ = self else { return }
            MJTipView.show("Boy Now!")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ManageStorageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MFStorageCell = tableView.dequeueReusableCell(withIdentifier: MFStorageCell.description(), for: indexPath) as! MFStorageCell
        cell.selectionStyle = .none
        //
        cell.bottomLineView.isHidden = true
        cell.showRightArrowImageView()
        //
        let data = dataSource[indexPath.row]
        let usedStr = String(format: "%.2f", data.used) + data.unit
        cell.updateInfo(color: data.color, name: data.name, value: usedStr)
        
        if indexPath.row == 0 {
            self.firstCell = cell
        }
        if indexPath.row == dataSource.count - 1 {
            self.lastCell = cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        MJTipView.show("Click: \(index)")
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: MFStorageFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MFStorageFooterView.description()) as! MFStorageFooterView
        footerView.contentView.backgroundColor = .clear
        let text: String = """
Tips:
1.When the data storage of the function is full, its more previous data will be deleted.
2.The type of Extra Storage is determined by the type of Benefit: 1- Month Plan
3.When you purchase the Extra Storage service for one device, all devices under the VIP Benefit to which the device belongs will be equally entitled to the Extra Storage service.
"""
        footerView.updateInfo(text: text)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 0.01
    //    }
}
