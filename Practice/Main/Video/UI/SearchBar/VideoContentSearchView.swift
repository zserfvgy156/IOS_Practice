//
//  SearchTextView.swift
//  Practice
//
//  Created by user on 2022/5/18.
//


import UIKit


protocol VideoContentSearchViewDelegate: NSObject {
    
    func onSearchTextFieldDidChange(_ textField: UITextField)
    
    func onVideoContentSearchViewButtonPreviousClick()
    func onVideoContentSearchViewButtonNextClick()
    func onVideoContentSearchViewButtonDoneClick()
}

class VideoContentSearchView: UIView {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationItem: UINavigationItem!
    
    @IBOutlet weak var preBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    weak var delegate: VideoContentSearchViewDelegate?
    
    var textfield: SearchTextField!
    
    private var selectIndex: Int = -1
    private var searchCount: Int = 0
    
    private let textfieldHeightPadding: CGFloat = 5
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)) // 高度暫定為 50，之後會重新計算高度。
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
    
    // 修正會蓋到全局手勢區域
    // This is needed so that the inputAccesoryView is properly sized from the auto layout constraints.
    // Actual value is not important.
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    func initView() {
        // 生成場景檔
        let viewFromXib = Bundle.main.loadNibNamed("VideoContentSearchView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        
        // 修正會蓋到全局手勢
        self.autoresizingMask = .flexibleHeight
        
        // 調整本身高度
        let size = navigationBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
 
        // 設置 textfield
        let height: CGFloat = size.height - (textfieldHeightPadding * 2)
        
        self.textfield = SearchTextField(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height))
        self.textfield.borderStyle = .roundedRect
        self.textfield.returnKeyType = .search
        self.textfield.enablesReturnKeyAutomatically = true
        self.textfield.addTarget(self, action: #selector(onTextFieldDidChange(_:)), for: .editingChanged)
        self.textfield.clearButtonMode = .whileEditing
        
        self.textfield.delegate = self
        
        self.navigationItem.titleView = textfield
        
        // 加入主場景
        addSubview(viewFromXib)
        
        // 註冊相關事件
        self.preBarButtonItem.isEnabled = false
        self.nextBarButtonItem.isEnabled = false
        
        self.doneBarButtonItem.action = #selector(onButtonDoneClick)
        self.preBarButtonItem.action = #selector(onButtonPreClick)
        self.nextBarButtonItem.action = #selector(onButtonNextClick)
    }
    
    func updateSearchViewResult(selectIndex: Int, searchCount: Int) {
        
        self.selectIndex = selectIndex
        self.searchCount = searchCount
        
        
        let buttonEnabled = (searchCount > 0)
       
        self.nextBarButtonItem.isEnabled = buttonEnabled
        self.preBarButtonItem.isEnabled = buttonEnabled
        self.updateRightViewSearchState()
    }
    
    func becomeFirstResponderBySearchTextfield() {
        self.textfield.inputAccessoryView = self
        self.textfield.becomeFirstResponder()
    }
    
    func resignFirstResponderBySearchTextfield() {
        self.textfield.inputAccessoryView = nil
        self.textfield.resignFirstResponder()
    }
    
    func searchCurrentInputText() {
        delegate?.onSearchTextFieldDidChange(self.textfield)
    }
    
    private func updateRightViewSearchState() {
        
        var resultString: String = "No matches"
        
        if textfield.text?.count == 0 {
            resultString = ""
        }
        else if searchCount > 0 {
            resultString = String(selectIndex + 1) + " of " + String(searchCount)
        }
            
        textfield.rightViewLabelString = resultString
    }
    
    @objc private func onButtonDoneClick() {
        delegate?.onVideoContentSearchViewButtonDoneClick()
    }
    
    @objc private func onButtonPreClick() {
        delegate?.onVideoContentSearchViewButtonPreviousClick()
    }
    
    @objc private func onButtonNextClick() {
        delegate?.onVideoContentSearchViewButtonNextClick()
    }
    
    @objc private func onTextFieldDidChange(_ textField: UITextField) {
        delegate?.onSearchTextFieldDidChange(textField)
    }
}

extension VideoContentSearchView: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateRightViewSearchState()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfield.resignFirstResponder()
        return true
    }
}


// 左邊有搜尋的圖片
class SearchTextField: UITextField {
    
    private let paddingSpace: CGFloat = 10
    
    private let leftViewHeight: CGFloat = 34
    private let rightViewHeight: CGFloat = 34
    
    private let leftViewImageSystemName: String = "magnifyingglass"
    private let rightViewImageSystemName: String = "multiply.circle.fill"
     
    
    var rightViewLabelString: String? {
        get {
            guard let label = rightView as? UILabel else { return nil }
            return label.text
        }
        set {
            if let label = rightView as? UILabel {
                label.text = newValue
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        leftViewMode = .always
        rightViewMode = .unlessEditing
        
        let imageView = UIImageView(image: UIImage(systemName: leftViewImageSystemName))
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width / 2, height: rightViewHeight))
        label.text = text
        label.textColor = .systemGray
        label.textAlignment = .right
        
        leftView = imageView
        rightView = label
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += paddingSpace
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= paddingSpace
        return rect
    }
}
