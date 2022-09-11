//
//  HeaderEditorCircleMask.swift
//  Practice
//
//  Created by user on 2022/7/15.
//


import UIKit


// MARK: - 設置圓形遮罩
class HeaderEditorCircleMask {
    
    weak var view: UIView!
    
    var maskColor: UIColor
    var maskAlpha: CGFloat
    
    
    // 遮罩尺寸
    var circleSize: CGSize {
        return .init(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    
    init(view: UIView, maskColor: UIColor = .black, maskAlpha: CGFloat = 0.3) {
        self.view = view
        self.maskColor = maskColor
        self.maskAlpha = maskAlpha
    }
    
    func updateUI() {
        
        // 移除自類別
        removeSublayer()
        
        // 顯示的尺寸
        let displayWidth = view.frame.size.width
        let displayHeight = view.frame.size.height
        
        // MARK: 繪製黑圈
        
        // 中間透明圓圈
        let circleRect = CGRect(x: 0, y: displayHeight / 2 - displayWidth / 2, width: displayWidth, height: displayWidth)
        let circlePath = UIBezierPath(ovalIn: circleRect)
        circlePath.usesEvenOddFillRule = true
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        
        // 外層黑色圓圈
        let maskRect = CGRect(x: 0 , y: 0, width: displayWidth, height: displayHeight)
        let maskPath = UIBezierPath(roundedRect: maskRect, cornerRadius: 0)
        maskPath.append(circlePath)
        maskPath.usesEvenOddFillRule = true

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = .evenOdd;
        maskLayer.fillColor = maskColor.withAlphaComponent(maskAlpha).cgColor
        
        // 加入介面
        view.layer.addSublayer(maskLayer)
    }
    
    private func removeSublayer() {
        if let layerArray = self.view.layer.sublayers {
            for layer in layerArray {
                layer.removeFromSuperlayer()
            }
        }
    }
}

