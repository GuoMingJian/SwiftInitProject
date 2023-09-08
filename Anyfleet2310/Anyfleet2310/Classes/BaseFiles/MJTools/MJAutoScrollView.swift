//
//  MJAutoScrollView.swift
//  AnyTrekForklift
//
//  Created by 郭明健 on 2023/3/1.
//

/*
 示例：
 /*  用作网络图片展示 */
 private let imageUrls = [
     "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg",
     "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg" ,
     "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg",
     "http://i2.hdslb.com/bfs/archive/41f5d8b1bb5c6a03e6740ab342c9461786d45c0a.jpg"
 ]
 
 /*  pageControl未选中图片 */
 private let dotImage = UIImage(named: "dot")
 
 /*  pageControl选中图片 */
 private let dotSelectImage = UIImage(named: "dottest")
 
 private lazy var containerView: UIView = {
     let view = UIView()
     view.translatesAutoresizingMaskIntoConstraints = false
     return view
 }()
 
 private lazy var containerView2: UIView = {
     let view = UIView()
     view.translatesAutoresizingMaskIntoConstraints = false
     return view
 }()
 
 /*  左右轮播 加载网络图片 */
 private var autoScrollView: MJAutoScrollView!
 
 /*  文字上下轮播两行 */
 private var autoScrollView2: MJAutoScrollView!
 
 override func viewDidLoad() {
     super.viewDidLoad()
     
     setupViews()
     setupAutoScrollView()
     setupAutoScrollView2()
 }
 
 private func setupViews() {
     view.addSubview(containerView)
     view.addSubview(containerView2)
     
     NSLayoutConstraint.activate([
         containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
         containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         containerView.heightAnchor.constraint(equalToConstant: 220),
         
         containerView2.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 50),
         containerView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         containerView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         containerView2.heightAnchor.constraint(equalToConstant: 60)
     ])
     
     containerView.layoutIfNeeded()
     autoScrollView = MJAutoScrollView(frame: containerView.bounds)
     containerView.addSubview(autoScrollView)
     
     containerView2.layoutIfNeeded()
     autoScrollView2 = MJAutoScrollView(frame: containerView2.bounds)
     containerView2.addSubview(autoScrollView2)
 }
 
 private func setupAutoScrollView() {
     autoScrollView.layer.borderWidth = 1
     autoScrollView.layer.borderColor = UIColor.orange.cgColor
     //
     autoScrollView.timeInterval = 1.5
     autoScrollView.images = imageUrls
     autoScrollView.imageHandle = {(imageView, imageName) in
         imageView.kf.setImage(with: URL(string: imageName))
     }
     // 是否自动轮播 默认true
     autoScrollView.isAutoScroll = true
//        autoScrollView.scrollDirection = .vertical
     autoScrollView.didSelectItemHandle = {
         print("autoScrollView 点击了第 \($0) 个索引")
     }
     autoScrollView.pageControlDidSelectIndexHandle = { index in
         print("autoScrollView pageControl点击了第 \(index) 个索引")
     }
     let layout = MJDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
     layout.dotMargin = 14
     autoScrollView.dotLayout = layout
 }
 
 private func setupAutoScrollView2() {
     autoScrollView2.layer.borderWidth = 1
     autoScrollView2.layer.borderColor = UIColor.orange.cgColor
     //
     autoScrollView2.timeInterval = 1.5
     autoScrollView2.scrollDirection = .vertical
     
     // 滚动手势禁用（文字轮播较实用）
     autoScrollView2.isDisableScrollGesture = true
     
     autoScrollView2.autoViewHandle = {
         return self.customAutoView2()
     }
 }
 
 private func customAutoView2() -> [UIView] {
     var views = [UIView]()
     let labelText = ["大家一起起来嗨！", "今天天气不错哦！", "厉害了我的哥！"]
     for index in 0 ..< labelText.count {
         let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
         views.append(bottomView)
         
         let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: 180, height: 20))
         label1.textColor = UIColor.white
         label1.backgroundColor = .lightGray
         label1.text = labelText[index]
         bottomView.addSubview(label1)
         
         let label2 = UILabel(frame: CGRect(x: 10, y: 30, width: view.bounds.width - 20, height: 20))
         label2.textColor = UIColor.white
         label2.backgroundColor = .lightGray
         label2.text = "不错哦！哈哈哈哈"
         bottomView.addSubview(label2)
     }
     return views
 }
 */

