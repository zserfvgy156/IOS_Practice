//
//  CircleImageView.swift
//  Practice
//
//  Created by user on 2022/7/11.
//


import UIKit


@IBDesignable
class CircleImageView: UIImageView {
    
   
    @IBInspectable var roundness: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
        
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            setNeedsLayout()
        }
    }
        
    @IBInspectable var borderColor: UIColor = .clear {
        didSet{
            setNeedsLayout()
        }
    }
        
    @IBInspectable var background: UIColor = .clear {
        didSet{
            setNeedsLayout()
        }
    }
    
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 初始化
    init(size: CGFloat = .zero, roundess: CGFloat = 2, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, backgroundColor: UIColor = .clear){
        
        self.roundness = roundess
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.background = backgroundColor
            
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = bounds.width / roundness
        
        //相關設定
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        clipsToBounds = true
            
        // 設定遮罩
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
            
        layer.mask = mask
    }
}
