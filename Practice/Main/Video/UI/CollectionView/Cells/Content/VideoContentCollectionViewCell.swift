//
//  VideoContentCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/5/17.
//

import UIKit


protocol VideoContentCollectionViewCellDelegate: NSObject {
    func onInitVideoContentCollectionViewCellSize(srcCell: UICollectionViewCell) -> CGSize
}


class VideoContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var customCollectionView: VideoContentCollectionView?
    
    weak var delegate: VideoContentCollectionViewCellDelegate?
    
    
    var contentStyle: EDiscoverVideoSegmented?
    {
        get {
            return self.customCollectionView?.contentStyle
        }
        set {
            self.customCollectionView?.contentStyle = newValue
        }
    }
    
    var transcriptContentCell: VideoTranscriptCollectionViewCell? {
        return self.customCollectionView?.transcriptContentCell
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.customCollectionView = VideoContentCollectionView(collectionView: collectionView)
    }
    
    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        
        // 設定高度
        let cellSize = delegate?.onInitVideoContentCollectionViewCellSize(srcCell: self) ?? CGSize()
        let height = cellSize.height
        
        layoutAttributes.frame.size.height = height
        updateHieght(cellHeight: height)

        
        return layoutAttributes
    }
    
    func updateHieght(cellHeight: CGFloat) {
        self.frame.size.height = cellHeight
        self.customCollectionView?.updateCellHeight(cellHeight: cellHeight)
    }

    func setup(data: DiscoverVideoSegmentedContentInfo, defaultSegmented: EDiscoverVideoSegmented) {
        self.customCollectionView?.data = data
        self.contentStyle = defaultSegmented
    }
}
