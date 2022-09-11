//
//  DiscoverIntroCollectionViewCell.swift
//  Practice
//
//  Created by user on 2022/4/12.
//

import UIKit
import RxSwift


protocol DiscoverIntroCollectionViewCellDelegate: AnyObject
{
    func onIntroCellClick(indexPath: IndexPath)
    func onTipCellClick(indexPath: IndexPath)
}

class DiscoverIntroCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var IntroTextView: UIView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var txtIntroTitle: UILabel!
    @IBOutlet weak var txtIntroContent: UILabel!
    @IBOutlet weak var txtReadMore: UILabel!
    
    @IBOutlet weak var bgTipView: UIView!
    @IBOutlet weak var txtTip: UILabel!
    
    
    weak var delegate: DiscoverIntroCollectionViewCellDelegate?

    private var introTitleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    private var logoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    private var tipTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var viewModel: DiscoverIntroCollectionViewModel = .init()
    
    private var disposebag = DisposeBag()
    
    
    var imgLogoURL: String? {
        set {
            self.imgLogo.image = nil
            guard let URL = newValue else { return }
            self.imgLogo.image = UIImage(named: URL)
        }
        get {
            return self.imgLogo.restorationIdentifier
        }
    }
    
    var introTitle: String? {
        set {
            self.txtIntroTitle.text = newValue
        }
        get {
            return self.txtIntroTitle.text
        }
    }
    
    var introContent: String? {
        set {
            self.txtIntroContent.text = newValue
        }
        get {
            return self.txtIntroContent.text
        }
    }
    
    var readMoreText: String? {
        set {
            self.txtReadMore.text = newValue
        }
        get {
            return self.txtReadMore.text
        }
    }
    
    var tipText: String? {
        set {
            self.txtTip.text = newValue
        }
        get {
            return self.txtTip.text
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
        imgLogoURL = nil
        introTitle = ""
        introContent = ""
        readMoreText = ""
        tipText = ""
        
        super.prepareForReuse()
    }
}


// MARK: - 針對介面複寫
extension DiscoverIntroCollectionViewCell
{
    private func awakeUI() {
        
        // 設定背景圓角
        self.bgTipView.layer.cornerRadius = 5.0
        self.bgTipView.clipsToBounds = true
        
        // 安裝點擊事件
        self.logoView.addGestureRecognizer(logoTapGesture)
        self.IntroTextView.addGestureRecognizer(introTitleTapGesture)
        self.bgTipView.addGestureRecognizer(tipTapGesture)
    }
    
    func config(indexPath: IndexPath, data: DiscoverIntroCellData)
    {
        // 設定介面
        self.imgLogoURL = data.imgLogoURL
        
        self.introTitle = data.introTitle
        self.introContent = data.introContent
        self.readMoreText = data.readMoreText
        self.tipText = data.tipText
        
        
        // 註冊 rx
        let inputs: DiscoverIntroCollectionViewModel.Input = .init(
            introTitleTapGesture: introTitleTapGesture.rx.event.asObservable(),
            logoTapGesture: logoTapGesture.rx.event.asObservable(),
            tipTapGesture: tipTapGesture.rx.event.asObservable()
        )

        let output = viewModel.transform(input: inputs)
        output.onClickIntro
            .subscribe(onNext: { [weak self] in
                self?.delegate?.onIntroCellClick(indexPath: indexPath)
            })
            .disposed(by: disposebag)
        
        output.onClickTip
            .subscribe(onNext: { [weak self] in
                self?.delegate?.onTipCellClick(indexPath: indexPath)
            })
            .disposed(by: disposebag)
    }
}
