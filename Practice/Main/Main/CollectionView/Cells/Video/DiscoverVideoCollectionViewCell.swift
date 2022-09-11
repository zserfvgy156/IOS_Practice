//
//  DiscoverCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/4/11.
//

import UIKit
import RxSwift


protocol DiscoverVideoCollectionViewCellDelegate: AnyObject {
    func onVideoCellClick(indexPath: IndexPath)
}

class DiscoverVideoCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var imgCollect: UIImageView!
    @IBOutlet weak var divideView: UIView!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var txtClassify: UILabel!
    @IBOutlet weak var txtContent: UILabel!
    
    weak var delegate: DiscoverVideoCollectionViewCellDelegate?
    
    private var itemTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var viewModel: DiscoverVideoCollectionViewModel = .init()
    
    private var disposebag = DisposeBag()
    
    
    /** 是否顯示分割線 */
    var divideVisible: Bool {
        set {
            self.divideView.isHidden = !newValue
        }
        get {
            return !self.divideView.isHidden
        }
    }
    
    var imgVideoURL: String? {
        set {
            self.imgVideo.image = nil
            guard let URL = newValue else { return }
            self.imgVideo.image = UIImage(named: URL)
        }
        get {
            return self.imgVideo.restorationIdentifier
        }
    }
    
    var classifyText: String? {
        set {
            self.txtClassify.text = newValue
        }
        get {
            return self.txtClassify.text
        }
    }
    
    var contentText: String? {
        set {
            self.txtContent.text = newValue
        }
        get {
            return self.txtContent.text
        }
    }
    
    var imgCollectVisible: Bool {
        set {
            self.imgCollect.isHidden = !newValue
        }
        get {
            return !self.imgCollect.isHidden
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 初始化介面
        awakeUI()
    }

    /** 設定 autolayout */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        var cellFrame = layoutAttributes.frame
        cellFrame.size.width = UIScreen.main.bounds.width
        cellFrame.size.height = ceil(size.height)
        
        layoutAttributes.frame = cellFrame
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        
        // 回收 Rx
        disposebag = DisposeBag()
        
        // 清空介面
        self.imgVideoURL = nil
        self.divideVisible = false
        self.classifyText = ""
        self.contentText = ""
        self.imgCollectVisible = false
        
        super.prepareForReuse()
    }

    func updateCollectState(data: DiscoverVideoCellData) {
        self.imgCollectVisible = data.isCollect
    }
}


// MARK: - 針對介面複寫
extension DiscoverVideoCollectionViewCell {
    
    private func awakeUI() {
        
        // 安裝點擊事件
        self.contentView.addGestureRecognizer(itemTapGesture)
    }
    
    func config(indexPath: IndexPath, data: DiscoverVideoCellData)
    {
        // 設定介面
        self.divideVisible = (indexPath.item != 0)
        self.imgVideoURL = data.imgVideoURL
        self.classifyText = data.classifyText.rawValue
        self.contentText = data.contentText
        self.imgCollectVisible = data.isCollect
        
        
        // 註冊 rx
        let inputs: DiscoverVideoCollectionViewModel.Input = .init(
            itemTapGesture: itemTapGesture.rx.event.asObservable()
        )
        
        let output = viewModel.transform(input: inputs)
        output.onClickItem
            .subscribe(onNext: { [weak self] in
                self?.delegate?.onVideoCellClick(indexPath: indexPath)
            })
            .disposed(by: disposebag)
    }
}
