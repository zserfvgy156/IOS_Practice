//
//  DiscoverContentReviewPhotoNavigationBar.swift
//  Practice
//
//  Created by user on 2022/5/4.
//


import UIKit


protocol DiscoverContentReviewPhotoNavigationBarDelegate: AnyObject
{
    func onNavigationBarBtnBackClick()
}

class DiscoverContentReviewPhotoNavigationBar
{
    unowned var navigationBar: UINavigationBar
    
    weak var delegate: DiscoverContentReviewPhotoNavigationBarDelegate?
    
    private var m_pageCount: Int
    private var m_pageNo: Int = 0
    
    
    var pageNo: Int {
        get {
            return self.m_pageNo
        }
        set {
            self.m_pageNo = newValue
            self.setTitle(pageNo: newValue, pageCount: self.pageCount)
        }
    }
    
    var pageCount: Int {
        get {
            return self.m_pageCount
        }
        set {
            self.m_pageCount = newValue
            self.setTitle(pageNo: self.m_pageNo, pageCount: newValue)
        }
    }
    
    var isHidden: Bool {
        get {
            return self.navigationBar.isHidden
        }
        set {
            self.navigationBar.isHidden = newValue
        }
    }
    
    
    init(navigationBar: UINavigationBar, pageCount: Int = 0) {
        
        self.navigationBar = navigationBar
        self.m_pageCount = pageCount
        self.pageNo = (pageCount == 0) ? 0 : 1 // 預設 “０ of 0” 標題

        initUI()
    }
    
    func initUI() {
        let backButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onBtnBackClick(_:)))
        backButton.tintColor = UIColor.systemBlue

        navigationBar.topItem?.leftBarButtonItem = backButton
    }
    
    private func setTitle(pageNo: Int, pageCount: Int) {
        navigationBar.topItem?.title = String(pageNo) + " of " + String(pageCount)
    }
    
    @objc func onBtnBackClick(_ sender: UIBarButtonItem) {
        self.delegate?.onNavigationBarBtnBackClick()
    }
}
