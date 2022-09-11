//
//  ArticleSegmentedCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/5/17.
//

import UIKit


protocol VideoSegmentedCollectionViewCellDelegate: NSObject {
    func onSegmentedControlChanged(newSegmented: EDiscoverVideoSegmented)
}

class VideoSegmentedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    weak var delegate: VideoSegmentedCollectionViewCellDelegate?
    
    var segmentedStyle: EDiscoverVideoSegmented?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 設置切換選項時執行的動作
        self.segmentedControl.addTarget(self, action: #selector(self.onSegmentedChange(sender:)), for: .valueChanged)
    }

    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        
        // 設定高度
        let height = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
//        layoutAttributes.frame.size.width = UIScreen.main.bounds.width
        layoutAttributes.frame.size.height = height
        
        self.frame.size.height = height
        
        return layoutAttributes
    }
    
    func setup(data: DiscoverVideoSegmentedInfo) {
        for (index, value) in data.segmentedStyles.enumerated() {
            self.segmentedControl.setTitle(value.rawValue, forSegmentAt: index)
        }
        
        self.segmentedStyle = data.defaultSegmented
    }
    
    @objc func onSegmentedChange(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let title = sender.titleForSegment(at: index)

        guard let next = EDiscoverVideoSegmented(rawValue: title ?? "") else { return }
        
        self.segmentedStyle = next
        self.delegate?.onSegmentedControlChanged(newSegmented: next)
    }
}
