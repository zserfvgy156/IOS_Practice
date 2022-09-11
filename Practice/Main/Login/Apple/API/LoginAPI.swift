//
//  LoginAPI.swift
//  Practice
//
//  Created by user on 2022/6/17.
//

import Foundation
import RxSwift


class LoginAPI {
    
    enum LoginAPIError: Error {
        case unknown, passwordError
    }
    

    static func requestTest(info: LoginCertificationInfo) -> Observable<LoginVerifyResult> {
        
        return .create { [info] (observer) -> Disposable in
            
            // 模擬網路請求
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                if Bool.random() {
                    let result: LoginVerifyResult = LoginVerifyResult(username: info.username, password: info.password)
                    observer.onNext(result)
                }
                else {
                    observer.onError(LoginAPI.LoginAPIError.passwordError)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
