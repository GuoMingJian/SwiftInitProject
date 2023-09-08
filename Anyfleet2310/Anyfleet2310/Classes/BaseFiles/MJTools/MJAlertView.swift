//
//  MJAlertView.swift
//  AnyTrekForklift
//
//  Created by 郭明健 on 2023/3/1.
//

/*
 使用示例：
 private func showAlert() {
     let content = "Have you parked your forklift in the designated place?"
     let cancelText = "Cancel"
     let confirmText = "Offline"
     let alert = MJAlertView.alertView(content: content, cancelButtonText: cancelText, confirmButtonText: confirmText)
     alert.contentTopSpac = 26
     alert.buttonTopSpac = 27
     alert.contentTextView.font = UIFont.PFMedium(fontSize: 28)
     alert.cancelButton.backgroundColor = UIColor(203, 203, 208)
     alert.cancelButton.setTitleColor(UIColor(101, 117, 145), for: .normal)
     alert.confirmButton.backgroundColor = UIColor.hexColor(color: "FFC600")
     alert.confirmButton.setTitleColor(.black, for: .normal)
     
     alert.show(atView: self.view, cancelButtonBlock: nil) { [weak self] in
         guard let self = self else { return }
     }
 }
 */

import UIKit

class MJAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickBackgroundViewAction))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    public lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.bounces = false
        return textView
    }()
    
    public lazy var horizontalLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()
    
    public lazy var verticalLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()
    
    public lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    public lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(confirmButtonClickAction), for: .touchUpInside)
        return button
    }()
    
    var containerHeightMax: NSLayoutConstraint!
    var contentViewHeightMini: NSLayoutConstraint!
    var superView: UIView!
    
    // MARK: - param
    
    /// 弹窗标题
    public var title: String = "This is the title"
    /// 弹窗内容
    public var content: String = "This is the content"
    /// 取消按钮文本
    public var cancelButtonText: String = "Cancel"
    /// 确认按钮文本
    public var confirmButtonText: String = "Confirm"
    
    /// 弹窗最大高度，超过则文本可滑动。
    public var alertMaxHeight: CGFloat = 400
    /// 弹窗文本最小高度
    public var contentMiniHeight: CGFloat = 50
    /// 弹窗左右间隙
    public var alertLeadingSpac: CGFloat = 35
    /// 标题与弹窗间隙
    public var titleTopSpac: CGFloat = 20
    /// 内容与标题之间间隙
    public var contentTopSpac: CGFloat = 30
    /// 按钮与内容间隙
    public var buttonTopSpac: CGFloat = 20
    /// 按钮与弹窗底部间隙
    public var buttonBottomSpac: CGFloat  = 20
    /// 按钮高度
    public var buttonHeight: CGFloat = 44
    /// 按钮之间间隙
    public var buttonSpac: CGFloat = 20
    /// 按钮与弹窗左右间隙
    public var buttonToAlertSpac: CGFloat = 30
    
    /// 弹窗圆角
    public var alertRadius: CGFloat = 15
    /// 按钮圆角
    public var buttonRadius: CGFloat = 10
    
    /// 是否可以点击背景view
    public var isCanClickBackgroundView: Bool = false
    /// 是否只显示一个按钮，默认显示两个。（当cancel按钮文本为空字符串时只显示confirm按钮）
    public var isShowOneButton: Bool = false
    /// 是否显示水平、垂直分割线，默认：true
    public var isShowLineView: Bool = true
    
    public var cancelBlock: (() -> Void)?
    public var confirmBlock: (() -> Void)?
    
    // MARK: - public
    static func alertView(title: String = "",
                          content: String = "",
                          cancelButtonText: String = "",
                          confirmButtonText: String = "") -> MJAlertView {
        let alert = MJAlertView()
        alert.title = title
        alert.content = content
        alert.cancelButtonText = cancelButtonText
        alert.confirmButtonText = confirmButtonText
        //
        alert.isShowOneButton = (cancelButtonText.count > 0) ? false : true
        return alert
    }
    
    public func show(atView: UIView,
                     cancelButtonBlock: (() -> Void)? = nil,
                     confirmButtonBlock: (() -> Void)? = nil) {
        self.superView = atView
        self.cancelBlock = cancelButtonBlock
        self.confirmBlock = confirmButtonBlock
        //
        setupViews(view: atView)
        setupData()
    }
    
    /// 底部弹窗：拍照、相册、取消
    static func showBottomAlert(sheetOne: String = "Save Photo",
                                sheetOneTextColor: UIColor = .black,
                                sheetTwo: String = "Delete Photo",
                                sheetTwoTextColor: UIColor = .red,
                                cancel: String = "Cancel",
                                sheetOneBlock: (()->Void)?,
                                sheetTwoBlock: (()->Void)?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if sheetOne.count > 0 {
            let takingPictures = UIAlertAction(title: sheetOne, style: .default) {
                action in
                if sheetOneBlock != nil {
                    sheetOneBlock!()
                }
            }
            //takingPictures.setTextColor(sheetOneTextColor)
            alertController.addAction(takingPictures)
        }
        if sheetTwo.count > 0 {
            let localPhoto = UIAlertAction(title: sheetTwo, style: .default) {
                action in
                if sheetTwoBlock != nil {
                    sheetTwoBlock!()
                }
            }
            localPhoto.setTextColor(sheetTwoTextColor)
            alertController.addAction(localPhoto)
        }
        let cancel = UIAlertAction(title: cancel, style: .cancel) {
            action in
        }
        alertController.addAction(cancel)
        //
        DispatchQueue.main.async {
            let currentVC: UIViewController = UIView.topMostController()
            currentVC.present(alertController, animated:true, completion:nil)
        }
    }
    
    // MARK: - private
    private func setupViews(view: UIView) {
        view.addSubview(self)
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentTextView)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        
        containerView.addSubview(horizontalLineView)
        containerView.addSubview(verticalLineView)
        
        horizontalLineView.isHidden = !isShowLineView
        if isShowLineView, !isShowOneButton {
            verticalLineView.isHidden = false
        } else {
            verticalLineView.isHidden = true
        }
        //
        updateLayoutConstraint()
    }
    
    private func updateLayoutConstraint() {
        guard let view = superView else { return }
        
        if containerHeightMax != nil {
            containerHeightMax.isActive = false
        }
        containerHeightMax = containerView.heightAnchor.constraint(lessThanOrEqualToConstant: alertMaxHeight)
        containerHeightMax.priority = UILayoutPriority(999)
        containerHeightMax.isActive = true
        
        // contentTextView
        if contentViewHeightMini != nil {
            contentViewHeightMini.isActive = false
        }
        contentViewHeightMini = contentTextView.heightAnchor.constraint(lessThanOrEqualToConstant: contentMiniHeight)
        contentViewHeightMini.priority = UILayoutPriority(999)
        contentViewHeightMini.isActive = true
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: alertLeadingSpac),
            containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -alertLeadingSpac),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: titleTopSpac),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: alertRadius),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -alertRadius),
            
            contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentTopSpac),
            contentTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -buttonTopSpac),
            
            confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -buttonToAlertSpac),
            confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -buttonBottomSpac),
            confirmButton.heightAnchor.constraint(lessThanOrEqualToConstant: buttonHeight)
        ])
        
        if isShowOneButton {
            cancelButton.isHidden = true
            NSLayoutConstraint.activate([
                confirmButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: buttonToAlertSpac),
            ])
        } else {
            cancelButton.isHidden = false
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(equalTo: confirmButton.topAnchor),
                cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: buttonToAlertSpac),
                cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -buttonSpac),
                cancelButton.heightAnchor.constraint(equalTo: confirmButton.heightAnchor),
                cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor),
            ])
        }
        
        NSLayoutConstraint.activate([
            horizontalLineView.topAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -buttonBottomSpac),
            horizontalLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            horizontalLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalLineView.heightAnchor.constraint(equalToConstant: 1),
            
            verticalLineView.topAnchor.constraint(equalTo: horizontalLineView.topAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 1),
            verticalLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            verticalLineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        //
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentTextView.layoutIfNeeded()
        
        let size = CGSize(width: contentTextView.width, height: CGFloat(MAXFLOAT))
        let contentSize = contentTextView.sizeThatFits(size)
        
        let height = (contentSize.height < contentMiniHeight) ? contentMiniHeight : contentSize.height
        
        // contentTextView
        if contentViewHeightMini != nil {
            contentViewHeightMini.isActive = false
        }
        contentViewHeightMini = contentTextView.heightAnchor.constraint(lessThanOrEqualToConstant: height)
        contentViewHeightMini.priority = UILayoutPriority(999)
        contentViewHeightMini.isActive = true
    }
    
    private func setupData() {
        backgroundView.backgroundColor = UIColor(217, 217, 217, 0.5)
        containerView.setCornerRadius(radius: alertRadius)
        titleLabel.text = title
        contentTextView.text = content
        cancelButton.setTitle(cancelButtonText, for: .normal)
        confirmButton.setTitle(confirmButtonText, for: .normal)
        cancelButton.setCornerRadius(radius: buttonRadius)
        confirmButton.setCornerRadius(radius: buttonRadius)
        if title.count == 0 {
            titleTopSpac = 0
        }
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
    // MARK: - actions
    @objc private func clickBackgroundViewAction() {
        if isCanClickBackgroundView {
            dismiss()
        }
    }
    
    @objc private func cancelButtonClickAction() {
        dismiss()
        if cancelBlock != nil {
            cancelBlock!()
        }
    }
    
    @objc private func confirmButtonClickAction() {
        dismiss()
        if confirmBlock != nil {
            confirmBlock!()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MJAlertView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == containerView || touch.view == contentTextView {
            return false
        } else {
            return true
        }
    }
}
