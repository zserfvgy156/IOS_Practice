//
//  DiscoverPageViewNavigationBar.swift
//  Practice
//
//  Created by user on 2022/6/27.
//


import UIKit


// MARK: 模擬新增 / 刪除動作
class DiscoverPageViewNavigationBar
{
    var addItem: DiscoverPageAddItemNavigationItem
    var removeItem: DiscoverPageRemoveItemNavigationItem
    var collectedItem: DiscoverPageCollectItemNavigationItem
    
    
    init(navigationItem: UINavigationItem) {
        
        // 可以設定多組 NavigationItem
        self.addItem = DiscoverPageAddItemNavigationItem()
        self.removeItem = DiscoverPageRemoveItemNavigationItem()
        self.collectedItem = DiscoverPageCollectItemNavigationItem()
        
        navigationItem.rightBarButtonItems = [addItem, removeItem, collectedItem]
    }
}


// MARK: - 自定義返回鍵
class DiscoverPageAddItemNavigationItem: UIBarButtonItem {
    
    override init() {
        super.init()
        
        self.image = UIImage(named: "DiscoverContent/addCollect")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}

class DiscoverPageRemoveItemNavigationItem: UIBarButtonItem {
    
    override init() {
        super.init()
        
        self.image = UIImage(named: "DiscoverContent/removeCollect")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}


class DiscoverPageCollectItemNavigationItem: UIBarButtonItem {
    
    override init() {
        super.init()
        
        self.image = UIImage(named: "DiscoverContent/star-star_symbol")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}
