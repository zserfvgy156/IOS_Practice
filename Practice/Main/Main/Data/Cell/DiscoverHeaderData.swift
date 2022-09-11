//
//  DiscoverData.swift
//  Practice
//
//  Created by user on 2022/4/14.
//




struct DiscoverHeaderData
{
    var type: EDiscoverCollectionHeader
    var title: String?

    
    init(type: EDiscoverCollectionHeader, title: String? = nil)
    {
        self.type = type
        self.title = title
    }
}
