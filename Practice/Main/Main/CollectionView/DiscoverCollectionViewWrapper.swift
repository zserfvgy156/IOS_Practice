//
//  DiscoverCollectionView.swift
//  Practice
//
//  Created by user on 2022/4/14.
//


import UIKit
import RxDataSources


// MARK: - 自定義 collectionview 委派
protocol DiscoverCollectionViewWrapperDelegate: AnyObject
{
    func intentViewController(_ viewController: UIViewController, animated: Bool)
    func onDiscoverListCollectChanged(indexPath: IndexPath)
}


// MARK: - 自定義 collectionview
class DiscoverCollectionViewWrapper: NSObject
{
    weak var collectionView: UICollectionView!
    
    // 類別名稱宣告
    let introClassName = String(describing: DiscoverIntroCollectionViewCell.self)
    let videoClassName = String(describing: DiscoverVideoCollectionViewCell.self)
    let videoHeaderClassName = String(describing: DiscoverVideoHeaderView.self)
    
    // 創建處理 cell
    lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<DiscoverCollectionViewSection>(
        animationConfiguration: configureAnimation(),
        configureCell: configureCell(),
        configureSupplementaryView: configureSupplementaryView()
    )
    
    // 委派
    weak var delegate: DiscoverCollectionViewWrapperDelegate?
    
    
    init(collectionView: UICollectionView)
    {
        super.init()
        
        self.collectionView = collectionView
        
        // 設定 collectionViewLayout
        collectionView.collectionViewLayout = collectionViewLayout()

        // 註冊 cell nib
        collectionView.register(UINib(nibName: introClassName, bundle: nil), forCellWithReuseIdentifier: introClassName)
        collectionView.register(UINib(nibName: videoClassName, bundle: nil), forCellWithReuseIdentifier: videoClassName)
            
        // 註冊 section 的 header 以供後續重複使用
        collectionView.register(UINib(nibName: videoHeaderClassName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: videoHeaderClassName)
        
        //註冊服務
        collectionView.delegate = self
    }
}


// MARK: - DiscoverCollectionViewWrapper 擴展
extension DiscoverCollectionViewWrapper
{
    // 生成 collectionViewLayout
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        // 使用 cell 本身尺寸
        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        return layout
    }
}


// MARK: - DiscoverCollectionViewWrapper 擴展 (CollectionView DataSource)
extension DiscoverCollectionViewWrapper
{
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource
    
    // 設定動畫類型
    private func configureAnimation() -> AnimationConfiguration {
        return  .init(
            insertAnimation: .left,
            reloadAnimation: .fade,
            deleteAnimation: .right
        )
    }
    
    // cell 註冊
    private func configureCell() -> DataSource<DiscoverCollectionViewSection>.ConfigureCell {
        
        return { [weak self]  dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            
            guard let self = self else { return UICollectionViewCell() }

            // 收成介面
            switch dataSource[indexPath].ui {
            case .Intro(let data):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.introClassName, for: indexPath) as! DiscoverIntroCollectionViewCell
                cell.config(indexPath: indexPath, data: data)
                cell.delegate = self
                return cell
                
            case .Video(let data): fallthrough
            case .Collect(let data):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.videoClassName, for: indexPath) as! DiscoverVideoCollectionViewCell
                cell.config(indexPath: indexPath, data: data)
                cell.delegate = self
                return cell
            }
        }
    }
    
    // 生成 header
    private func configureSupplementaryView() -> DataSource<DiscoverCollectionViewSection>.ConfigureSupplementaryView {
        
        return { [weak self] dataSource, collectionView, kind, indexPath in
            
            guard let self = self else { return UICollectionReusableView(frame: .zero) }
            
            // 標頭訊息
            let headerInfo = dataSource[indexPath.section].header
           
            // 收成介面
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                // 視頻標頭
                if headerInfo.type == .Video {
                    let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.videoHeaderClassName, for: indexPath)
                    if let srcView = reusableView as? DiscoverVideoHeaderView {
                        srcView.title = headerInfo.title ?? ""
                    }
                    return reusableView
                }

            default:
                assert(false, "Unexpected element kind")
            }

            return UICollectionReusableView(frame: .zero)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout 實作
extension DiscoverCollectionViewWrapper: UICollectionViewDelegateFlowLayout
{
    // header 高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerData = dataSource[section].header
        
        switch headerData.type {
        case .Video:
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    // 直接固定，否則高度會出錯。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch dataSource[indexPath].ui {
        case .Intro(_):
            return CGSize(width: collectionView.bounds.width, height: 459)
        case .Video(_): fallthrough
        case .Collect(_):
            return CGSize(width: collectionView.bounds.width, height: 97)
        }
    }
}


// MARK: - DiscoverIntroCollectionViewCellDelegate 回呼
extension DiscoverCollectionViewWrapper: DiscoverIntroCollectionViewCellDelegate
{
    func onIntroCellClick(indexPath: IndexPath) {
        
        guard case .Intro(let item) = dataSource[indexPath].ui else { return }
        
        let info = item.intentModel.createIntroIntentViewController(indexPath: indexPath, item: item)
        self.delegate?.intentViewController(info.viewController, animated: info.animated)
    }
    
    func onTipCellClick(indexPath: IndexPath) {
        
        guard case .Intro(let item) = dataSource[indexPath].ui else { return }
        
        let info = item.intentModel.createTipIntentViewController(arg: nil) // 可以傳入要傳遞的參數
        self.delegate?.intentViewController(info.viewController, animated: info.animated)
    }
}


// MARK: - DiscoverVideoCollectionViewCellDelegate 回呼
extension DiscoverCollectionViewWrapper: DiscoverVideoCollectionViewCellDelegate
{
    func onVideoCellClick(indexPath: IndexPath) {
        
        switch dataSource[indexPath].ui {
        case .Video(let item):
            let info = item.intentModel.createIntentViewController(indexPath: indexPath, item: item) // 可以傳入要傳遞的參數
            self.delegate?.intentViewController(info.viewController, animated: info.animated)
            
        case .Collect(_):
            
            self.delegate?.onDiscoverListCollectChanged(indexPath: indexPath)
        default:
            
            fatalError("something is error")
        }
    }
}
