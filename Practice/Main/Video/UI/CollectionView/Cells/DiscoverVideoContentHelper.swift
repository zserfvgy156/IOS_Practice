//
//  DiscoverVideoContentHelper.swift
//  Practice
//
//  Created by user on 2022/7/7.
//


import UIKit


class DiscoverDiscoverVideoCollectionViewCellHelper
{
    weak var collectionView: UICollectionView!
    
    // 紀錄直立的狀態
    private var curState: ICollapsingView.State
    
    
    
    init(collectionView: UICollectionView, curState: ICollapsingView.State) {
        self.collectionView = collectionView
        self.curState = curState
    }
}


// MARK: - DiscoverDiscoverVideoCollectionViewCellHelper 擴充 (取得特定 cell 與 取得/設定 cell 相關資訊)
extension DiscoverDiscoverVideoCollectionViewCellHelper {
    
    // 取得分頁類型
    var segmentedStyle: EDiscoverVideoSegmented  {
        return articleSegmentedCell?.segmentedStyle ?? .Overview
    }
    
    // 內容頁的文字元件
    var transcriptContentTextView: HightlightTextView? {
        return articleContentCell?.transcriptContentCell?.hightlightTextView
    }
    
    
    // 設定目前分頁狀態
    func setSegmentedControl(newSegmented: EDiscoverVideoSegmented) {
        articleContentCell?.contentStyle = newSegmented
    }
    
    // 設定 內容頁大小
    func getInitContentCellSize(srcCell: UICollectionViewCell) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: getContentCellHeight(srcCell: srcCell))
    }
    

    // 取得特定 cell
    private var videoPlayerCell: VideoPlayerCollectionViewCell? {
        return getCell()
    }
    
    private var articleSegmentedCell: VideoSegmentedCollectionViewCell? {
        return getCell()
    }
    
    private var articleContentCell: VideoContentCollectionViewCell? {
        return getCell()
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


// MARK: - DiscoverDiscoverVideoCollectionViewCellHelper 擴充 (縮放動畫相關處理)
extension DiscoverDiscoverVideoCollectionViewCellHelper {
    
    // 調整縮放狀態
    func updateCollapsingState(state: ICollapsingView.State, duration: Double) {
        
        // 相同就不處理
        if (self.curState == state) {
            return
        }
        
        // 紀錄直立的狀態
        self.curState = state
        
        // 切換狀態
        changeCellState(state: state, duration: TimeInterval(duration))
    }
    
    // 處理螢幕旋轉事件
    func didRotateState() {

        let noAnimationDuration = TimeInterval(0.01)
        let withAnimationDuration = TimeInterval(0.3)
        
        switch UIDevice.current.orientation
        {
        case .landscapeRight: fallthrough
        case .landscapeLeft:
            
            if self.curState == .expand {
                
                // 橫的強制顯示預覽面板
                changeCellState(state: .collapsed, duration: withAnimationDuration)
            }
            else {
                
                // 當初寫沒有考慮 collectionView cell 會重置問題，
                // preferredLayoutAttributesFitting height 不正確，所以需要先轉直重新設定高度。
                changeCellState(state: .expand, duration: noAnimationDuration)
                changeCellState(state: .collapsed, duration: noAnimationDuration)
            }
        default:
            
            if self.curState == .expand {
                
                // 橫的強制顯示預覽面板
                changeCellState(state: .expand, duration: withAnimationDuration)
            }
            else {
                
                // 當初寫沒有考慮 collectionView cell 會重置問題，
                // preferredLayoutAttributesFitting height 不正確，所以需要先轉直重新設定高度。
                changeCellState(state: .expand, duration: noAnimationDuration)
                changeCellState(state: .collapsed, duration: noAnimationDuration)
            }
        }
    }
    
    // 更新鍵盤狀態
    func updateKeyboardState(safeAreaHeight: CGFloat) {
        
        let keyboardHeight = KeyboardService.keyboardHeight() > 0 ? (KeyboardService.keyboardHeight() - safeAreaHeight) : 0
        let height = getContentCellHeight() - keyboardHeight
        
        articleContentCell?.updateHieght(cellHeight: height)
    }
    
    
    // 更新 cell 狀態
    private func changeCellState(state: ICollapsingView.State, duration: TimeInterval) {
        
        guard let videoCell = videoPlayerCell, let segmentedCell = articleSegmentedCell, let contentCell = articleContentCell else { return }
        
        // 設定影片 cell
        videoCell.duration = duration
        
        
        // 強制橫屏縮小視窗操作
        if (UIDevice.current.orientation.isLandscape && self.curState == .expand) {
            
            videoCell.updateState(state: .collapsed)
            
            
            segmentedCell.transform = .identity
            contentCell.transform = .identity
        
            // 相關設定
            contentCell.updateHieght(cellHeight: getContentCellHeight())
            contentCell.contentStyle = segmentedCell.segmentedStyle
            
            // 動畫
            segmentedCell.transform = CGAffineTransform(translationX: 0, y: (videoCell.frame.maxY - segmentedCell.frame.minY))
            contentCell.transform = CGAffineTransform(translationX: 0, y: (segmentedCell.frame.maxY - contentCell.frame.minY))
            
            return
        }
        
            
        // 設定相對狀態
        videoCell.updateState(state: state)
        
        switch(state) {
        case .collapsed:
            
            segmentedCell.transform = .identity
            contentCell.transform = .identity
            
            // 相關設定
            contentCell.updateHieght(cellHeight: getContentCellHeight())
            contentCell.contentStyle = .Transcript
            
            // 動畫
            segmentedCell.transform = CGAffineTransform(scaleX: 1, y: 0)
            contentCell.transform = CGAffineTransform(translationX: 0, y: (videoCell.frame.maxY - contentCell.frame.minY))
            
        case .expand:
            
            // 相關設定
            contentCell.updateHieght(cellHeight: getContentCellHeight())
            contentCell.contentStyle = segmentedCell.segmentedStyle
            
            // 動畫
            segmentedCell.transform = .identity
            contentCell.transform = .identity
            
        default:
            fatalError("state is unknown.")
        }
    }
    
    // 取得內容高度
    private func getContentCellHeight(srcCell: UICollectionViewCell? = nil) -> CGFloat {
        guard let srcCell = srcCell ?? articleContentCell else { return 0 }
        return collectionView.frame.height - getCellsHeightWithoutSrcCell(srcCell: srcCell)
    }

    // 取得全部 cells 高度，不包含來源 cell。
    private func getCellsHeightWithoutSrcCell(srcCell: UICollectionViewCell) -> CGFloat {
        var result: CGFloat = 0
        for cell in collectionView.visibleCells {
            if (cell == srcCell) { continue }
            result += cell.frame.height
        }
        return result
    }
}
