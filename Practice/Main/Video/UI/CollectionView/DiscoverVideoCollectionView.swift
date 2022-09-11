//
//  DiscoverVideoCollectionView.swift
//  Practice
//
//  Created by user on 2022/5/9.
//


import UIKit
import AVFoundation


enum DiscoverVideoCollectionViewSection
{
    case CollapsingVideo, ArticleSegmented, ArticleContent
}


class DiscoverVideoCollectionViewWrapper: NSObject, UICollectionViewDelegateFlowLayout
{
    weak var collectionView: UICollectionView!
    
    private let videoPlayerCellClassName = String(describing: VideoPlayerCollectionViewCell.self)
    private let videoSegmentedCellClassName = String(describing: VideoSegmentedCollectionViewCell.self)
    private let videoContentCellClassName = String(describing: VideoContentCollectionViewCell.self)
    
    private let model: DiscoverVideoDataModel = DiscoverVideoDataModel()
    
    private let cellHelper: DiscoverDiscoverVideoCollectionViewCellHelper
    
    private var portraitState: ICollapsingView.State = .expand


    var data: [IDiscoverVideoSectionInfo]? {
        get {
            return self.model.data
        }
        set {
            self.model.data = newValue
        }
    }
    
    var dataModel: DiscoverVideoDataModel {
        return model
    }
    
    
    init(collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        self.cellHelper = .init(collectionView: collectionView, curState: .expand)
        
        super.init()
        
        
        // 使用 cell 本身尺寸
        collectionView.collectionViewLayout = collectionViewLayout()

        // 註冊 cell nib
        collectionView.register(UINib(nibName: videoPlayerCellClassName, bundle: nil), forCellWithReuseIdentifier: videoPlayerCellClassName)
        collectionView.register(UINib(nibName: videoSegmentedCellClassName, bundle: nil), forCellWithReuseIdentifier: videoSegmentedCellClassName)
        collectionView.register(UINib(nibName: videoContentCellClassName, bundle: nil), forCellWithReuseIdentifier: videoContentCellClassName)
       
        //註冊服務
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 重新加載
    func reload() {
        collectionView.reloadData()
    }
}


// MARK: - DiscoverVideoCollectionViewWrapper 擴充 (初始化)
extension DiscoverVideoCollectionViewWrapper
{
    // 生成 collectionViewLayout
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        // 使用 cell 本身尺寸
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 500)  // 先給假的高度
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}


// MARK: - DiscoverVideoCollectionViewWrapper 擴充 (縮放動畫外部接口)
extension DiscoverVideoCollectionViewWrapper
{
    // 內容頁的文字元件
    var transcriptContentTextView: HightlightTextView? {
        return cellHelper.transcriptContentTextView
    }
    
    
    // 調整縮放狀態
    func updateCollapsingState(isSearching: Bool, duration: Double) {
        let state: ICollapsingView.State = isSearching ? .collapsed : .expand
        cellHelper.updateCollapsingState(state: state, duration: duration)
    }
    
    // 處理螢幕旋轉事件
    func didRotateState() {
        cellHelper.didRotateState()
    }
    
    // 更新鍵盤狀態
    func updateKeyboardState(safeAreaHeight: CGFloat) {
        cellHelper.updateKeyboardState(safeAreaHeight: safeAreaHeight)
    }
}


// MARK: - UICollectionViewDataSource 註冊
extension DiscoverVideoCollectionViewWrapper: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 判斷資料是否存在
        guard let data = self.model.getItemData(item: indexPath.item) else { return UICollectionViewCell() }
        
        
        // 開始設定 cell
        var result: UICollectionViewCell?
        
        switch(data.style) {
        case .CollapsingVideo:
            if let srcData = data as? DiscoverVideoPlayInfo {
                // 介面
                result = collectionView.dequeueReusableCell(withReuseIdentifier: videoPlayerCellClassName, for: indexPath)
                
                // 介面初始化
                let srcCell: VideoPlayerCollectionViewCell = result as! VideoPlayerCollectionViewCell
                srcCell.setup(data: srcData)
            }
        case .ArticleSegmented:
            if let srcData = data as? DiscoverVideoSegmentedInfo {
                // 介面
                result = collectionView.dequeueReusableCell(withReuseIdentifier: videoSegmentedCellClassName, for: indexPath)
                
                // 介面初始化
                let srcCell: VideoSegmentedCollectionViewCell = result as! VideoSegmentedCollectionViewCell
                srcCell.setup(data: srcData)
                srcCell.delegate = self
            }
        case .ArticleContent:
            if let srcData = data as? DiscoverVideoSegmentedContentInfo {
                // 介面
                result = collectionView.dequeueReusableCell(withReuseIdentifier: videoContentCellClassName, for: indexPath)
                
                // 介面初始化
                let srcCell: VideoContentCollectionViewCell = result as! VideoContentCollectionViewCell
                srcCell.setup(data: srcData, defaultSegmented: cellHelper.segmentedStyle)
                srcCell.delegate = self
            }
        }
        
        return result ?? UICollectionViewCell()
    }
    
    // 修正橫屏寬度錯誤問題
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
}


// MARK: - Cell 相關回呼

extension DiscoverVideoCollectionViewWrapper: VideoSegmentedCollectionViewCellDelegate {
    
    func onSegmentedControlChanged(newSegmented: EDiscoverVideoSegmented) {
        cellHelper.setSegmentedControl(newSegmented: newSegmented)
    }
}

extension DiscoverVideoCollectionViewWrapper: VideoContentCollectionViewCellDelegate {
    
    func onInitVideoContentCollectionViewCellSize(srcCell: UICollectionViewCell) -> CGSize {
        return cellHelper.getInitContentCellSize(srcCell: srcCell)
    }
}
