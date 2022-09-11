//
//  DiscoverContentReviewPhotoView.swift
//  Practice
//
//  Created by user on 2022/5/3.
//

import UIKit


class DiscoverContentReviewPhotoView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var customNavigationBar: DiscoverContentReviewPhotoNavigationBar?
    var reviewPhoto: DiscoverContentReviewPhoto?
    
    var isAutoConstraintEqualToSuperView: Bool = false
    
    
    convenience init() {
        self.init(frame: .zero)
        isAutoConstraintEqualToSuperView = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        
        // 生成場景檔
        let viewFromXib = Bundle.main.loadNibNamed("DiscoverContentReviewPhotoView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
                
        // 標題
        self.customNavigationBar = DiscoverContentReviewPhotoNavigationBar(navigationBar: navigationBar)
        self.customNavigationBar?.delegate = self
        
        // 預覽圖片
        self.reviewPhoto = DiscoverContentReviewPhoto(scrollView: scrollView, stackView: stackView)
        self.reviewPhoto?.delegate = self
        
        // 加入主場景
        addSubview(viewFromXib)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // 吸附在父類別上
        if self.isAutoConstraintEqualToSuperView {
            
            guard let superView = self.superview else { return }
            
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                self.leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor),
                self.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor),
                self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
            ])
            
            self.isAutoConstraintEqualToSuperView = false
        }
    }
    
    
    func setupPage(srcImage: [UIImage]) {
        self.reviewPhoto?.setup(srcImage: srcImage)
    }
}


// MARK: - 標題回呼
extension DiscoverContentReviewPhotoView: DiscoverContentReviewPhotoNavigationBarDelegate
{
    func onNavigationBarBtnBackClick() {
        self.removeFromSuperview()
    }
}


// MARK: - 預覽圖片回呼
extension DiscoverContentReviewPhotoView: DiscoverContentReviewPhotoDelegate
{
    func onPageNoChanged(pageNo: Int) {
        self.customNavigationBar?.pageNo = pageNo
    }
    
    func onPageCountChanged(pageCount: Int) {
        self.customNavigationBar?.pageCount = pageCount
    }
    
    func onPageClicked() {
        guard let isHidden: Bool = self.customNavigationBar?.isHidden else { return }
        self.customNavigationBar?.isHidden = !isHidden
    }
}


