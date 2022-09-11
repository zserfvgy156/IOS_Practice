//
//  HeaderEditorViewController.swift
//  Practice
//
//  Created by user on 2022/7/12.
//

import UIKit
import RxSwift



class HeaderEditorViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    
    
    @IBOutlet weak var outputImageView: UIImageView!
    

    var headerImage: UIImage?
    
    var circleMask: HeaderEditorCircleMask?
    var reviewPhoto: HeaderEditorReviewPhoto?
    
    var viewModel: HeaderEditorViewModel = .init()
    

    private var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotateButton.isMultipleTouchEnabled = false
        cropButton.isMultipleTouchEnabled = false
        

        // 初始化
        self.circleMask = HeaderEditorCircleMask(view: maskView)
        self.reviewPhoto = HeaderEditorReviewPhoto(scrollView: scrollView, contentImageView: contentImageView)
    
        // 綁定
        binding()
        
        // 安裝測試
        initHeaderPhoto()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: 綁定
extension HeaderEditorViewController {

    // 綁定按鈕
    func binding() {
        
        let firstViewDidLayoutSubviews = rx.sentMessage(#selector(viewDidLayoutSubviews)).map { _ in () }.take(1).share()
        let showImageDoneTrigger = PublishSubject<Void>()
        
        
        // MARK: viewModel 輸入
        let input = HeaderEditorViewModel.Input(
            firstViewDidLayoutSubviews: firstViewDidLayoutSubviews,
            cropButtonTap: cropButton.rx.tap.asObservable(),
            rotateButtonTap: rotateButton.rx.tap.asObservable(),
            showImageDoneTrigger: showImageDoneTrigger.asObservable()
        )
        

        // MARK: viewModel 輸出
        let output = viewModel.transform(input: input)
        
        
        // 初始化介面
        output.initUI.bind { [weak self] _ in

            guard let self = self else { return }

            // 更新介面
            self.circleMask?.updateUI()

            self.reviewPhoto?.updateUI()
            self.reviewPhoto?.toContentCenter()
        }
        .disposed(by: disposeBag)
        
        
        // 使否正在加載中
        output.isLoading.bind { [weak self] enabled in
            self?.rotateButton.isEnabled = enabled
            self?.cropButton.isEnabled = enabled
            self?.scrollView.isUserInteractionEnabled = enabled
        }
        .disposed(by: disposeBag)
        
        // 旋轉螢幕
        output.rotateImage.flatMapLatest { [weak self] _ in
            self?.reviewPhoto?.rotateAnimation(angle: 90, duration: 0.5).materialize() ?? .empty()
        }
        .map { _ in Void() }
        .bind(to: showImageDoneTrigger)
        .disposed(by: disposeBag)
        
        //擷取圖片
        output.cropImage.do { [weak self] _ in
            
            guard let self = self else { return }

            let dstSize = self.outputImageView.frame.size
            let circleSize = self.circleMask?.circleSize ?? .zero
            let newImage = self.reviewPhoto?.createCircularAndCropImage(srcSize: circleSize, dstSize: dstSize)

            guard let imageBase64 = newImage?.base64(format: .jpeg(1)) else { return }

            self.outputImageView.image = imageBase64.imageFromBase64()
        }
        .delay(.seconds(2), scheduler: MainScheduler.instance)
        .bind(to: showImageDoneTrigger)
        .disposed(by: disposeBag)
    }
}


// MARK: 擴充方法
extension HeaderEditorViewController {
    
    // 隨機生成圖片
    func initHeaderPhoto() {
        self.reviewPhoto?.image = headerImage
    }
}
