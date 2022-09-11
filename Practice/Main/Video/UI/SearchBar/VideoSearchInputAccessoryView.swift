//
//  SearchVideoContentBehavior.swift
//  Practice
//
//  Created by user on 2022/5/26.
//


import UIKit


protocol VideoSearchInputAccessoryViewResponderDelegate: NSObject {
    func onSearchInputAccessoryBecomeFirstResponder()
    func onSearchInputAccessoryResignFirstResponder()
}


class VideoSearchInputAccessoryView: VideoContentSearchView
{
    var isCanBecomeFirstResponder: Bool = false
    
    weak var inputResponderDelegate: VideoSearchInputAccessoryViewResponderDelegate?
    
    
    func setEnabled(isEnabled: Bool) {

        if isCanBecomeFirstResponder == isEnabled {
            return
        }
        
        isCanBecomeFirstResponder = isEnabled
        
        if isEnabled {
            self.inputResponderDelegate?.onSearchInputAccessoryBecomeFirstResponder()
            becomeFirstResponderBySearchTextfield()
        } else {
            self.inputResponderDelegate?.onSearchInputAccessoryResignFirstResponder()
            resignFirstResponderBySearchTextfield()
        }
    }
}
