//
//  VideoPlayerCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/5/9.
//

import UIKit
import AVKit


class VideoPlayerCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var collapsedStackView: UIStackView!
    
    @IBOutlet weak var collapsedVideoNameLabel: UILabel!
    @IBOutlet weak var collapsedVideoPlayButton: UIButton!
    
    @IBOutlet weak var collapsedSubView: UIView!
    
    
    var collapsingVideoView: CollapsingVideoView = CollapsingVideoView(state: .expand)
    var videoReviewView: VideoReviewView?
    
    
    var duration: TimeInterval {
        get {
            return self.collapsingVideoView.duration
        }
        set {
            self.collapsingVideoView.duration = newValue
        }
    }
    
    var state: ICollapsingView.State {
        return self.collapsingVideoView.collapsingState
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        videoPlayerView.gravity = .resizeAspect
        videoPlayerView.delegate = self
    }
    
    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        // 高度有動態調整，所以需要在這邊生成，高度才會正確。
        self.setupUI()
        
        // 設定高度
        let height = self.collapsingVideoView.srcExpandHeight ?? layoutAttributes.frame.size.height
        
        layoutAttributes.frame.size.height = height
        self.frame.size.height = height
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        videoPlayerView.pause()
        
        super.prepareForReuse()
    }
    
    // 安裝
    func setup(data: DiscoverVideoPlayInfo) {
        videoPlayerView.setContentUrl(url: data.url)
        collapsedVideoNameLabel.text = data.videoName
    }
    
    // 更新目前狀態
    func updateState(state: ICollapsingView.State) {
        self.collapsingVideoView.updateState(state: state)
        self.frame.size.height = self.collapsingVideoView.cellHeight ?? 0
    }
    
    // MARK: 設定介面
    private func setupUI() {
        
        // 判斷目前縮放的 cell 高度
        let pixelWidth = UIScreen.main.nativeBounds.width
        let pointWidth = pixelWidth / UIScreen.main.nativeScale
        
        self.collapsingVideoView.srcExpandHeight = abs(pointWidth / 3 * 2)
        self.collapsingVideoView.srcCollapsedHeight = collapsedStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        // 參數
        let collapsedViewInfo = (bounds: collapsedSubView.layer.bounds, position: collapsedSubView.layer.position)
        let attachViewFrame = subView.layer.frame
        
        
        // 針對目前狀態做螢幕調整
        if self.collapsingVideoView.isInit {
            
            // 播放器
            self.collapsingVideoView.playerView?.updateCollapsingArgs(collapsedViewInfo: collapsedViewInfo)
            
            // 預覽影片
            self.collapsingVideoView.reviewView?.updateCollapsingArgs(attachViewFrame: attachViewFrame)
        }
        else {
            
            // 播放器
            let videoPlayerView = CollapsingVideoPlayView(view: subView)
            videoPlayerView.updateCollapsingArgs(collapsedViewInfo: collapsedViewInfo)
            
            // 預覽影片
            let videoReviewView = VideoReviewView(videoNameLabel: collapsedVideoNameLabel, videoPlayButton: collapsedVideoPlayButton)
            videoReviewView.delegate = self
                
            let alphaInfo: (collapsed: Float, expand: Float) = (collapsed: 1, expand: 0)
            let collapsingVideoReviewView = CollapsingVideoReviewView(view: collapsedStackView, alphaInfo: alphaInfo, state: .expand)
            collapsingVideoReviewView.updateCollapsingArgs(attachViewFrame: attachViewFrame)
                
            // 設定
            self.collapsingVideoView.playerView = videoPlayerView
            self.collapsingVideoView.reviewView = collapsingVideoReviewView
            self.videoReviewView = videoReviewView
            
            // 設定完成
            self.collapsingVideoView.isInit = true
        }
    }
}


// MARK: - cell 回呼
extension VideoPlayerCollectionViewCell: VideoPlayerDelegate {
    
    func onVideoStateChanged(status: AVPlayerItem.Status) {
        self.videoReviewView?.updateState(status: status)
    }
    
    func onVideoIsPlayingChanged(isPlaying: Bool) {
        self.videoReviewView?.updateState(isPlaying: isPlaying)
    }
}

extension VideoPlayerCollectionViewCell: VideoReviewViewDelegate {
    func onReviewPlayButtomClick(state: VideoReviewView.ButtonState) {
        switch(state) {
        case .Play:
            videoPlayerView.play()
        case .Pause:
            videoPlayerView.pause()
        }
    }
}
