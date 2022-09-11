//
//  KeyboardService.swift
//  Practice
//
//  Created by user on 2022/5/24.
//


import UIKit
import RxSwift

protocol IKeyboardServiceDelegate: AnyObject
{
    func onKeyboardWillShow(_ notification: NSNotification, _ arg: KeyboardServiceArg)
    func onKeyboardWillHide(_ notification: NSNotification, _ arg: KeyboardServiceArg)
}

// 預留參數
struct KeyboardServiceArg
{
    init() {
    }
}

struct KeyboardServiceDelegateElement
{
    var arg: KeyboardServiceArg
    weak var delegate: IKeyboardServiceDelegate?
    
    
    init(delegate: IKeyboardServiceDelegate, arg: KeyboardServiceArg) {
        self.delegate = delegate
        self.arg = arg
    }
}

class KeyboardService: NSObject
{
    static var singleton = KeyboardService()
    
    var measuredSize: CGRect = .zero
    
    private var elements: [KeyboardServiceDelegateElement] = []
    
    
    @objc class func keyboardHeight() -> CGFloat {
        let keyboardSize = KeyboardService.keyboardSize()
        return keyboardSize.size.height
    }

    @objc class func keyboardSize() -> CGRect {
        return singleton.measuredSize
    }
    
    
    override init() {
        super.init()
        
        // 鍵盤監聽
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        
        elements.removeAll()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - 外部事件註冊
    
    /// 加入監聽註冊
    /// - Parameters:
    ///   - delegate: 委派
    ///   - arg: 預留參數
    func add(delegate: IKeyboardServiceDelegate, arg: KeyboardServiceArg? = nil) {
        let callback = KeyboardServiceDelegateElement(delegate: delegate, arg: arg ?? KeyboardServiceArg())
        elements.append(callback)
    }
    
    /// 移除監聽
    /// - Parameter delegate: 委派
    func remove(delegate: IKeyboardServiceDelegate) {
        elements.removeAll(where: { $0.delegate === delegate } )
    }
    
    
    // MARK: - 鍵盤監聽回呼
    @objc private func keyboardWillShow(_ notification: NSNotification) {
    
        // 安裝鍵盤高度
        setupKeyboardHeight(notification: notification)
        
        // 回乎
        for element in elements {
            element.delegate?.onKeyboardWillShow(notification, element.arg)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
       
        // 高度清空
        measuredSize = .zero
        
        // 回乎
        for element in elements {
            element.delegate?.onKeyboardWillHide(notification, element.arg)
        }
    }
    
    private func setupKeyboardHeight(notification: NSNotification) {
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            measuredSize = value.cgRectValue
        }
    }
}
