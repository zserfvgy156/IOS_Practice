//
//  AppleLoginValidationViewModel.swift
//  Practice
//
//  Created by user on 2022/6/16.
//


import RxSwift


class AppleLoginInputValidViewModel
{
    static let minUsernameLength: Int = 5
    static let minPasswordLength: Int = 8
    
    
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
    }
    
    struct Output {
        let inputValid: Observable<Bool>
    }

    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        // output 生成
        let usernameValid = input.username.map { $0.count >= Self.minUsernameLength }.share()
        let passwordValid = input.password.map { $0.count >= Self.minPasswordLength }.share()
        let inputValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }.share()
        
        return Output (inputValid: inputValid)
    }
}
