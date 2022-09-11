//
//  ZoomScrollView.swift
//  Practice
//
//  Created by user on 2022/5/6.
//


import UIKit


protocol PagingZoomScrollViewDelegate: AnyObject
{
    func onPageNoChanged(index: Int)
}


// 滾輪相關事件處理
class PagingZoomScrollView: NSObject {
    
    weak var scrollView: UIScrollView!
    
    weak var delegate: PagingZoomScrollViewDelegate?
    
    var currentPageNo: Int = -1
    
    
    init(scrollView: UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
        self.scrollView.delegate = self
    }
}


// MARK: - UIScrollViewDelegate 回呼
extension PagingZoomScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for pageView in scrollView.subviews {
            if pageView.isKind(of: UIView.self) {
                return pageView
            }
        }
        return nil
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.currentPageNo == -1 { return }

        if scrollView.zoomScale > 1 {        // 縮放時 content， isPagingEnabled 會有問題。（放大時暫時關閉）
            scrollView.isPagingEnabled = false
        }
        else if scrollView.zoomScale < 1 {   // 縮小後，強制鎖住最小縮放值。
            scrollView.zoomScale = 1
            scrollView.contentOffset.x = CGFloat(self.currentPageNo) * scrollView.frame.width
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPageNo == -1 { return }

        // 當放大時，鎖住相片可以移動的最大最小位置。
        if scrollView.zoomScale > 1 {
            let zoomScale = scrollView.zoomScale
            let startPosX = CGFloat(self.currentPageNo) * scrollView.frame.width * CGFloat(zoomScale)
            let endPosX = startPosX + (scrollView.frame.width * CGFloat(zoomScale - 1))

            if scrollView.contentOffset.x < startPosX {
                scrollView.contentOffset.x = startPosX
            }
            else if scrollView.contentOffset.x > endPosX {
                scrollView.contentOffset.x = endPosX
            }
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 縮放時 content，isPagingEnabled 會有問題。（回復原本尺寸後調整回來）
        if scrollView.zoomScale == 1 {
            scrollView.contentOffset.x = CGFloat(self.currentPageNo) * scrollView.frame.width
            scrollView.isPagingEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if self.currentPageNo == -1 { return }

        // 切換頁面顯示
        if scrollView.zoomScale == 1 {
            let pageNo = Int((scrollView.contentOffset.x / scrollView.zoomScale) / scrollView.frame.width)

            self.currentPageNo = pageNo
            delegate?.onPageNoChanged(index: pageNo)
        }
    }
}
