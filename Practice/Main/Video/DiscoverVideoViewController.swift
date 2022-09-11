//
//  DiscoverVideoViewController.swift
//  Practice
//
//  Created by user on 2022/5/9.
//

import UIKit
import RxSwift


protocol DiscoverVideoViewControllerDelegate: NSObject {
    func onDiscoverVideoCollectChanged(indexPath: IndexPath, isCollect: Bool)
}

class DiscoverVideoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 挾帶的參數
    var intentInfo: DiscoverVideoViewIntentInfo?
    
    //委派
    weak var delegate: DiscoverVideoViewControllerDelegate?
    
    //元件
    private var navigationBar: DiscoverVideoViewNavigationBar?
    private var customCollectionView: DiscoverVideoCollectionViewWrapper?
    private var searchInputAccessoryView: VideoSearchInputAccessoryView?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // 導航欄
        self.navigationBar = DiscoverVideoViewNavigationBar(navigationItem: self.navigationItem)
        
        // 導航欄
        // (收藏)
        let isCollect: Bool = self.intentInfo?.cellInfo?.isCollect ?? false
        if let collectNavigationItem = self.navigationBar?.collectNavigationItem {
            collectNavigationItem.isCollect = isCollect
            collectNavigationItem.delegate = self
        }
        
        // (搜尋)
        self.navigationBar?.searchNavigationItem.delegate = self
    
        
        // 清單
        self.customCollectionView = DiscoverVideoCollectionViewWrapper(collectionView: collectionView)
        self.customCollectionView?.data = intentInfo?.sectionInfos
        self.customCollectionView?.reload()
        
        // 搜尋行為
        self.searchInputAccessoryView = VideoSearchInputAccessoryView()
        self.searchInputAccessoryView?.delegate = self
        self.searchInputAccessoryView?.inputResponderDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let cellInfo = self.intentInfo?.cellInfo else { return }
        self.delegate?.onDiscoverVideoCollectChanged(indexPath: cellInfo.cellIndexPath, isCollect: cellInfo.isCollect)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 設定鍵盤監聽
        KeyboardService.singleton.add(delegate: self)
        
        // 螢幕旋轉處理
        self.customCollectionView?.didRotateState()
    }
    
    
    // MARK: 螢幕旋轉相關處理
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.customCollectionView?.didRotateState()
    }
    
    
    // MARK: 客製化 inputAccessoryView
    override var canBecomeFirstResponder: Bool {
        return self.searchInputAccessoryView?.isCanBecomeFirstResponder ?? false
    }

    override var inputAccessoryView: UIView? {
        let isSearch = self.navigationBar?.searchNavigationItem.isSearching ?? false
        return isSearch ? self.searchInputAccessoryView : nil
    }
}


// MARK: - 設定客製化鍵盤
extension DiscoverVideoViewController: VideoSearchInputAccessoryViewResponderDelegate {
    
    func onSearchInputAccessoryBecomeFirstResponder() {
        self.becomeFirstResponder()
    }
    
    func onSearchInputAccessoryResignFirstResponder() {
        self.resignFirstResponder()
        
        // 清除焦點
        customCollectionView?.transcriptContentTextView?.clearHightlight()
    }
}


// MARK: - 搜尋 view 監聽
extension DiscoverVideoViewController: VideoContentSearchViewDelegate {
    
    func onSearchTextFieldDidChange(_ textField: UITextField) {
        guard let hightlightTextView = self.customCollectionView?.transcriptContentTextView, let searchString = textField.text else { return }
        
        // 開始搜尋
        let selectIndex = 0
        let options = SearchOptions(searchString: searchString, matchCase: false, wholeWords: false, selectIndex: selectIndex)
        hightlightTextView.searchOptions = options
        hightlightTextView.startSearchTextHightlight()
        hightlightTextView.focusCurrentSelectIndex()
        
        // 更新搜尋狀態
        updateSearchViewState(selectIndex: hightlightTextView.selectIndex, searchCount: hightlightTextView.searchCount)
    }

