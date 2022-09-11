//
//  DiscoverPage.swift
//  Practice
//
//  Created by user on 2022/4/7.
//

import UIKit
import RxSwift
import RxDataSources


class DiscoverPageViewController: UIViewController {
   
    private var navigationBar: DiscoverPageViewNavigationBar?
    private var list: DiscoverCollectionViewWrapper?
    
    private let viewModel: DiscoverPageViewModel = .init()
    
    private var disposebag = DisposeBag()

    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupViewController()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - DiscoverPageViewController 擴充
extension DiscoverPageViewController {
    
    private func setupNavigationBar() {
        self.navigationBar = DiscoverPageViewNavigationBar(navigationItem: self.navigationItem)
    }

    private func setupViewController() {
        self.title = "Discover"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCollectionView() {
        self.list = DiscoverCollectionViewWrapper(collectionView: collectionView)
        self.list?.delegate = self
    }
    
    private func bindViewModel() {
        
        guard let navigationBar = self.navigationBar, let list = self.list else { return }
        
        // 新增項目
        let appendItem = navigationBar.addItem.rx.tap
            .map(CollectionViewEditingCommand.testAppendItem)
        
        let removeItem = navigationBar.removeItem.rx.tap
            .map(CollectionViewEditingCommand.testRemoveItem)
        
        let collectItem = navigationBar.collectedItem.rx.tap
            .map(CollectionViewEditingCommand.testCollectItem)
        
        
        // input 轉換
        let inputs = DiscoverPageViewModel.Input(
            appendItem: appendItem,
            removeItem: removeItem,
            collectItem: collectItem
        )
        
        // output 轉換
        let outputs = viewModel.transform(input: inputs)
        
        outputs.changeItems
            .bind(to: collectionView.rx.items(dataSource: list.dataSource))
            .disposed(by: disposebag)
    }
}


// MARK: - 自定義 collectionview 委派
extension DiscoverPageViewController: DiscoverCollectionViewWrapperDelegate
{
    func intentViewController(_ viewController: UIViewController, animated: Bool) {

        // 根據不同 view 回乎
        switch viewController {
        case let srcViewController as DiscoverVideoViewController:
            srcViewController.delegate = self
        default:
            break
        }
        
        // 切換頁面
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func onDiscoverListCollectChanged(indexPath: IndexPath) {
        let command = CollectionViewEditingCommand.ReverseCollectItem(indexPath)
        self.viewModel.updateItems(command: command)
    }
}


// MARK: - 其他頁面委派
extension DiscoverPageViewController: DiscoverVideoViewControllerDelegate
{
    func onDiscoverVideoCollectChanged(indexPath: IndexPath, isCollect: Bool) {
        let command = CollectionViewEditingCommand.CollectItem(indexPath: indexPath, isCollect: isCollect)
        self.viewModel.updateItems(command: command)
    }
}

