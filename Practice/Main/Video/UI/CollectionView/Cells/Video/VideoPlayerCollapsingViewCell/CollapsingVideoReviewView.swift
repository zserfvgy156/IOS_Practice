//
//  VideoReviewCollapsingView.swift
//  Practice
//
//  Created by user on 2022/5/13.
//


import UIKit


/** 影片預覽的子 view */
class CollapsingVideoReviewView: ICollapsingView
{
    private let animationKey: String = "CollapsingAnimation"
    
    
    let collapsedAlpha: Float
    let expandAlpha: Float
    
    var collapsedPosition: CGPoint = .zero
    var expandPosition: CGPoint = .zero
    
   
    init(view: UIView, alphaInfo: (collapsed: Float, expand: Float), state: State = State.unknown) {

        self.collapsedAlpha = alphaInfo.collapsed
        self.expandAlpha = alphaInfo.expand
        
        super.init(view: view, state: state)
    }
    
    // 設定動畫參數
    func updateCollapsingArgs(attachViewFrame: CGRect) {
        let collapsedPositionX = view.layer.position.x
        let collapsedPositionY = view.layer.position.y
        let expandPositionX = view.layer.position.x
        let expandPositionY = attachViewFrame.maxY - (view.layer.frame.height / 2)
        
        self.collapsedPosition = CGPoint(x: collapsedPositionX, y: collapsedPositionY)
        self.expandPosition = CGPoint(x: expandPositionX, y: expandPositionY)
    }
    
    override func updateState() {
        
        // 清除目前動畫
        removeCurAnimation()
        
        // 設置初始狀態
        let alphaInfo = getAlphaValue(nextState: curState)
        let positionInfo = getPositionValue(nextState: curState)
        let durationInfo = getDuration(nextState: curState)

        guard let alphaValue = alphaInfo, let positionValue = positionInfo, let duration = durationInfo else { return }
        
        // 透明度動畫
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = alphaValue.from
        alphaAnimation.toValue = alphaValue.to

        // 移動動畫
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: positionValue.from)
        moveAnimation.toValue = NSValue(cgPoint: positionValue.to)
        
        // 設置動畫群組
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [alphaAnimation, moveAnimation]
        groupAnimation.duration = duration
        groupAnimation.repeatCount = 0
        groupAnimation.delegate = self
        
        // 設定初始值
        toLayerState(to: curState)
        
        // 開始動畫
        self.view.layer.add(groupAnimation, forKey: nil)
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
        let alphaInfo = getAlphaValue(nextState: to)
        let positionInfo = getPositionValue(nextState: to)

        guard let alphaValue = alphaInfo, let positionValue = positionInfo else { return }
        
        self.view.layer.opacity = alphaValue.to
        self.view.layer.position = positionValue.to
    }
    
    // 移除目前動畫
    private func removeCurAnimation() {
        if let _ = self.view.layer.animation(forKey: animationKey) {
            self.view.layer.removeAllAnimations()
        }
    }
    
    private func getAlphaValue(nextState: State) -> (from: Float, to: Float)? {
        switch(nextState) {
        case .expand:
            return (from: self.collapsedAlpha, to: self.expandAlpha)
        case .collapsed:
            return (from: self.expandAlpha, to: self.collapsedAlpha)
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

extension CollapsingVideoReviewView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        // 設定初始值
        toLayerState(to: curState)
    }
}
