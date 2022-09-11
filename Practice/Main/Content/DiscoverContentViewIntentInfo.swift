//
//  DiscoverContentViewIntentInfo.swift
//  Practice
//
//  Created by user on 2022/4/28.
//



class DiscoverContentViewIntentInfo
{
    var newsTip: String
    
    // 日期
    var date: String
    
    // 標題
    var title: String

    // 標題圖片
    var imgLogoURL: String
    
    // 本文內容
    var content: String
    
    //點擊連結
    var link: (title: String, URL: String)
    
    // 前一個連結資訊
    var cellInfo: DiscoverCellIntentInfo?
    
    
    init(newsTip: String, date: String, title: String, imgLogoURL: String, content: String, link: (title: String, URL: String)) {
        self.newsTip = newsTip
        self.date = date
        self.title = title
        self.imgLogoURL = imgLogoURL
        self.content = content
        self.link = link
    }
}
