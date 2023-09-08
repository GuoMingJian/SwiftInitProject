//
//  BaseCollectionView.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/7/6.
//

import UIKit
import EmptyDataSet_Swift

class BaseCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    /// 无数据模式
    public var isNoDataMode: Bool = false {
        didSet {
            if isNoDataMode {
                setupNoData()
            }
        }
    }
    
    public func setupNoData() {
        // https://github.com/Xiaoye220/EmptyDataSet-Swift
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
    }
    
}

extension BaseCollectionView: EmptyDataSetSource, EmptyDataSetDelegate {
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
