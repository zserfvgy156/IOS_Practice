//
//  DiscoverVideoPlayInfo.swift
//  Practice
//
//  Created by user on 2022/5/17.
//

import Foundation

class DiscoverVideoPlayInfo: IDiscoverVideoSectionInfo {
    
    // 分隊內容
    var style: DiscoverVideoCollectionViewSection = .CollapsingVideo
    
    // 播放影片路徑
    var url: URL?
    
    // 影片名稱
    var videoName: String
    
    
    init(url: URL?, videoName: String) {
        self.url = url
        self.videoName = videoName
    }
}
