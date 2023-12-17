//
//  MessageCenterViewController.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MessageCenterViewController: BaseViewController {
    private lazy var segmentView: MJSegmentView = {
        let view = MJSegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var messagesTableView: MessagesTableView = {
        let view = MessagesTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var guidelinesTableView: GuidelinesTableView = {
        let view = GuidelinesTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        title = "Message Center"
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(segmentView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(messagesTableView)
        scrollView.addSubview(guidelinesTableView)
        
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        view.layoutIfNeeded()
        view.setNeedsLayout()
        let scrollViewHeight: CGFloat = scrollView.height
        scrollView.contentSize = CGSize(width: kScreenWidth * 2, height: scrollViewHeight)
        
        //
        layoutViewsConstraints()
    }
    
    private func layoutViewsConstraints() {
        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            messagesTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            messagesTableView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            guidelinesTableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            guidelinesTableView.leadingAnchor.constraint(equalTo: messagesTableView.trailingAnchor),
            guidelinesTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            guidelinesTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            guidelinesTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            guidelinesTableView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    // MARK: -
    private func setupData() {
        setupSegmentView()
        setupMessagesView()
        setupGuidelinesView()
    }
    
    private func setupSegmentView() {
        var config = MJSegmentView.Configuration()
        config.leftText = "Messages"
        config.rightText = "Guidelines"
        config.selectedIndex = self.currentIndex
        segmentView.setupViews(configuration: config) { index in
            self.currentIndex = index
            self.scrollPage(index)
        }
        segmentView.updateRedDot(index: 0, isShow: true)
        segmentView.updateRedDot(index: 1, isShow: true)
    }
    
    private func setupMessagesView() {
        var dataList: [MessagesTableView.MessageData] = []
        
        var data = MessagesTableView.MessageData()
        data.bgUrl = "https://t7.baidu.com/it/u=1956604245,3662848045&fm=193&f=GIF"
        data.isRead = true
        data.time = "2023/12/15"
        data.viewsCount = 120
        data.typeImage = UIImage(named: "hot")!
        data.title = "How to Fake Location on Android and iOS to Stop being ..."
        dataList.append(data)
        
        data = MessagesTableView.MessageData()
        data.bgUrl = "https://t7.baidu.com/it/u=2529476510,3041785782&fm=193&f=GIF"
        data.isRead = false
        data.time = "2023/12/16"
        data.viewsCount = 23
        data.typeImage = UIImage(named: "new")!
        data.title = "[2023 Full Guide] How to Hack iCloud Without Being Knowing"
        dataList.append(data)
        
        var config = MessagesTableView.Configuration()
        config.dataList = dataList
        
        messagesTableView.setupViews(configuration: config) { index in
            MJTipView.show("index: \(index)")
        }
    }
    
    private func setupGuidelinesView() {
        var dataList: [GuidelinesTableView.GuidelinesData] = []
        
        var data = GuidelinesTableView.GuidelinesData()
        data.bgUrl = "https://t7.baidu.com/it/u=1956604245,3662848045&fm=193&f=GIF"
        data.isRead = true
        data.title = "New Features!New Features!New Features..."
        data.time = "2023/12/15"
        dataList.append(data)
        
        data = GuidelinesTableView.GuidelinesData()
        data.bgUrl = "https://t7.baidu.com/it/u=2529476510,3041785782&fm=193&f=GIF"
        data.isRead = false
        data.title = "New Features!New Features!New Features..."
        data.time = "2023/12/16"
        dataList.append(data)
        
        data = GuidelinesTableView.GuidelinesData()
        data.bgUrl = "https://t7.baidu.com/it/u=3713375227,571533122&fm=193&f=GIF"
        data.isRead = false
        data.title = "New Features!New Features!New Features..."
        data.time = "2023/12/17"
        dataList.append(data)
        
        var config = GuidelinesTableView.Configuration()
        config.dataList = dataList
        
        guidelinesTableView.setupViews(configuration: config) { index in
            MJTipView.show("index: \(index)")
        }
    }
}

extension MessageCenterViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let page: Int = Int(xOffset / kScreenWidth)
        if currentIndex != page {
            currentIndex = page
            segmentView.clickPageIndex(page)
        }
    }
    
    // MARK: -
    private func scrollPage(_ index: Int) {
        view.layoutIfNeeded()
        view.setNeedsLayout()
        var rect = scrollView.frame
        rect.origin.x = CGFloat(index) * kScreenWidth
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}

