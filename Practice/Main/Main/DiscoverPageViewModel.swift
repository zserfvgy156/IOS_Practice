//
//  DiscoverCollectionViewModel.swift
//  Practice
//
//  Created by user on 2022/6/27.
//

import Foundation
import RxSwift


// MARK: - 指令
enum CollectionViewEditingCommand {
    case AppendItem(newItem: DiscoverCellItem, section: Int)
    case RemoveItem(IndexPath)
    case CollectItem(indexPath: IndexPath, isCollect: Bool)
    case ReverseCollectItem(IndexPath)
}


// MARK: - 測試指令
extension CollectionViewEditingCommand {
 
    static func testAppendItem() -> CollectionViewEditingCommand {
        return CollectionViewEditingCommand.AppendItem(newItem: DiscoverFakeDataFactory.createTestDiscoverVideoCellData(), section: 1)
    }
    
    static func testRemoveItem() -> CollectionViewEditingCommand {
        return CollectionViewEditingCommand.RemoveItem(.init(item: 0, section: 1))
    }
    
    static func testCollectItem() -> CollectionViewEditingCommand {
        return CollectionViewEditingCommand.ReverseCollectItem(.init(item: 0, section: 1))
    }
}


// MARK: - viewModel
class DiscoverPageViewModel {

    struct Input {
        let appendItem: Observable<CollectionViewEditingCommand>   // 新增
        let removeItem: Observable<CollectionViewEditingCommand>   // 刪除
        let collectItem: Observable<CollectionViewEditingCommand>  // 收藏收藏
    }

    struct Output {
        let changeItems: Observable<[DiscoverCollectionViewSection]> // 清單
    }
    
    
    private let items: BehaviorSubject<[DiscoverCollectionViewSection]> = BehaviorSubject<[DiscoverCollectionViewSection]>(value: [])
    
    private var disposebag = DisposeBag()

    
    init() {
        items.onNext(DiscoverFakeDataFactory.create())
    }
    
    // MARK: input -> output
    func transform(input: Input) -> Output {

        // 指令相關處理
        let commandsItems = Observable.merge(input.appendItem, input.removeItem, input.collectItem)
            .map { [weak self] command in self?.execute(command: command) ?? [] }
            .share()
        
        // 項目變動
        commandsItems.bind(to: items).disposed(by: disposebag)
        
        return Output(changeItems: items.asObservable())
    }
    
    
    /// 更新內容
    /// - Parameter command: 更新指令
    func updateItems(command: CollectionViewEditingCommand) {
        let result = execute(command: command)
        items.onNext(result)
    }
}


// MARK: viewModel 擴充
extension DiscoverPageViewModel {

    ///  透過指令，取得相對應的清單。
    /// - Parameter command: 指令
    /// - Returns: 造險是的清單
    private func execute(command: CollectionViewEditingCommand) -> [DiscoverCollectionViewSection] {
        
        // 取得目前值
        guard var sections = try? items.value() else { return [] }
        
        // 針對指令做相對處理
        switch command {
        case .AppendItem(let newItem, let section):
            
            // 要處理的動作
            var currentSection = sections[section]
            currentSection.items.append(newItem)
            
            // 重新設定
            sections[section] = currentSection
            
        case .RemoveItem(let indexPath):
            
            // 要處理的動作
            var currentSection = sections[indexPath.section]
            currentSection.items.remove(at: indexPath.row)
            
            // 重新設定
            sections[indexPath.section] = currentSection
            
        case .CollectItem(let indexPath, let isCollect):
            
            // 要處理的動作
            var currentSection = sections[indexPath.section]
            
            // 模擬收藏
            var item = currentSection.items[indexPath.row]
            item.date = Date()
            item.ui.videoCell { $0.isCollect = isCollect }
            
            currentSection.items[indexPath.row] = item
            
            // 重新設定
            sections[indexPath.section] = currentSection
            
            
        case .ReverseCollectItem(let indexPath):
            
            // 要處理的動作
            var currentSection = sections[indexPath.section]
            
            // 模擬收藏
            var item = currentSection.items[indexPath.row]
            item.date = Date()
            item.ui.videoCell { $0.isCollect = !$0.isCollect }

            currentSection.items[indexPath.row] = item
            
            // 重新設定
            sections[indexPath.section] = currentSection
            
        }
        
        return sections
    }
}
