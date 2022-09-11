//
//  DiscoverVideoSegmentedInfo.swift
//  Practice
//
//  Created by user on 2022/5/17.
//




class DiscoverVideoSegmentedInfo: IDiscoverVideoSectionInfo {
    
    // section style
    var style: DiscoverVideoCollectionViewSection = .ArticleSegmented
    
    // 分類訊息
    var segmentedStyles: [EDiscoverVideoSegmented] = []
    
    // 預設訊息
    var defaultSegmented: EDiscoverVideoSegmented
    
    
    init(segmenteds: [IDiscoverVideoSegmented], defaultSegmented: EDiscoverVideoSegmented) {
        for item in segmenteds {
            self.segmentedStyles.append(item.style)
        }
        
        self.defaultSegmented = defaultSegmented
    }
}
