//
//  VideoContentCollectionView.swift
//  Practice
//
//  Created by user on 2022/5/17.
//


import UIKit


class VideoContentCollectionView: NSObject, UICollectionViewDelegateFlowLayout
{
    weak var collectionView: UICollectionView!
    
    // cell 類別宣告
    let videoTranscriptCellClassName = String(describing: VideoTranscriptCollectionViewCell.self)
    let videoOverviewCellClassName = String(describing: VideoOverviewCollectionViewCell.self)

    var data: DiscoverVideoSegmentedContentInfo?
    var cellHeight: CGFloat = 0
    
    private var m_contentStyle: EDiscoverVideoSegmented?

    
    
    var contentStyle: EDiscoverVideoSegmented?
    {
        get {
            return self.m_contentStyle
        }
        set {
            if self.m_contentStyle == newValue {
                return
            }
            
            self.m_contentStyle = newValue
            self.reload()
        }
    }
    
    var transcriptContentCell: VideoTranscriptCollectionViewCell? {
        return getCell()
    }
    
    
    init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        
        // 使用 cell 本身尺寸
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 500)  // 先給假的高度
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
            
        collectionView.collectionViewLayout = layout

        // 註冊 cell nib
        collectionView.register(UINib(nibName: videoOverviewCellClassName, bundle: nil), forCellWithReuseIdentifier: videoOverviewCellClassName)
        collectionView.register(UINib(nibName: videoTranscriptCellClassName, bundle: nil), forCellWithReuseIdentifier: videoTranscriptCellClassName)
        
        // 註冊服務
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 重新加載
    func reload() {
        guard let collectionView = self.collectionView else { return }
        
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.reloadData()
    }
    
    // 更新 cell 高度
    func updateCellHeight(cellHeight: CGFloat) {
        
        self.cellHeight = cellHeight
    
        // textview 不依賴 collectionView
        if let transcriptContentCell = self.transcriptContentCell {
            transcriptContentCell.frame.size.height = cellHeight
        }
    }
    
    // 取得 cell
    private func getCell<T: UICollectionViewCell>() -> T? {
        for cell in collectionView.visibleCells {
            if let result = cell as? T {
                return result
            }
        }
        return nil
    }
}

extension VideoContentCollectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let style = self.contentStyle, let data = self.data?.getContent(style: style) else { return 0 }
        return data.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let style = self.contentStyle, let data = self.data?.getContent(style: style) else { return UICollectionViewCell() }
        
        
        // 開啟內容滾輪
        self.collectionView.isScrollEnabled = true
        self.collectionView.showsVerticalScrollIndicator = true
        
        
        // 開始設定 cell
        var result: UICollectionViewCell?
        
        switch(style) {
        case .Overview:
            if let srcData = data as? DiscoverVideoSegmentedOverview {
                //介面
                result = collectionView.dequeueReusableCell(withReuseIdentifier: videoOverviewCellClassName, for: indexPath)
                
                //介面初始化
                let srcCell: VideoOverviewCollectionViewCell = result as! VideoOverviewCollectionViewCell
                srcCell.setup(data: srcData)
            }
        case .Transcript:
            if let srcData = data as? DiscoverVideoSegmentedTranscript {
                
                // 自帶 textview 滾輪
                self.collectionView.isScrollEnabled = false
                self.collectionView.showsVerticalScrollIndicator = false
                
                //介面
                result = collectionView.dequeueReusableCell(withReuseIdentifier: videoTranscriptCellClassName, for: indexPath)
                
                //介面初始化
                let srcCell: VideoTranscriptCollectionViewCell = result as! VideoTranscriptCollectionViewCell
                srcCell.frame.size.height = self.cellHeight // 需要設定 textview 高度
                srcCell.setup(data: srcData)
            }
        }
        
        return result ?? UICollectionViewCell()
    }
    
    // 修正橫屏寬度錯誤問題
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
}
