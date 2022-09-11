//
//  VideoOverviewCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/5/19.
//

import UIKit

class VideoOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var classifyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleTextView: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = rootStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var cellFrame = layoutAttributes.frame
        cellFrame.size.width = UIScreen.main.bounds.width
        cellFrame.size.height = ceil(size.height)
        layoutAttributes.frame = cellFrame
        
        return layoutAttributes
    }
    
    func setup(data: DiscoverVideoSegmentedOverview) {
        titleLabel.text = data.title
        classifyLabel.text = data.classifyText.rawValue
        dateLabel.text = data.timeAgoDisplay()
        articleTextView.text = data.article
    }
}
