//
//  VideoDescriptionCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/5/11.
//

import UIKit


class VideoTranscriptCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hightlightTextView: HightlightTextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 內容保持間距
        hightlightTextView.textContainerInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        hightlightTextView.blurColor = .lightGray
        hightlightTextView.focusColor = .yellow
    }

    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()

        var cellFrame = layoutAttributes.frame
//        cellFrame.size.width = UIScreen.main.bounds.width
        cellFrame.size.height = self.frame.size.height
        layoutAttributes.frame = cellFrame
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        
        hightlightTextView.text = ""
        
        super.prepareForReuse()
    }
    
    func setup(data: DiscoverVideoSegmentedTranscript) {
        hightlightTextView.text = data.article
    }
}
