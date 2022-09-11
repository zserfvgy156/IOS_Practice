//
//  AppleLoginViewModel.swift
//  Practice
//
//  Created by user on 2022/6/21.
//


import RxSwift
import RxCocoa
import UIKit


class AppleLoginViewModel
{
    struct Input {
        let inputValid: Observable<Bool>
        let isLoading: Observable<Bool>
    }
    
    struct Output {
        let signInButtonEnabled: Observable<Bool>
    }
    

    var inputValidViewModel: AppleLoginInputValidViewModel = .init()   // 處理輸入啟用問題
    var verifyViewModel: AppleLoginVerifyViewModel = .init()           // 認證帳密
    var imagePickerViewModel: AppleLoginImagePickerViewModel = .init() // 大頭貼相關處理

    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        let signInButtonEnabled = Observable.combineLatest(input.inputValid, input.isLoading){ $0 == true && $1 == false }
        
        return Output (signInButtonEnabled: signInButtonEnabled)
    }
}
