//
//  VideoCollapsingViewCell.swift
//  Practice
//
//  Created by user on 2022/5/12.
//


import UIKit


struct ScaleInfo {
    let collapsed: CATransform3D
    let expand: CATransform3D
}


/** 影片播放器的子 view */
class CollapsingVideoPlayView: ICollapsingView
{
    private let animationKey: String = "CollapsingAnimation"
    
    
    let srcScaleX: Double
    let srcScaleY: Double
    
    var landscapeScale: ScaleInfo?
    var portraitScale: ScaleInfo?
    
    var collapsedPosition: CGPoint = .zero
    var expandPosition: CGPoint = .zero
    
    
    init(view: UIView) {
        
        self.srcScaleX = view.layer.value(forKeyPath: "transform.scale.x") as? CGFloat ?? 1.0
        self.srcScaleY = view.layer.value(forKeyPath: "transform.scale.y") as? CGFloat ?? 1.0
        
        super.init(view: view, state: .expand)
    }
    
    override init(view: UIView, state: ICollapsingView.State = State.unknown) {
        fatalError("Unimplemented")
    }
    
    // 設定動畫參數
    func updateCollapsingArgs(collapsedViewInfo: (bounds: CGRect, position: CGPoint)) {
        
        // 位移
        let collapsedPositionX = collapsedViewInfo.position.x
        let collapsedPositionY = collapsedViewInfo.position.y
        let expandPositionX = view.layer.position.x
        let expandPositionY = view.layer.position.y
        
        self.collapsedPosition = CGPoint(x: collapsedPositionX, y: collapsedPositionY)
        self.expandPosition = CGPoint(x: expandPositionX, y: expandPositionY)
        
        
        // 縮放
        let collapsedScaleX = collapsedViewInfo.bounds.width / view.layer.bounds.width
        let collapsedScaleY = collapsedViewInfo.bounds.height / view.layer.bounds.height

        let expandScaleX = self.srcScaleX
        let expandScaleY = self.srcScaleY
        
        let collapsedScale = CATransform3DMakeScale(collapsedScaleX, collapsedScaleY, 1)
        let expandScale = CATransform3DMakeScale(expandScaleX, expandScaleY, 1)
        
        switch UIDevice.current.orientation
        {
        case .landscapeRight: fallthrough
        case .landscapeLeft:
        
            if landscapeScale == nil {
                landscapeScale = ScaleInfo(collapsed: collapsedScale, expand: expandScale)
            }
            
        default:
            
            if portraitScale == nil {
                portraitScale = ScaleInfo(collapsed: collapsedScale, expand: expandScale)
            }
        }
        
        // 設定最終值
        toLayerState(to: curState)
    }
    
    override func updateState() {
        
        // 清除目前動畫
        removeCurAnimation()
        
        let scaleInfo = getScaleValue(nextState: curState)
        let positionInfo = getPositionValue(nextState: curState)
        let durationInfo = getDuration(nextState: curState)
        
        guard let scaleValue = scaleInfo, let positionValue = positionInfo, let duration = durationInfo else { return }
        
        // 移動動畫
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: positionValue.from)
        moveAnimation.toValue = NSValue(cgPoint: positionValue.to)
        
        // 縮放動畫
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = NSValue(caTransform3D: scaleValue.from)
        scaleAnimation.toValue = NSValue(caTransform3D: scaleValue.to)

        // 設置動畫群組
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, moveAnimation]
        groupAnimation.duration = duration
        groupAnimation.repeatCount = 0
        groupAnimation.delegate = self
        
        
        // 設定初始值
        toLayerState(to: curState)
        
        // 開始動畫
        self.view.layer.add(groupAnimation, forKey: animationKey)
    }
    
    override func reset() {
        
        // 設定初始值
        toLayerState(to: srcState)
        
        // 呼叫父類別
        super.reset()
    }
    
    
    // 設定目前數值
    override func toLayerState(to: State) {
        
        // 清除目前動畫
        removeCurAnimation()
        
        // 設定最終值
        let scaleInfo = getScaleValue(nextState: to)
        let positionInfo = getPositionValue(nextState: to)

        guard let scaleValue = scaleInfo, let positionValue = positionInfo else { return }

        self.view.layer.transform = scaleValue.to
        self.view.layer.position = positionValue.to
    }
    
    // 移除目前動畫
    private func removeCurAnimation() {
        if let _ = self.view.layer.animation(forKey: animationKey) {
            self.view.layer.removeAllAnimations()
        }
    }
    
    private func getScaleValue(nextState: State) -> (from: CATransform3D, to: CATransform3D)? {
        
        var result: ScaleInfo?
    
        // 根據螢幕轉向去調整
        switch UIDevice.current.orientation
        {
        case .landscapeRight: fallthrough
        case .landscapeLeft:
            result = landscapeScale
        default:
            result = portraitScale
        }
        
        guard let result = result else { return nil }
        
        // 返回要縮放的大小
        switch(nextState) {
        case .expand:
            return (from: result.collapsed, to: result.expand)
        case .collapsed:
            return (from: result.expand, to: result.collapsed)
        case .unknown:
            return nil
        }
    }
    
    private func getPositionValue(nextState: State) -> (from: CGPoint, to: CGPoint)? {
        switch(nextState) {
        case .expand:
            return (from: self.collapsedPosition, to: self.expandPosition)
        case .collapsed:
            return (from: self.expandPosition, to: self.collapsedPosition)
        case .unknown:
            return nil
        }
    }
}

extension CollapsingVideoPlayView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
        // 設定初始值
        toLayerState(to: curState)
    }
}
