//
//  DiscoverSearchNavigationItem.swift
//  Practice
//
//  Created by user on 2022/5/20.
//


import UIKit


protocol DiscoverSearchNavigationItemDelegate: NSObject {
    func onSearchNavigationItemChanged(isSearching: Bool)
}

class DiscoverSearchNavigationItem: UIBarButtonItem {
    
    weak var delegate: DiscoverSearchNavigationItemDelegate?
    
    private var m_isSearching: Bool = false
    
    
    var isSearching: Bool {
        get {
            return self.m_isSearching
        }
        set {
            
            if self.m_isSearching == newValue {
                return
            }
            
            self.m_isSearching = newValue
            
            // 更新圖片
            updateButtonItemImage(isSearching: newValue)
            
            // 回乎
            guard let delegate = self.delegate else { return }
            delegate.onSearchNavigationItemChanged(isSearching: newValue)
        }
    }
 
    
    init(isSearching: Bool) {
        super.init()
        
        // 初始化
        self.m_isSearching = isSearching
        updateButtonItemImage(isSearching: isSearching)
        
        // 設定點擊事件
        self.action = #selector(onBtnSearchClick)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
    
    func nextState() {
        self.isSearching = !isSearching
    }
    
    private func updateButtonItemImage(isSearching: Bool) {
        
        let image = UIImage(systemName: "magnifyingglass")
        let desImage = (isSearching) ? image?.withRenderingMode(.alwaysOriginal) : image
        
        self.image = desImage
    }
    
    @objc func onBtnSearchClick(_ sender: UIBarButtonItem) {
        self.nextState()
    }
}
