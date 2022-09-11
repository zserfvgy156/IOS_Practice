//
//  DiscoverCoordinator.swift
//  Practice
//
//  Created by mike on 2022/9/8.
//

import Foundation
import UIKit
import RxSwift


/// 發現頁面登入口
class DiscoverCoordinator: BaseCoordinatorType {
    
    var rootViewController: UIViewController {
        return navi
    }
    
    private var navi = UINavigationController()
    
    
    /// 開啟頁面
    override func start() -> Observable<Void> {
     
        let viewController = DiscoverPageViewController()
        viewController.title = "Discover"
        
        navi.pushViewController(viewController, animated: false)
        navi.tabBarItem.image = UIImage(named: "Discover/outline_location_on_black_36pt")
        
        return .never()
    }
}
