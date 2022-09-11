//
//  DiscoverCellIntentModel.swift
//  Practice
//
//  Created by user on 2022/4/21.
//


import UIKit


// 基本約束
protocol DiscoverCellIntentModel {
}


// 要跳轉頁面的仲介
class DiscoverIntroCellIntentModel: DiscoverCellIntentModel
{
    var introIntentInfo: DiscoverContentViewIntentInfo
    var tipIntentInfo: DiscoverContentViewIntentInfo
    
    
    init(introIntentInfo: DiscoverContentViewIntentInfo, tipIntentInfo: DiscoverContentViewIntentInfo) {
        self.introIntentInfo = introIntentInfo
        self.tipIntentInfo = tipIntentInfo
    }
    
    
    // 生成要跳轉的介面
    func createIntroIntentViewController(indexPath: IndexPath, item: DiscoverIntroCellData) -> (viewController: UIViewController, animated: Bool)  {
        
        // 要傳遞的資源
        let cellInfo: DiscoverCellIntentInfo = .init(cellIndexPath: indexPath)
        self.introIntentInfo.cellInfo = cellInfo
        
        // 生成介面
        let viewController: DiscoverContentViewController = .init()
        viewController.modalPresentationStyle = .fullScreen
        viewController.intentInfo = self.introIntentInfo
        
        return (viewController: viewController, animated: true)
    }
    
    // 先不處理
    func createTipIntentViewController(arg: Any? = nil) -> (viewController: UIViewController, animated: Bool)  {
        
        let viewController: DiscoverContentViewController = DiscoverContentViewController()
        // viewController.xxx = arg
        
        return (viewController: viewController, animated: true)
    }
}

class DiscoverVideoCellIntentModel: DiscoverCellIntentModel
{
    var intentInfo: DiscoverVideoViewIntentInfo
    
    
    init(intentInfo: DiscoverVideoViewIntentInfo) {
        self.intentInfo = intentInfo
    }
    
    
    // 生成要跳轉的介面
    func createIntentViewController(indexPath: IndexPath, item: DiscoverVideoCellData) -> (viewController: UIViewController, animated: Bool)  {
        
        // 要傳遞的資源
        let cellInfo: DiscoverCellIntentInfo = .init(cellIndexPath: indexPath, isCollect: item.isCollect)
        self.intentInfo.cellInfo = cellInfo
        
        // 生成介面
        let viewController: DiscoverVideoViewController = .init()
        viewController.modalPresentationStyle = .fullScreen
        viewController.intentInfo = intentInfo
        
        return (viewController: viewController, animated: true)
    }
}
