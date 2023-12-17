//
//  MFStorageFooterView.swift
//  MJDemo
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MFStorageFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.PFRegular(fontSize: 13)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private func setupViews() {
        addSubview(textView)
    }
    
    private func layoutViewsConstraint() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        //
        //        let height = textView.text.textHeight(font: textView.font!, width: kScreenWidth - 20 - 16) + 30
        //        let textHeight: CGFloat = ceil(height)
        //        
        //        if textViewHeightConstraint != nil {
        //            textViewHeightConstraint.isActive = false
        //        }
        //        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textHeight)
        //        textViewHeightConstraint.isActive = true
        //        textViewHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
    }
    
    public func updateInfo(text: String) {
        textView.text = text
        layoutViewsConstraint()
    }
}
