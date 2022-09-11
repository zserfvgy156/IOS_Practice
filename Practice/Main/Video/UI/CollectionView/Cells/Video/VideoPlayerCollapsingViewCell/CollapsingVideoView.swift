//
//  VideoPlayerCollectionView.swift
//  Practice
//
//  Created by user on 2022/5/16.
//


import UIKit


class CollapsingVideoView
{
    var playerView: CollapsingVideoPlayView?
    var reviewView: CollapsingVideoReviewView?
    
    var isInit: Bool = false
    var collapsingState: ICollapsingView.State
    
    private var m_duration: TimeInterval = 0.25
    
    var srcExpandHeight: CGFloat?
    var srcCollapsedHeight: CGFloat?
    

    var duration: TimeInterval {
        get {
            return self.m_duration
        }
        set {
            self.m_duration = newValue
            
            self.playerView?.collapsingDuration = newValue
            self.playerView?.expandingDuration = newValue
            self.reviewView?.collapsingDuration = newValue
            self.reviewView?.expandingDuration = newValue
        }
    }
    
    var cellHeight: CGFloat? {
        switch(self.collapsingState)
        {
        case .expand:
            return self.srcExpandHeight
        case .collapsed:
            return self.srcCollapsedHeight
        default:
            return nil
        }
    }
    
    
    init(state: ICollapsingView.State) {
        self.collapsingState = state
    }
    
    func updateState(state: ICollapsingView.State) {
        
        // 相同就結束
        if self.collapsingState == state {
            return
        }
                
        // 設置接下來狀態
        self.collapsingState = state
                
        // 開始動畫
        self.reviewView?.state = state
        self.playerView?.state = state
    }
}
