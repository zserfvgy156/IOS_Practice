//
//  Coordinator.swift
//  Practice
//
//  Created by mike on 2022/8/30.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


protocol BaseCoordinatorProtocol {
    
    /// 一定需要設定主控制器
    var rootViewController: UIViewController { get }
    
    /// 需要複寫
    func start() -> Observable<Void>
}

typealias BaseCoordinatorType = BaseCoordinator & BaseCoordinatorProtocol


/// 接入口
class BaseCoordinator {

    // 本身唯一 ID
    lazy var ID: String = UUID().uuidString
    
    // 給內部使用
    internal var disposeBag = DisposeBag()
    
    // 給內部銷毀使用
    internal let dismissTrigger = PublishRelay<Void>()
    
    
    // 紀錄入口
    private var coordinators: [String: BaseCoordinatorType] = [:]
    
    
    /// 開啟其他 Coordinator
    func open(coordinator: BaseCoordinatorType) -> Observable<Void> {
        coordinators[coordinator.ID] = coordinator
        
        return coordinator.start().do (onNext: { [weak self] in
            self?.free(ID: coordinator.ID)
        })
    }
    
    /// 需要複寫
    func start() -> Observable<Void> {
        return .never()
    }
    
    /// 釋放記憶體
    private func free(ID: String){
        coordinators[ID] = nil
    }
}




