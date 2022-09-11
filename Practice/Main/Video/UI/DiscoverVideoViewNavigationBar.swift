//
//  DiscoverVideoViewNavigationBar.swift
//  Practice
//
//  Created by user on 2022/5/9.
//


import UIKit

class DiscoverVideoViewNavigationBar
{
    var collectNavigationItem: DiscoverCollectNavigationItem
    var searchNavigationItem: DiscoverSearchNavigationItem
    
    
    init(navigationItem: UINavigationItem) {
    
        // 可以設定多組 NavigationItem
        self.collectNavigationItem = DiscoverCollectNavigationItem(isCollect: false)
        self.searchNavigationItem = DiscoverSearchNavigationItem(isSearching: false)
        
        navigationItem.rightBarButtonItems = [self.collectNavigationItem, self.searchNavigationItem]
    }
}
