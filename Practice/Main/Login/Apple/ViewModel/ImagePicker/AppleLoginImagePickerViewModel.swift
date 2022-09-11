//
//  AppleLoginImagePickerViewModel.swift
//  Practice
//
//  Created by user on 2022/7/18.
//


import RxSwift
import RxCocoa
import UIKit


class AppleLoginImagePickerViewModel {
    
    struct Input {
        let selectImageDone: Observable<Event<UIImage?>>
    }
    
    struct Output {
        let pickImageResult: Observable<UIImage?>
    }
    
    
    private let pickImageResult: PublishSubject<UIImage?> = .init()
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        // 需要註冊
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        
        // 輸入結束
        setupInput(input: input)
    
        // 返回輸出
        return Output(
            pickImageResult: pickImageResult.asObservable()
        )
    }
    
    private func setupInput(input: Input) {
        
        input.selectImageDone.map { event in
            event.element ?? nil
        }
        .bind(to: pickImageResult)
        .disposed(by: disposeBag)
    }
}


// 圖片選擇控制器（UIImagePickerController）創建一個關於圖片選擇的代理委託
class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
  
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}
