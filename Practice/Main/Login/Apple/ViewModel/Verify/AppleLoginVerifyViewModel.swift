//
//  AppleLoginVerifyViewModel.swift
//  Practice
//
//  Created by user on 2022/6/16.
//


import RxSwift


struct LoginCertificationInfo {
    let username: String
    let password: String
}

class AppleLoginVerifyViewModel {
    
    struct Input {
        let signInDidTap: Observable<Void>
        let username: Observable<String>
        let password: Observable<String>
    }
    
    struct Output {
        let isSuccess: Observable<LoginVerifyResult>
        let isError: Observable<Error>
        let isLoading: Observable<Bool>
    }
    
    
    private let isSuccessSubject: PublishSubject<LoginVerifyResult> = .init()
    private let isErrorSubject: PublishSubject<Error> = .init()
    private let isLoadingSubject: BehaviorSubject<Bool> = .init(value: false)
    
   
    private let disposebag = DisposeBag()
    
    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        // 安裝輸入相關
        setupInputs(input: input)
        
        // 返回
        return Output(
           isSuccess: self.isSuccessSubject.asObservable(),
           isError: self.isErrorSubject.asObservable(),
           isLoading: self.isLoadingSubject.asObservable()
       )
    }
    
    // 安裝輸入相關
    private func setupInputs(input: Input) {
        
        // 認證資料
        let certification = Observable.combineLatest(input.username, input.password) { LoginCertificationInfo(username: $0, password: $1) }
        
        // 登入流程
        let signIn = self.signInDidTapObservable(input: input, certification: certification)
        
        // 加載廣播
        let _ = self.isLoadingObservable(input: input, signIn: signIn)
    }
    
    
    ///  登入請求認證流程
    /// - Parameters:
    ///   - input: 外部 input
    ///   - certification: 監聽輸入帳密的被觀察者
    private func signInDidTapObservable(input: Input, certification: Observable<LoginCertificationInfo>) -> Observable<Event<LoginVerifyResult>> {
        
        let result = input.signInDidTap
            .withLatestFrom(certification)
            .flatMapLatest { LoginAPI.requestTest(info: $0).materialize() }
            .share()
        
        result.compactMap { $0.element }.asObservable()
            .bind(to: self.isSuccessSubject)
            .disposed(by: disposebag)
        
        result.compactMap { $0.error }.asObservable()
            .bind(to: self.isErrorSubject)
            .disposed(by: disposebag)
        
        return result
    }
    
    
    ///  模擬 登入後顯示 Loading
    /// - Parameters:
    ///   - input: 外部 input
    ///   - signIn:  登入請求認證的被觀察者
    private func isLoadingObservable(input: Input, signIn: Observable<Event<LoginVerifyResult>>) -> Observable<Bool> {
        
        let result = Observable.merge(input.signInDidTap.map{ _ in true }, signIn.map { _ in false })
        
        result.bind(to: isLoadingSubject)
              .disposed(by: disposebag)
        
        return result
    }
}
