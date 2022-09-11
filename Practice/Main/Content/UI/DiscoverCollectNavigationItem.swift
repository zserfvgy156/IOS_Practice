//
//  DiscoverContentCollectNavigationBar.swift
//  Practice
//
//  Created by user on 2022/5/6.
//


import UIKit


protocol DiscoverCollectNavigationItemDelegate: NSObject {
    func onCollectNavigationItemChanged(isCollect: Bool, defaultAlertController: UIAlertController?)
}


class DiscoverCollectNavigationItem: UIBarButtonItem {
    
    weak var delegate: DiscoverCollectNavigationItemDelegate?
    
    private var m_isCollect: Bool = false
    
    
    var isCollect: Bool {
        get {
            return self.m_isCollect
        }
        set {
            
            if (self.m_isCollect == newValue) {
                return
            }
            
            self.m_isCollect = newValue
            
            // 更新圖片
            updateButtonItemImage(isCollect: newValue)
            
            // 回乎
            guard let delegate = self.delegate else { return }
            let alertController: UIAlertController = getCollectChangedDialog(isCollect: self.m_isCollect)
            delegate.onCollectNavigationItemChanged(isCollect: self.m_isCollect, defaultAlertController: alertController)
        }
    }
    
    
    init(isCollect: Bool) {
        super.init()
        
        // 初始化
        self.m_isCollect = isCollect
        updateButtonItemImage(isCollect: isCollect)
        
        // 設定點擊事件
        self.action = #selector(onBtnCollectClick)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
    
    
    func nextState() {
        self.isCollect = !isCollect
    }
    
    private func updateButtonItemImage(isCollect: Bool) {
        
        let imageNamed = self.getNavigationCollectImageNamed(isCollect: isCollect)
        
        self.image = UIImage(named: imageNamed)
    }
    
    private func getNavigationCollectImageNamed(isCollect: Bool) -> String {
        return "DiscoverContent/" + ((isCollect) ? "removeCollect" :  "addCollect")
    }
    
    private func getCollectChangedDialog(isCollect: Bool) -> UIAlertController {
        
        let title: String = NSLocalizedString("dialog_default_title", comment: "提示")
        let content: String = (isCollect) ? NSLocalizedString("dialog_content_collect", comment: "已收藏") : NSLocalizedString("dialog_content_non_collect", comment: "取消收藏")
        
        let controller = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        return controller
    }
    
    @objc func onBtnCollectClick(_ sender: UIBarButtonItem) {
        self.nextState()
    }
}
