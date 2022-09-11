//
//  UIImagePickerController+RxCreate.swift
//  Practice
//
//  Created by user on 2022/7/18.
//


import UIKit
import RxSwift
import RxCocoa


//取消指定視圖控制器函數
func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

//對UIImagePickerController進行Rx擴展
extension Reactive where Base: UIImagePickerController {
    
    //用於創建並自動顯示圖片選擇控制器的靜態方法
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        
        //返回可觀察序列
        return Observable.create { [weak parent] observer in
            
            //初始化一個圖片選擇控制器
            let imagePicker = UIImagePickerController()
            
            //不管圖片選擇完畢還是取消選擇，都會發出.completed事件
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            //設置圖片選擇控制器初始參數，參數不正確則發出.error事件
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            //判斷parent是否存在，不存在則發出.completed事件
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            //彈出控制器，顯示界面
            parent.present(imagePicker, animated: animated, completion: nil)
            //發出.next事件（攜帶的是控制器對象）
            observer.on(.next(imagePicker))
            
            //銷燬時自動退出圖片控制器
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
}
