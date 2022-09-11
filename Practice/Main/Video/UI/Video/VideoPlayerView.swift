//
//  VideoPlayerView.swift
//  Practice
//
//  Created by user on 2022/5/10.
//

import UIKit
import AVKit


protocol VideoPlayerDelegate: NSObject {
    func onVideoStateChanged(status: AVPlayerItem.Status)
    func onVideoIsPlayingChanged(isPlaying: Bool)
}


class VideoPlayerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rootView: UIView!
    
    var playerViewController: AVPlayerViewController?
    
    private var m_viewModel: VideoPlayerViewModel = VideoPlayerViewModel()
    
   
    
    var gravity: AVLayerVideoGravity {
        get {
            return playerViewController?.videoGravity ?? AVLayerVideoGravity.resizeAspect
        }
        set {
            playerViewController?.videoGravity = newValue
        }
    }
    
    var player: AVPlayer? {
        get {
            return playerViewController?.player
        }
        set {
            playerViewController?.player = newValue
        }
    }
    
    var status: AVPlayerItem.Status {
        return self.m_viewModel.status
    }
    
    var delegate: VideoPlayerDelegate? {
        get {
            return self.m_viewModel.delegate ?? nil
        }
        set {
            self.m_viewModel.delegate = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func setContentUrl(url: URL?) {
        self.m_viewModel.url = url
    }
    
    func play() {
        self.m_viewModel.play()
    }
    
    func pause() {
        self.m_viewModel.pause()
    }
    
    func clear() {
        self.m_viewModel.clear()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 加入完畢後，調整播放影片位置大小。
        guard let playerViewController = self.playerViewController else { return }
        playerViewController.view.frame = rootView.bounds
    }
    
    private func commonInit() {
        
        // 加入舞台
        let nib = UINib(nibName: String(describing: VideoPlayerView.self), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        
        // 加入圖層
        self.playerViewController = AVPlayerViewController()
        
        guard let playerViewController = self.playerViewController else { return }
        playerViewController.player = self.m_viewModel.player
        rootView.addSubview(playerViewController.view)
    }
}

class VideoPlayerViewModel: NSObject
{
    weak var delegate: VideoPlayerDelegate?
    
    private var m_url: URL?
    private var m_isPlaying: Bool = false
    private var m_isReadyToPlay: Bool = false
    private var m_isWaitimgForPlay: Bool = false
    
    
    lazy var player: AVPlayer = {
        let result = AVPlayer()
        result.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        return result
    }()
    
    var status: AVPlayerItem.Status {
        return self.player.currentItem?.status ?? .unknown
    }
    
    var url: URL? {
        get {
            return self.m_url
        }
        set {
            // 暫停現在播放內容
            pause()
        
            // 設定要播放的內容
            self.m_url = newValue
            
            //安裝播放內容
            setupContentURL()
        }
    }
    
    
    override init() {
        super.init()
    }
    
    init(url: URL?) {
        super.init()
        self.url = url
    }
    
    init(fileName: String, extName: String = "mp4") {
        super.init()
        self.url = Bundle.main.url(forResource: fileName, withExtension: extName)
    }
    
    // 解觀察者
    deinit {
        
        // 移除速率
        player.removeObserver(self, forKeyPath: "rate")
        
        // 清除播放項目
        clearAVCurrentItem()
    }
    
    func play() {
        if !self.m_isReadyToPlay || self.m_isPlaying { return }
        player.play()
    }
    
    func reset() {
        
        // 暫停
        pause()
        
        // 從 0 開始播放
        guard let currentItem = player.currentItem else { return }
        currentItem.seek(to: .zero, completionHandler: nil)
    }
        
    func pause() {
        if !self.m_isReadyToPlay || !self.m_isPlaying { return }
        player.pause()
    }
    
    func clear() {
        
        // 暫停
        pause()
        
        // 清除播放項目
        clearAVCurrentItem()
        
        // 重新設定
        self.m_isReadyToPlay = false
        self.m_isPlaying = false
    }
    
    private func clearAVCurrentItem() {
        if player.currentItem == nil { return }
        player.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        player.replaceCurrentItem(with: nil)
    }
    
    private func setupContentURL() {
        guard let url = self.url else { return }
        
        // 清除
        clear()
        
        // 監聽加載狀況
        let item = AVPlayerItem(url: url)
        item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context: nil)
        
        // 取代播放內容
        player.replaceCurrentItem(with: item)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if keyPath == #keyPath(AVPlayerItem.status) {
                
            // 取得變化狀態
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // 確認可以播放
            self.m_isReadyToPlay = (status == .readyToPlay)
            
            // 回乎監聽
            self.delegate?.onVideoStateChanged(status: status)
            
        } else if keyPath == "rate" {
            
            // 0 表示暫停
            let rate = change?[NSKeyValueChangeKey.newKey] as? Float
            self.m_isPlaying = !(rate == 0)
            
            // 回乎監聽
            self.delegate?.onVideoIsPlayingChanged(isPlaying: self.m_isPlaying)
        }
    }
}