import UIKit

fileprivate class MJFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    convenience init(itemSize: CGSize) {
        self.init()
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        self.itemSize = itemSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class MJCollectionView: UICollectionView {
    override init(frame: CGRect,
                  collectionViewLayout
                  layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect,
                     collectionViewLayout layout: MJFlowLayout,
                     delegate: UICollectionViewDelegate?,
                     dataSource: UICollectionViewDataSource?) {
        self.init(frame: frame, collectionViewLayout: layout)
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    fileprivate func scrollToItem(item: Int,
                                  section: Int,
                                  at: UICollectionView.ScrollPosition) {
        scrollToItem(at: IndexPath(item: item, section: section), at: at, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notification.Name {
    public struct MJTask {
        static let BecomeActive = Notification.Name("UIApplicationDidBecomeActiveNotification")
        static let Background = Notification.Name("UIApplicationDidEnterBackgroundNotification")
    }
}

fileprivate class MJCollectionViewCell: UICollectionViewCell {
    var subView: UIView? {
        didSet {
            guard let subView = subView else { return }
            imageView.isHidden = true
            contentView.addSubview(subView)
        }
    }
    
    var image: String? {
        didSet {
            guard let image = image else { return }
            imageView.image = UIImage(named: image)
        }
    }
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private static let reusedCellId = "MJCollectionViewCellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    static func itemViewWithCollectionView(_ collectionView: UICollectionView,
                                           _ indexPath: IndexPath) -> MJCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! MJCollectionViewCell
        return cell
    }
    
    static func registerCellWithCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(MJCollectionViewCell.self, forCellWithReuseIdentifier: reusedCellId)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 轮播类型视图是自定义 或者 默认 以及pageControl是系统样式还是自定义图片
public enum MJAutoScrollViewType {
    case `default`//默认
    case  custom //自定义
}

//MARK: dot在轮播图的位置 中心 左侧 右侧
public enum MJDotDirection {
    case `default`//默认
    case left // 左侧
    case right// 右侧
}

/*  自定义view的数组回调  */
public typealias AutoViewHandle = () -> [UIView]
/*  图片赋值回调  */
public typealias SetImageHandle = (UIImageView, String) -> Void
/*  点击事件的回调  */
public typealias DidSelectItemHandle = (Int) -> Void
/*  自动滚动到当前索引事件的回调  */
public typealias AutoDidSelectItemHandle = (Int) -> Void
/*  PageControl点击事件的回调  */
public typealias PageControlDidSelectIndexHandle = (Int) -> ()


public class MJAutoScrollView: UIView {
    /* -------------  公有方法  ---------------- */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    public convenience init(frame: CGRect,
                            dotLayout: MJDotLayout) {
        self.init(frame: frame)
        mjPageControl.dotLayout = dotLayout
        setupDotDiretion()
    }
    
    /*  图片赋值回调属性  */
    public var imageHandle: SetImageHandle?
    /*  点击事件的回调属性  */
    public var didSelectItemHandle: DidSelectItemHandle?
    /*  自动滚动到当前索引事件的属性  */
    public var autoDidSelectItemHandle: AutoDidSelectItemHandle?
    /*  PageControl点击事件的回调属性  */
    public var pageControlDidSelectIndexHandle: PageControlDidSelectIndexHandle?
    
    /* 设置自定义视图 */
    public var autoViewHandle: AutoViewHandle? {
        didSet {
            guard let autoViewHandle = autoViewHandle else {
                autoType = .default
                return
            }
            mjPageControl.removeFromSuperview()
            autoType = .custom
            setupAutoViewHandle(autoViewHandle: autoViewHandle)
        }
    }
    
    /*如果是默认模式`default`  直接传入images数组即可*/
    public var images: [String]? {
        didSet {
            setupImages(images)
        }
    }
    
    /* 设置滚动时间间隔 */
    public var timeInterval: TimeInterval = 2.0 {
        didSet {
            setupTimer()
        }
    }
    
    /* 是否自动轮播 */
    public var isAutoScroll: Bool = true {
        didSet {
            setupTimer()
        }
    }
    
    /* 设置轮播图的方向 */
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
        }
    }
    
    /* 设置pageControl的属性 */
    public var dotLayout: MJDotLayout = MJDotLayout() {
        didSet {
            mjPageControl.dotLayout = dotLayout
            setupDotDiretion()
        }
    }
    
    /* dot在轮播图的位置 中心 左侧 右侧 */
    public var dotDirection: MJDotDirection? {
        didSet {
            guard let dotDirection = dotDirection else { return }
            mjPageControl.dotDirection = dotDirection
        }
    }
    
    
    /* 是否隐藏pageControl，显示的情况下需要设置dotLayout 默认不设置也为隐藏 */
    public var isHiddenPageControl: Bool = false {
        didSet {
            if isHiddenPageControl {
                mjPageControl.isHidden = true
            }
        }
    }
    
    /* dot在轮播图的位置 左侧 或 右侧时，距离最屏幕最左边或最最右边的距离 */
    public var adjustValue: CGFloat = 0.0 {
        didSet {
            mjPageControl.adjustValue = adjustValue
        }
    }
    
    /* pageControl高度调整从而改变pageControl位置 */
    public var pageControlHeight: CGFloat = 20.0 {
        didSet {
            mjPageControl.frame.origin.y = bounds.height - pageControlHeight
            mjPageControl.frame.size.height = pageControlHeight
            mjPageControl.mjPageControlHeight = pageControlHeight
        }
    }
    
    /* 滚动手势禁用（文字轮播较实用）*/
    public var isDisableScrollGesture: Bool = false {
        didSet {
            guard let gestureRecognizers = collectionView.gestureRecognizers else { return }
            if isDisableScrollGesture {
                collectionView.canCancelContentTouches = false
                for gestrue in gestureRecognizers  {
                    if gestrue.isKind(of: UIPanGestureRecognizer.self) {
                        collectionView.removeGestureRecognizer(gestrue)
                    }
                }
            }
        }
    }
    
    /* -------------  以下私有方法  ---------------- */
    private var contentViews: [UIView] = []
    private var currentPageIndex: Int = 0
    private var timer: Timer?
    private var totalsCount: Int = 0
    private var autoType: MJAutoScrollViewType = .default
    
    private lazy var layout: MJFlowLayout = {
        let layout = MJFlowLayout(itemSize: CGSize(width: bounds.width, height: bounds.height))
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var mjPageControl: MJPageControlView = {
        let mjPageControl = MJPageControlView(frame: CGRect(x: 0, y: bounds.size.height - 20, width: bounds.size.width, height: 20))
        return mjPageControl
    }()
    
    private lazy var collectionView: MJCollectionView = {
        let collectionView = MJCollectionView(frame: bounds, collectionViewLayout: layout, delegate: self, dataSource: self)
        return collectionView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        destroyTimrer()
    }
}

extension MJAutoScrollView {
    
    private func setupImages(_ images: [String]?)  {
        guard let images = images else { return }
        if autoType == .custom { return }
        images.count == 1 ? destroyTimrer() : setupTimer()
        totalsCount = images.count * 1024
        collectionView.reloadData()
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        } else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        setupPageControl()
    }
    
    private func setupAutoViewHandle(autoViewHandle: AutoViewHandle?) {
        guard let autoViewHandle = autoViewHandle else { return }
        if autoType == .default { return }
        contentViews.removeAll()
        contentViews = autoViewHandle()
        contentViews.count == 1 ? destroyTimrer() : setupTimer()
        totalsCount = contentViews.count * 1024
        collectionView.reloadData()
        if scrollDirection == .vertical {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .top)
        } else {
            collectionView.scrollToItem(item: totalsCount / 2, section: 0, at: .left)
        }
        setupPageControl()
    }
    
    private func setupPageControl() {
        let numberOfPages = autoType == .default ? (images?.count ?? 0) : contentViews.count
        numberOfPages == 1 ? (mjPageControl.isHidden = true) : (mjPageControl.isHidden = false)
        mjPageControl.numberOfPages = numberOfPages
        mjPageControl.currentDot = 0
        setupDotDiretion()
    }
    
    private func setupDotDiretion() {
        mjPageControl.dotDirection = dotDirection ?? .default
    }
}

extension MJAutoScrollView {
    private func setupSubViews() {
        MJCollectionViewCell.registerCellWithCollectionView(collectionView)
        addSubview(collectionView)
        addSubview(mjPageControl)
        registerNotification()
        setupTimer()
        setupPageControlDidSelect()
    }
    
    private func setupPageControlDidSelect() {
        mjPageControl.didSelectIndexHandle = {[weak self] index in
            guard let self = self else { return }
            let diffIndex = index - self.currentIndex() % ( self.autoType == .default ? (self.images?.count ?? 1) : self.contentViews.count)
            if self.scrollDirection == .vertical {
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex() + diffIndex, section: 0), at: .top, animated: true)
            } else {
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex() + diffIndex, section: 0), at: .left, animated: true)
            }
            self.pageControlDidSelectIndexHandle?(index)
        }
    }
    
    private func registerNotification() {
        let noticenter = NotificationCenter.default
        noticenter.addObserver(self, selector: #selector(registerNoti(_:)), name: Notification.Name.MJTask.BecomeActive, object: nil)
        noticenter.addObserver(self, selector: #selector(registerNoti(_:)), name: Notification.Name.MJTask.Background, object: nil)
    }
    
    @objc private func registerNoti(_ notification: Notification) {
        if notification.name == Notification.Name.MJTask.BecomeActive {
            timer?.restart(timeInterval)
        } else {
            timer?.pause()
        }
    }
}

extension MJAutoScrollView {
    private func setupTimer() {
        destroyTimrer()
        if !isAutoScroll {
            return
        }
        timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(timerUpdate(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func destroyTimrer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerUpdate(_ timer: Timer)  {
        if scrollDirection == .horizontal {
            let point = CGPoint(x: CGFloat(currentPageIndex + 1) * bounds.width, y: 0)
            collectionView.setContentOffset(point, animated: true)
        } else {
            let point = CGPoint(x: 0, y: CGFloat(currentPageIndex + 1) * bounds.height)
            collectionView.setContentOffset(point, animated: true)
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            destroyTimrer()
        }
    }
}

extension Timer {
    func pause() {
        fireDate = Date.distantFuture
    }
    
    func restart(_ timeInterval: TimeInterval) {
        fireDate = Date() + timeInterval
    }
}

extension MJAutoScrollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MJCollectionViewCell.itemViewWithCollectionView(collectionView, indexPath)
        if autoType == .default {
            guard let images = images else { return cell }
            imageHandle?(cell.imageView, images[indexPath.item % (images.count)])
        } else {
            for subView in cell.contentView.subviews { subView.removeFromSuperview() }
            cell.subView = contentViews[indexPath.item % contentViews.count]
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if autoType == .default {
            guard let images = images else { return }
            didSelectItemHandle?(indexPath.item % (images.count))
        } else {
            didSelectItemHandle?(indexPath.item % contentViews.count)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = currentIndex()
        if currentPageIndex != index {
            let realIndex = realItemIndex(index)
            mjPageControl.currentDot = realIndex
            autoDidSelectItemHandle?(realIndex)
        }
        currentPageIndex = index
    }
    
    private func realItemIndex(_ targetIndex: Int) -> Int {
        let contentCount = (autoType == .default ? (images?.count ?? 1) : contentViews.count)
        return targetIndex % contentCount
    }
    
    private func currentIndex() -> Int {
        if layout.itemSize.width == 0 || layout.itemSize.height == 0 {
            return 0
        }
        var index = 0
        if scrollDirection == .horizontal {
            index = Int((collectionView.contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width)
        } else {
            index = Int((collectionView.contentOffset.y + layout.itemSize.height * 0.5) / layout.itemSize.height)
        }
        return max(0, index)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.pause()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.restart(timeInterval)
    }
    
    private func item(_ scrollView: UIScrollView) -> IndexPath? {
        return collectionView.indexPathForItem(at: scrollView.contentOffset)
    }
}

public let isPostDotSize: CGFloat = 14.999099

public class MJDotLayout: NSObject {
    /* dot单独的一个的宽度 */
    public var dotWidth: CGFloat = isPostDotSize
    /* dot单独的一个的高度 */
    public var dotHeight: CGFloat = isPostDotSize
    /* dot之间的间距 */
    public var dotMargin: CGFloat = 15.0
    /* dot未选中的图片 */
    public var dotImage: UIImage?
    /* dot选中后的图片 */
    public var dotSelectImage: UIImage?
    /* dot未选中的颜色 */
    public var dotColor: UIColor = UIColor.clear
    /* dot选中的后颜色 */
    public var dotSelectColor: UIColor = UIColor.clear
    /* custom为默认是自定义 ， 想使用类似系统样式传入default */
    public var dotType: MJAutoScrollViewType = .custom
    /* 滚动过程是否放大当前dot */
    public var isScale: Bool = true
    /* 滚动过程dot放大倍率 */
    public var scaleXY: CGFloat = 1.4
    
    public override init() { super.init() }
    
    public convenience init(dotWidth: CGFloat = 14.999099,
                            dotHeight: CGFloat = 14.999099,
                            dotMargin: CGFloat = 15.0,
                            dotImage: UIImage? = nil,
                            dotSelectImage: UIImage? = nil,
                            dotColor: UIColor = UIColor.clear,
                            dotSelectColor: UIColor = UIColor.clear,
                            dotType: MJAutoScrollViewType = .custom,
                            isScale: Bool = true,
                            scaleXY: CGFloat = 1.4) {
        self.init()
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
        self.dotMargin = dotMargin
        self.dotImage = dotImage
        self.dotSelectImage = dotSelectImage
        self.dotColor = dotColor
        self.dotSelectColor = dotSelectColor
        self.dotType = dotType
        self.isScale = isScale
        self.scaleXY = scaleXY
    }
}

fileprivate class MJPageControlView: UIView {
    fileprivate var didSelectIndexHandle: PageControlDidSelectIndexHandle?
    
    fileprivate var dotDirection: MJDotDirection = .default {
        didSet {
            switch dotDirection {
            case .left:
                frame.origin.x = adjustValue
                break
            case .right:
                let parentViewW = self.superview?.bounds.width ?? UIScreen.main.bounds.width
                frame.origin.x = parentViewW - totalWidth - adjustValue
                break
            default:
                let parentViewW = self.superview?.bounds.width ?? UIScreen.main.bounds.width
                frame.origin.x = (parentViewW - totalWidth) / 2.0
            }
        }
    }
    
    fileprivate var adjustValue: CGFloat = 0.0 {
        didSet {
            setupSubViews()
        }
    }
    
    fileprivate var mjPageControlHeight: CGFloat = 20.0 {
        didSet {
            setupSubViews()
        }
    }
    
    private var totalWidth: CGFloat = 0
    
    fileprivate var numberOfPages: Int = 0 {
        didSet {
            setupSubViews()
        }
    }
    
    fileprivate var currentDot: Int = 0 {
        willSet {
            guard newValue != currentDot else { return }
            dissmissAnimation(currentIndex: currentDot, isScale: dotLayout.isScale)
            showAnimation(willIndex: newValue, isScale: dotLayout.isScale)
        }
    }
    
    fileprivate var dotLayout: MJDotLayout = MJDotLayout() {
        didSet {
            setupSubViews()
        }
    }
    
    fileprivate convenience init(frame: CGRect, layout: MJDotLayout) {
        self.init(frame: frame)
        setupSubViews()
    }
    
    private var dotViews: [UIImageView] = []
    
    private func setupSubViews() {
        resetAllSubViews()
        layoutSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MJPageControlView {
    private func layoutSubViews() {
        totalWidth = 0.0
        for index in 0 ..< numberOfPages {
            let dotView = UIImageView()
            autoSizeImage(dotView: dotView, index: index)
            if index == numberOfPages - 1 {
                totalWidth = dotView.frame.origin.x + dotView.frame.size.width
            }
            dotView.tag = index + 200
            createGesture(dotView: dotView)
            addSubview(dotView)
            dotViews.append(dotView)
            bounds.size.width = totalWidth
        }
    }
    
    private func resetAllSubViews() {
        for view in subviews { view.removeFromSuperview() }
        dotViews.removeAll()
    }
}

extension MJPageControlView {
    private func autoSizeImage(dotView: UIImageView,
                               index: Int) {
        if index == 0 {
            dotView.backgroundColor = dotLayout.dotSelectColor
            dotView.image = dotLayout.dotSelectImage
            dotImage(dotLayout.dotSelectImage, dotView: dotView, index: index)
        } else {
            dotView.backgroundColor = dotLayout.dotColor
            dotView.image = dotLayout.dotImage
            dotImage(dotLayout.dotImage, dotView: dotView, index: index)
        }
    }
    
    private func dotImage(_ dotImage: UIImage?,
                          dotView: UIImageView,
                          index: Int) {
        if dotLayout.dotType == .default {
            dotView.frame = CGRect(x: (dotLayout.dotWidth + dotLayout.dotMargin) * CGFloat(index), y: (bounds.height - dotLayout.dotWidth) / 2.0, width: dotLayout.dotWidth, height: dotLayout.dotWidth)
            dotView.layer.cornerRadius = dotLayout.dotWidth / 2.0
            dotView.layer.masksToBounds = true
            dotView.clipsToBounds = true
            return
        }
        var imageW = dotImage?.size.width ?? dotLayout.dotWidth
        var imageH = dotImage?.size.height ?? dotLayout.dotHeight
        if dotLayout.dotWidth != isPostDotSize {
            imageW = dotLayout.dotWidth
        }
        if dotLayout.dotHeight != isPostDotSize {
            imageH = dotLayout.dotHeight
        }
        dotView.frame = CGRect(x: (imageW + dotLayout.dotMargin) * CGFloat(index), y: (bounds.height - imageH) / 2.0, width: imageW, height: imageH)
    }
    
    private func createGesture(dotView: UIImageView) {
        dotView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        dotView.addGestureRecognizer(tap)
    }
    
    @objc private func tapGesture(_ tap: UITapGestureRecognizer) {
        guard let dotView = tap.view else { return }
        let index = dotView.tag - 200
        didSelectIndexHandle?(index)
    }
    
    private func showAnimation(willIndex: Int,
                               isScale: Bool) {
        let dotView = self.dotViews[willIndex]
        if isScale {
            UIView.animate(withDuration: 0.34 * 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -24, options: [.curveEaseInOut, .curveLinear], animations: {
                dotView.backgroundColor = self.dotLayout.dotSelectColor
                dotView.image = self.dotLayout.dotSelectImage
                dotView.transform = CGAffineTransform(scaleX: self.dotLayout.scaleXY, y: self.dotLayout.scaleXY)
            }) { (_) in }
        } else {
            dotView.backgroundColor = self.dotLayout.dotSelectColor
            dotView.image = self.dotLayout.dotSelectImage
        }
    }
    
    private func dissmissAnimation(currentIndex: Int,
                                   isScale: Bool) {
        let dotView = self.dotViews[currentIndex]
        if isScale {
            UIView.animate(withDuration: 0.5, animations: {
                dotView.backgroundColor = self.dotLayout.dotColor
                dotView.image = self.dotLayout.dotImage
                dotView.transform = CGAffineTransform.identity
            })
        } else {
            dotView.backgroundColor = self.dotLayout.dotColor
            dotView.image = self.dotLayout.dotImage
        }
    }
}
