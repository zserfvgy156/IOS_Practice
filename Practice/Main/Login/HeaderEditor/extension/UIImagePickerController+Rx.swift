//
//  UIImagePickerController+Rx.swift
//  Practice
//
//  Created by user on 2022/7/18.
//

#if os(iOS)
    
    import RxSwift
    import RxCocoa
    import UIKit

    extension Reactive where Base: UIImagePickerController {

        //圖片選擇完畢代理方法的封裝
        public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
            return delegate
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
                .map({ (a) in
                    return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
                })
        }

        //圖片取消選擇代理方法的封裝
        public var didCancel: Observable<()> {
            return delegate
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
                .map {_ in () }
        }
        
    }
    
#endif

//轉類型的函數（轉換失敗後，會發出Error）
fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
