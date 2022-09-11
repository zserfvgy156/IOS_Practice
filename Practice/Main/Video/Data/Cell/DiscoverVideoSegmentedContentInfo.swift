//
//  DiscoverVideoInfo.swift
//  Practice
//
//  Created by user on 2022/5/9.
//

import Foundation


enum EDiscoverVideoSegmented: String {
    case Overview, Transcript
}

protocol IDiscoverVideoSegmented {
    var style: EDiscoverVideoSegmented { get }
    var itemCount: Int { get }
}

class DiscoverVideoSegmentedContentInfo: IDiscoverVideoSectionInfo {
    
    // 分隊內容
    var style: DiscoverVideoCollectionViewSection = .ArticleContent
    
    // 分段訊息
    var segmenteds: [IDiscoverVideoSegmented]
    
    
    init(segmenteds: [IDiscoverVideoSegmented]) {
        self.segmenteds = segmenteds
    }
    
    func getContent(style: EDiscoverVideoSegmented) -> IDiscoverVideoSegmented? {
        for item in segmenteds {
            if style == item.style {
                return item
            }
        }
        return nil
    }
}

class DiscoverVideoSegmentedOverview: IDiscoverVideoSegmented
{
    var style: EDiscoverVideoSegmented = .Overview
    var itemCount: Int = 1
    
    var title: String
    var uploaderDate: Date
    var article: String
    var classifyText: EDiscoverVideoClassify
    
    
    init(title: String, uploaderDate: Date, article: String, classifyText: EDiscoverVideoClassify) {
        self.title = title
        self.uploaderDate = uploaderDate
        self.article = article
        self.classifyText = classifyText
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        if minuteAgo < self.uploaderDate {
            let diff = Calendar.current.dateComponents([.second], from: self.uploaderDate, to: Date()).second ?? 0
            return "\(diff) seconds remaining"
        } else if hourAgo < self.uploaderDate {
            let diff = Calendar.current.dateComponents([.minute], from: self.uploaderDate, to: Date()).minute ?? 0
            return "\(diff) minutes remaining"
        } else if dayAgo < self.uploaderDate {
            let diff = Calendar.current.dateComponents([.hour], from: self.uploaderDate, to: Date()).hour ?? 0
            return "\(diff) hours remaining"
        } else if weekAgo < self.uploaderDate {
            let diff = Calendar.current.dateComponents([.day], from: self.uploaderDate, to: Date()).day ?? 0
            return "\(diff) days remaining"
        }
        
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self.uploaderDate, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago remaining"
    }
}

class DiscoverVideoSegmentedTranscript: IDiscoverVideoSegmented
{
    var style: EDiscoverVideoSegmented = .Transcript
    var itemCount: Int = 1
    
    var article: String
    
    
    init(article: String) {
        self.article = article
    }
}
