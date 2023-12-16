//
//  MFBaseView.swift
//  KGPro
//
//  Created by 郭明健 on 2023/12/16.
//

import UIKit

class MFBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}
