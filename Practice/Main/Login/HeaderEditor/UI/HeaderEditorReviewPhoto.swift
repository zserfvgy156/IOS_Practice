//
//  HeaderEditorReviewPhoto.swift
//  Practice
//
//  Created by user on 2022/7/15.
//


import UIKit
import RxSwift


// MARK: - 預覽圖片
class HeaderEditorReviewPhoto: NSObject {
    
    weak var scrollView: UIScrollView!
    weak var contentImageView: UIImageView!
    
    weak var displayImage: UIImage?
    
    
    var image: UIImage? {
        get {
            return contentImageView?.image
        }
        set {
            guard let image = newValue else { return }
            
            // 設定照片
            self.displayImage = image
            
            // 更新介面
            updateUI()
        }
    }
    
    var centerContentOffset: CGPoint {
        
        // 顯示的尺寸
        let displayWidth = scrollView.frame.size.width
        let displayHeight = scrollView.frame.size.height
        
        // 位移
        let offsetX = ((scrollView.contentSize.width - displayWidth) * 0.5)
        let offsetY = ((scrollView.contentSize.height - displayHeight) * 0.5)
        
        return .init(x: offsetX, y: offsetY)
    }
    
    
    init(scrollView: UIScrollView, contentImageView: UIImageView) {
        
        self.scrollView = scrollView
        self.contentImageView = contentImageView
        
        super.init()
        
        scrollView.delegate = self
    }
    
    // 更新介面
    func updateUI() {
        
        guard let image = self.displayImage else { return }
        
        // 顯示的尺寸
        let displayWidth = scrollView.frame.size.width
        let displayHeight = scrollView.frame.size.height
        
        // 計算要縮放的大小
        let size = image.size
        
        let widthRatio  = displayWidth  / size.width
        let heightRatio = displayHeight / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        } else {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }
        
        let newImage = image.scale(to: newSize)
       
        contentImageView.image = newImage
        contentImageView.frame.size = newImage.size
        scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.contentSize = newImage.size
    }
    
    // 顯示頁面中間
    func toContentCenter() {
        
        // 位移
        let offsetPoint = self.centerContentOffset
        
        // 設定
        scrollView.setContentOffset(offsetPoint, animated: false)
    }
    
    
    /// 產生圓形圖片
    /// - Parameters:
    ///   - srcSize: 來源預覽的圓型尺寸
    ///   - dstSize: 要輸出的目標尺寸
    /// - Returns: 輸出相對應的圓形圖片
    func createCircularAndCropImage(srcSize: CGSize, dstSize: CGSize) -> UIImage? {
    
        guard let image = self.contentImageView.image else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: dstSize.width, height: dstSize.height)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let result = renderer.image { rendederContext in
            
            let context = rendederContext.cgContext
            
            // 繪製要顯示的圈圈
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dstSize.width, height: dstSize.height))
            context.addPath(circlePath.cgPath)
            context.clip()
            
            // MARK: 計算目前偏移量
            // 目前縮放大小
            let zoomScale = scrollView.zoomScale
            
            // 原本的尺寸與輸出的比例
            let scaleFactorX = dstSize.width / srcSize.width
            let scaleFactorY = dstSize.height / srcSize.height
            
            // 圖片縮放率
            let width = image.size.width * scaleFactorX * zoomScale
            let height = image.size.height * scaleFactorY * zoomScale
            
            // 位移的位置
            let contentOffsetX = (scrollView.contentOffset.x < 0) ? 0 : (scrollView.contentOffset.x * scaleFactorX * (-1))
            let contentOffsetY = (scrollView.contentOffset.y < 0) ? 0 : (scrollView.contentOffset.y * scaleFactorY * (-1))
            
            // 繪畫圖片
            let rect = CGRect(x: contentOffsetX, y: contentOffsetY, width: width, height: height)
            image.draw(in: rect)
        }
        
        return result
    }
}


extension HeaderEditorReviewPhoto {
    
    /// 旋轉圖片
    /// - Parameter angle: 角度
    func rotate(angle: CGFloat) {
        
        guard let image = self.contentImageView.image else { return }
        
        self.image = image.rotate(angle: angle)
        toContentCenter()
    }
    

    /// 產生要旋轉的 rx 鍵聽動畫
    /// - Parameters:
    ///   - angle: 角度
    ///   - duration: 動畫間隔
    /// - Returns: Observable<Void>
    func rotateAnimation(angle: CGFloat, duration: TimeInterval) -> Observable<Void> {
        return .create { [weak self] (observer) -> Disposable in

            UIView.animate(withDuration: duration, animations: {
                
                // 先旋轉至目的角度，然後再重繪旋轉後圖片，再取消動畫。
                var transform = CGAffineTransform.identity
                transform = transform.rotated(by: CGFloat(angle * .pi / 180) )

                self?.scrollView.transform = transform
                self?.scrollView.zoomScale = 1
                self?.scrollView.contentOffset = self?.centerContentOffset ?? .zero
            
            }, completion: { _ in
            
                // 旋轉 90 度
                self?.rotate(angle: angle)
                
                // 動畫結束
                self?.scrollView.transform = .identity
                
                // 完成
                observer.onNext(())
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}


// ReviewPhoto 的縮放委派註冊
extension HeaderEditorReviewPhoto: UIScrollViewDelegate {
    
    // 覆寫滾輪
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImageView
    }
}
