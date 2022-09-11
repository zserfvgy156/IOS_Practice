//
//  HeaderEditorViewModel.swift
//  Practice
//
//  Created by user on 2022/7/20.
//

import RxSwift


class HeaderEditorViewModel {
    
    
    struct Input {
        let firstViewDidLayoutSubviews: Observable<Void>
        let cropButtonTap: Observable<Void>
        let rotateButtonTap: Observable<Void>
        let showImageDoneTrigger: Observable<Void>
        
    }
    
    struct Output {
        let initUI: Observable<Void>
        let cropImage: Observable<Void>
        let rotateImage: Observable<Void>
        let isLoading: Observable<Bool>
    }
    

    private let isLoading: BehaviorSubject<Bool> = .init(value: false)
    
    private let disposeBag: DisposeBag = .init()
    
    
    
    // MARK: input -> output
    func transform(input: Input) -> Output {
        

        // 安裝輸入
        setupInput(input: input)
        
        // 返回輸出
        return .init(initUI: input.firstViewDidLayoutSubviews.asObservable(),
                     cropImage: input.cropButtonTap.asObservable(),
                     rotateImage: input.rotateButtonTap.asObservable(),
                     isLoading: isLoading.asObservable()
        )
    }
    
    
    func setupInput(input: Input) {
        
        // 判斷按鈕是否可以點擊
        Observable.merge(
            input.firstViewDidLayoutSubviews.map { true },
            Observable.merge(input.cropButtonTap, input.rotateButtonTap).map { false },
            input.showImageDoneTrigger.map { true }
        )
        .bind(to: isLoading)
        .disposed(by: disposeBag)
    }
}
