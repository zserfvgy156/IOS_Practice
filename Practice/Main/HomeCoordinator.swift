//
//  HomeCoordinator.swift
//  Practice
//
//  Created by mike on 2022/9/8.
//

import Foundation
import UIKit
import RxRelay
import RxSwift


/// 根入口
class HomeCoordinator: BaseCoordinatorType {
    
    
    /// 記錄初始頁面
    enum PageType: Int {
        
        /// 發現
        case discover = 0
        /// 登入
        case login
    }
    
    
    var rootViewController: UIViewController {
        return tabBar
    }
    
    private let window: UIWindow
    private var tabBar = UITabBarController()
    private let pageType: HomeCoordinator.PageType
    
    /// 發現頁面
    private let discoverCoordinator = DiscoverCoordinator()
    /// 蘋果登入頁面
    private let appleLoginCoordinator = AppleLoginCoordinator()
    
    
    init(window: UIWindow, pageType: HomeCoordinator.PageType = .discover) {
        self.window = window
        self.pageType = pageType
    }
    
    /// 開啟頁面
    override func start() -> Observable<Void> {
     
        // 初始相關設定
        tabBar.tabBar.backgroundColor = .white
        tabBar.tabBar.tintColor = .orange
        tabBar.viewControllers = [discoverCoordinator.rootViewController, appleLoginCoordinator.rootViewController]
        tabBar.selectedIndex = pageType.rawValue
        
        // 設定，並開始顯示。
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        
        
        return Observable.merge(self.open(coordinator: discoverCoordinator),
                                self.open(coordinator: appleLoginCoordinator))
    }
}
