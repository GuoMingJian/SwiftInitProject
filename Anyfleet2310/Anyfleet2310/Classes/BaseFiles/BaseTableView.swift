//
//  BaseTableView.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/7/5.
//

import UIKit
import MJRefresh
import EmptyDataSet_Swift

class BaseTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    /// 是否支持下拉刷新，上拉加载更多
    public var isPullDownRefresh: Bool = false {
        didSet {
            if isPullDownRefresh {
                setupMJRefresh()
            }
        }
    }
    
    /// 无数据模式
    public var isNoDataMode: Bool = false {
        didSet {
            if isNoDataMode {
                setupNoData()
            }
        }
    }
    
    public var headerRefreshBlock: (() -> Void)?
    public var footerRefreshBlock: (() -> Void)?
    
    // MARK: -
    private let mjHeader = MJRefreshNormalHeader()
    private let mjFooter = MJRefreshAutoNormalFooter()
    // MARK: -
    public func setupMJRefresh() {
        // refreshing
        mjHeader.setRefreshingTarget(self, refreshingAction: #selector(mjHeaderRefresh))
        mjHeader.setTitle(localizedString("pullDownRefresh"), for: .idle)
        mjHeader.setTitle(localizedString("releaseUpdate"), for: .pulling)
        mjHeader.setTitle(localizedString("refreshing"), for: .refreshing)
        self.mj_header = mjHeader
        // load more
        mjFooter.setRefreshingTarget(self, refreshingAction: #selector(mjFooterRefresh))
        self.mj_footer = mjFooter
    }
    
    public func setupNoData() {
        // https://github.com/Xiaoye220/EmptyDataSet-Swift
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
    }
    
    @objc public func mjHeaderRefresh() {
        if headerRefreshBlock != nil {
            headerRefreshBlock!()
        }
    }
    
    @objc public func mjFooterRefresh() {
        if footerRefreshBlock != nil {
            footerRefreshBlock!()
        }
    }
}

extension BaseTableView: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let noDataImage: UIImage = UIImage(named: "noData")!
        return noDataImage
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: localizedString("noData"), attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
        return attributedString
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
