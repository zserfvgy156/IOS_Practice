//
//  DiscoverContentReviewPhoto.swift
//  Practice
//
//  Created by user on 2022/5/4.
//


import UIKit


protocol DiscoverContentReviewPhotoDelegate: AnyObject
{
    func onPageCountChanged(pageCount: Int)
    func onPageNoChanged(pageNo: Int)
    func onPageClicked()
}


// 預覽圖片
class DiscoverContentReviewPhoto
{
    weak var scrollView: UIScrollView!
    weak var stackView: UIStackView!
    
    weak var delegate: DiscoverContentReviewPhotoDelegate?
    
    var zoomScrollView: PagingZoomScrollView
    var pageImages: [UIImageView] = [UIImageView]()
    
    
    init(scrollView: UIScrollView, stackView: UIStackView) {
        
        self.scrollView = scrollView
        self.stackView = stackView
        self.zoomScrollView = PagingZoomScrollView(scrollView: scrollView)
        
        // 註冊滾動事件
        self.zoomScrollView.delegate = self
    
        // 註冊點擊事件
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onStackViewClicked))
        self.stackView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setup(srcImage: [UIImage]) {
        
        // 清除介面
        self.clear()
        
        // 若資料為空不處理
        if srcImage.count == 0 { return }
        
        // 加入介面 （可以優化成 scroll -> collectionView 提升效能）
        srcImage.forEach { (image) in
            
            // 生成
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            
            self.pageImages.append(imageView)
            
            // 加入介面
            stackView.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
            ])
        }
        
        // 紀錄目前的頁數
        self.zoomScrollView.currentPageNo = 0
        
        //回呼介面數量被改變
        delegate?.onPageCountChanged(pageCount: self.pageImages.count)
        delegate?.onPageNoChanged(pageNo: 1)
    }
    
    func clear() {
        
        if self.pageImages.count == 0 { return }
        
        // 移除圖片
        self.pageImages.forEach { (view) in view.removeFromSuperview() }
        self.pageImages.removeAll()
            
        // 紀錄目前的頁數
        self.zoomScrollView.currentPageNo = -1
    }
    
    @objc func onStackViewClicked() {
        delegate?.onPageClicked()
    }
}


// MARK: - 縮放回呼
extension DiscoverContentReviewPhoto: PagingZoomScrollViewDelegate {
    func onPageNoChanged(index: Int) {
        delegate?.onPageNoChanged(pageNo: (index + 1))
    }
}
