//
//  AppleLoginCoordinator.swift
//  Practice
//
//  Created by mike on 2022/9/8.
//

import Foundation
import UIKit
import RxSwift


/// 蘋果頁面登入口
class AppleLoginCoordinator: BaseCoordinatorType {
    
    var rootViewController: UIViewController {
        return navi
    }
    
    private var navi = UINavigationController()
    
    
    /// 開啟頁面
    override func start() -> Observable<Void> {
     
        let viewController = AppleLoginViewController()
        viewController.title = "Login"
        
        navi.pushViewController(viewController, animated: false)
        navi.tabBarItem.image = UIImage(named: "Discover/outline_account_circle_black_36pt")
        
        return .never()
    }
}

