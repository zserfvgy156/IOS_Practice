//
//  DiscoverIntentInfo.swift
//  Practice
//
//  Created by user on 2022/4/28.
//

import Foundation


class DiscoverCellIntentInfo
{
    // cell 索引
    let cellIndexPath: IndexPath
    
    // 該文章是否收藏
    var isCollect: Bool

    
    
    init(cellIndexPath: IndexPath, isCollect: Bool = false) {
        self.cellIndexPath = cellIndexPath
        self.isCollect = isCollect
    }
}
