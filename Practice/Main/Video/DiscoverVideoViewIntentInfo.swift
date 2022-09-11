//
//  DiscoverVideoViewIntentInfo.swift
//  Practice
//
//  Created by user on 2022/5/9.
//



class DiscoverVideoViewIntentInfo
{
    // section 需要放置的位置
    var sectionInfos: [IDiscoverVideoSectionInfo]
    
    // 前一個連結資訊
    var cellInfo: DiscoverCellIntentInfo?
    
    
    init(sectionInfos: [IDiscoverVideoSectionInfo]) {
        self.sectionInfos = sectionInfos
    }
}