    func onVideoContentSearchViewButtonPreviousClick() {
        guard let hightlightTextView = self.customCollectionView?.transcriptContentTextView else { return }
        hightlightTextView.focusPreviousSelectIndex()
        
        // 更新搜尋狀態
        updateSearchViewState(selectIndex: hightlightTextView.selectIndex, searchCount: hightlightTextView.searchCount)
    }
    
    func onVideoContentSearchViewButtonNextClick() {
        guard let hightlightTextView = self.customCollectionView?.transcriptContentTextView else { return }
        hightlightTextView.focusNextSelectIndex()
        
        // 更新搜尋狀態
        updateSearchViewState(selectIndex: hightlightTextView.selectIndex, searchCount: hightlightTextView.searchCount)
    }

    func onVideoContentSearchViewButtonDoneClick() {
        self.navigationBar?.searchNavigationItem.isSearching = false
    }
    
    // 更新目前顯示狀態
    private func updateSearchViewState(selectIndex: Int, searchCount: Int) {
        self.searchInputAccessoryView?.updateSearchViewResult(selectIndex: selectIndex, searchCount: searchCount)
    }
}


// MARK: - 導航欄收藏
extension DiscoverVideoViewController: DiscoverCollectNavigationItemDelegate {
   
    func onCollectNavigationItemChanged(isCollect: Bool, defaultAlertController: UIAlertController?) {
       
        // 更新 cell
        self.intentInfo?.cellInfo?.isCollect = isCollect
        
        // 顯示提示
        if let alert = defaultAlertController {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - 導航欄搜尋
extension DiscoverVideoViewController: DiscoverSearchNavigationItemDelegate {
    
    func onSearchNavigationItemChanged(isSearching: Bool) {
        self.searchInputAccessoryView?.setEnabled(isEnabled: isSearching)
    }
}


// MARK: - 監聽鍵盤變化
extension DiscoverVideoViewController: IKeyboardServiceDelegate {
    
    func onKeyboardWillShow(_ notification: NSNotification, _ arg: KeyboardServiceArg) {
        updateCollectionCellState(notification: notification)
    }
    
    func onKeyboardWillHide(_ notification: NSNotification, _ arg: KeyboardServiceArg) {
        updateCollectionCellState(notification: notification)
    }
    
    private func updateCollectionCellState(notification: NSNotification) {
        
        let safeAreaInsetBottom = view.safeAreaInsets.bottom
        
        animateWithKeyboard(notification: notification, safeAreaInsetBottom: safeAreaInsetBottom) { [weak self] (safeAreaInsetBottom, keyboardDuration) in
            
            guard let strongSelf = self else { return }
            
            // 設定搜尋狀態
            let isSearching = strongSelf.navigationBar?.searchNavigationItem.isSearching ?? false
            strongSelf.customCollectionView?.updateCollapsingState(isSearching: isSearching, duration: keyboardDuration)
            strongSelf.customCollectionView?.updateKeyboardState(safeAreaHeight: safeAreaInsetBottom)
            
            // 註冊點擊事件
            if isSearching {
                let tapGestureReconizer = UITapGestureRecognizer(target: strongSelf, action: #selector(strongSelf.onTranscriptContentTap))
                strongSelf.customCollectionView?.transcriptContentTextView?.addGestureRecognizer(tapGestureReconizer)
                strongSelf.searchInputAccessoryView?.searchCurrentInputText()
            }
        }
    }
    
    private func animateWithKeyboard(notification: NSNotification, safeAreaInsetBottom: CGFloat,
                                     animations: ((_ safeAreaInsetBottom: CGFloat, _ keyboardDuration: Double) -> Void)?) {
        
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
            
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // 生成動畫
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            animations?(safeAreaInsetBottom, duration)
        }
        
        // 開始動畫
        animator.startAnimation()
    }
    
    // 註冊處理點擊事件
    @objc private func onTranscriptContentTap() {
        
        guard let hightlightTextView = self.customCollectionView?.transcriptContentTextView else { return }

        if hightlightTextView.selectedTextRange == nil || hightlightTextView.selectedTextRange?.isEmpty == true {
            self.navigationBar?.searchNavigationItem.isSearching = false
        }
        else {
            hightlightTextView.selectedTextRange = nil
            hightlightTextView.resignFirstResponder()
        }
    }
}
