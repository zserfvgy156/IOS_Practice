//
//  uiimage+extension.swift
//  Practice
//
//  Created by user on 2022/7/15.
//


import UIKit


// MARK: - UIImage 擴充，主要補助各種縮放、旋轉動作
extension UIImage {
    
    /// 縮放照片
    /// - Parameter size: 目的圖片大小
    /// - Returns: 返回相對應尺寸
    func scale(to size: CGSize) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: size))
        let result =  renderer.image { rendederContext in
            self.draw(in: rendederContext.format.bounds)
        }
        
        return result
    }
    
    /// 旋轉照片
    /// - Parameter angle: 角度
    /// - Returns: 旋轉後照片
    func rotate(angle:CGFloat) -> UIImage
    {
        let radians = CGFloat(angle * .pi) / 180.0 as CGFloat
            
        // 設定尺寸
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        // 使用 UIGraphicsImageRenderer 處理
        let renderer = UIGraphicsImageRenderer(size: newSize)
            
        let result = renderer.image { rendederContext in
                
            let context = rendederContext.cgContext
            context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.rotate(by: radians)
            
            draw(in:  CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: size))
        }
            
        return result
    }
}
