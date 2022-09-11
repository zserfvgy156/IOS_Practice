//
//  VideoReviewView.swift
//  Practice
//
//  Created by user on 2022/5/16.
//


import UIKit
import AVKit


protocol VideoReviewViewDelegate: NSObject {
    func onReviewPlayButtomClick(state: VideoReviewView.ButtonState)
}

class VideoReviewView: NSObject {
    
    enum ButtonState: CaseIterable {
        case Play, Pause
    }
    
    weak var videoNameLabel: UILabel?
    weak var videoPlayButton: UIButton?
    
    private var m_buttonState: ButtonState?
    
    weak var delegate: VideoReviewViewDelegate?
    
    
    var buttonState: ButtonState {
        get {
            return self.m_buttonState ?? .Play
        }
        set {
            self.m_buttonState = newValue
            
            updatePlayButton()
        }
    }
    
    var videoName: String {
        get {
            return videoNameLabel?.text ?? ""
        }
        set {
            videoNameLabel?.text = newValue
        }
    }
    
    
    init(videoNameLabel: UILabel, videoPlayButton: UIButton) {
        super.init()
        
        self.videoNameLabel = videoNameLabel
        self.videoPlayButton = videoPlayButton
    
        self.videoPlayButton?.addTarget(self, action: #selector(onVideoPlayButtonClick), for: .touchUpInside)
        self.buttonState = .Play
    }
    
    func updatePlayButton() {
        
        var url: String?
        
        switch(buttonState) {
        case .Play:
            url = "play.fill"
        case .Pause:
            url = "pause.fill"
        }
        
        guard let result = url else { return }
        self.videoPlayButton?.setImage(UIImage(systemName: result), for: .normal)
    }
    
    func updateState(status: AVPlayerItem.Status) {
        buttonState = .Play // 預設假裝可以點擊，但是沒有反應。
    }
    
    func updateState(isPlaying: Bool) {
        buttonState = isPlaying ? .Pause : .Play
    }
    
    @objc private func onVideoPlayButtonClick() {
        self.delegate?.onReviewPlayButtomClick(state: self.buttonState)
    }
}
