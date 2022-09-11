//
//  DiscoverDataSource.swift
//  Practice
//
//  Created by user on 2022/6/22.
//


import RxDataSources
import UIKit


struct DiscoverCollectionViewSection
{
    var uniqueId: String = UUID().uuidString
    var header: DiscoverHeaderData
    var items: [Item]
}

// RxDataSource 夾帶資料層
extension DiscoverCollectionViewSection: AnimatableSectionModelType
{
    typealias Item = DiscoverCellItem
    
    
    var identity: String {
        return uniqueId
    }
    
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}
