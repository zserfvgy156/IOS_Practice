//
//  AppleLoginViewController.swift
//  Practice
//
//  Created by user on 2022/6/13.
//

import UIKit
import RxSwift
import RxCocoa


class AppleLoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var headerCircleImageView: CircleImageView!
    @IBOutlet weak var commitButton: UIButton!
    
    
    var viewModel: AppleLoginViewModel = AppleLoginViewModel()
    
    var disposeBag = DisposeBag()
    
    
    // 頭貼點擊事件
    private lazy var headerTap: UITapGestureRecognizer = {
        let click = UITapGestureRecognizer()
        headerCircleImageView.addGestureRecognizer(click)
        headerCircleImageView.isUserInteractionEnabled = true
        return click
    }()
    
    
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 綁定 viewModel
        bindViewModel()
        
        // 註冊點擊事件
        setupViewTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // 顯示視窗文案
    private func getDialogContent(result: LoginVerifyResult? = nil, error: Error? = nil) -> String {
        
        if let result = result {
            let srcContent: String = NSLocalizedString("dialog_content_login_success", comment: "登入成功")
            return String(format: srcContent, result.username, result.password)
        }
        
        if let srcError = error as? LoginAPI.LoginAPIError {
            switch srcError {
            case .passwordError:
                return NSLocalizedString("dialog_content_login_error_password", comment: "密碼錯誤")
            default:
                return NSLocalizedString("dialog_content_login_error_unknown", comment: "未知錯誤")
            }
        }
        
        return ""
    }
    
    // 顯示視窗 (可以寫成公版)
    private func showDialog(content: String?) {
        
        guard let content = content else {
            return
        }

        
        let title: String = NSLocalizedString("dialog_default_title", comment: "提示")

        let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - view 的點擊事件
extension AppleLoginViewController {
    
    private func setupViewTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onRootViewClicked))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func onRootViewClicked() {
        // 關閉編輯
        view.endEditing(true)
    }
}


// MARK: - 綁定事件
extension AppleLoginViewController {
    
    // 綁定 viewModel
    private func bindViewModel() {
        
        // MARK: 安裝 AppleLoginVerifyViewModel
        let verifyOutputs = viewModel.verifyViewModel
            .transform(input: .init(
                signInDidTap: commitButton.rx.tap.asObservable(),
                username: accountTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable()
            )
        )
        
        // 登入成功
        verifyOutputs
            .isSuccess
            .subscribe(onNext: { [weak self] (result) in
        
                let content: String? = self?.getDialogContent(result: result)
                self?.showDialog(content: content)
            })
            .disposed(by: disposeBag)
        
        // 登入失敗
        verifyOutputs
            .isError
            .subscribe(onNext: { [weak self] (error) in
        
                let content: String? = self?.getDialogContent(result: nil, error: error)
                self?.showDialog(content: content)
            })
            .disposed(by: disposeBag)
        
        // 監聽加載狀態
        verifyOutputs
            .isLoading
            .subscribe(onNext: { [weak self] (isLoading) in
        
                if isLoading {
                    self?.accountTextField.resignFirstResponder()
                    self?.passwordTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        
        // MARK: 安裝 AppleLoginInputValidViewModel
        let inputValidOutputs = viewModel.inputValidViewModel
            .transform(input: .init(
                username: accountTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable()
            )
        )
        
        
        // MARK: 安裝 AppleLoginImagePickerViewModel
        
        let selectImageDone = headerTap.rx.event
            .flatMapLatest { [weak self] _ in
                AppleLoginViewController.createHeaderSelectDialogObservable(viewController: self).materialize()
            }
            .share()
        
       
        let imagePickerOutputs = viewModel.imagePickerViewModel.transform(input: .init(selectImageDone: selectImageDone))
        imagePickerOutputs.pickImageResult.bind(onNext: { [weak self] image in
            
            guard let self = self, let image = image else { return }
            
            // 進入下一頁
            let viewController = HeaderEditorViewController()
            viewController.headerImage = image
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        .disposed(by: disposeBag)
        
        
        // MARK: 安裝 AppleLoginViewModel
        let outputs = viewModel
            .transform(input: .init(
                inputValid: inputValidOutputs.inputValid,
                isLoading: verifyOutputs.isLoading
            )
        )
        
        // 監聽登入按鈕事件
        outputs
            .signInButtonEnabled
            .bind(to: commitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}


extension AppleLoginViewController {
    
    static func createHeaderSelectDialogObservable(viewController: UIViewController?) -> Observable<UIImage?> {
        return Observable<UIImagePickerController.SourceType>.create { [weak viewController] observer in
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
                observer.onNext(.camera)
                observer.onCompleted()
            }))
            alert.addAction(UIAlertAction(title: "從圖庫選擇", style: .default, handler: { _ in
                observer.onNext(.photoLibrary)
                observer.onCompleted()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            viewController?.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        .flatMapLatest { [weak viewController] type in
            return UIImagePickerController.rx.createWithParent(viewController) { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
            }
            .flatMap {
                $0.rx.didFinishPickingMediaWithInfo
            }
            .take(1)
        }
        .map { info in
            return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        }
    }
}
