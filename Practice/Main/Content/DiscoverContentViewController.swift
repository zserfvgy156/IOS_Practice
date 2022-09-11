//
//  DiscoverContentViewController.swift
//  Practice
//
//  Created by user on 2022/4/19.
//

import UIKit


class DiscoverContentViewController: UIViewController {

    @IBOutlet weak var lbNews: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtLink: UITextView!
    
    
    // 挾帶的參數
    var intentInfo: DiscoverContentViewIntentInfo?
    
    //元件
    private var linkText: DiscoverContentLinkText?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 超連結
        self.linkText = DiscoverContentLinkText(txtLink: self.txtLink)
        
        // 初始化面版
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func initView() {
        guard let intentInfo = self.intentInfo else { return }  // 顯示錯誤頁面
        
        self.lbNews.text = intentInfo.newsTip
        self.lbDate.text = intentInfo.date
        self.lbTitle.text = intentInfo.title
        self.imgPhoto.image = UIImage(named: intentInfo.imgLogoURL)
        self.txtDescription.text = intentInfo.content
        
        guard let font = txtDescription.font else { return }
        
        let link = intentInfo.link
        self.linkText?.setup(linkInfo: link, color: .blue, font: font)
        
        // 註冊點擊事件
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onImgPhotoClicked))
        self.imgPhoto.addGestureRecognizer(tapGestureRecognizer)
    }
   
    @objc func onImgPhotoClicked(_ sender: Any) {

        let previewPhotoView = DiscoverContentReviewPhotoView()
        
        // 假資料，可以用 self.intentInfo 取得資料，暫時模擬。
        var test: [UIImage] = [UIImage]()
        test.append(UIImage(named: "Discover/Cell/swift_logo.png")!)
        test.append(UIImage(named: "Discover/Iphone13.png")!)
        
        previewPhotoView.setupPage(srcImage: test)
        
        //新增 view
        self.navigationController?.view.addSubview(previewPhotoView)
    }
}
