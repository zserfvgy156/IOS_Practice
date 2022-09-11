//
//  HightlightTextView.swift
//  Practice
//
//  Created by user on 2022/5/25.
//


import UIKit

class HightlightTextView: UITextView {
    

    private var m_searchOptions: SearchOptions?
    private var m_matches: [NSTextCheckingResult]?
    
    var focusColor: UIColor = .yellow
    var blurColor: UIColor = .lightGray
    
    
    var searchOptions: SearchOptions? {
        get {
            return self.m_searchOptions ?? nil
        }
        set {
            self.m_searchOptions = newValue
            self.m_matches = getSearchResult()
        }
    }
    
    var selectIndex: Int {
        get {
            return self.m_searchOptions?.selectIndex ?? -1
        }
        set {
            self.m_searchOptions?.selectIndex = newValue
        }
    }
    
    var searchCount: Int {
        return self.m_matches?.count ?? 0
    }
    
    var matches: [NSTextCheckingResult]? {
        return self.m_matches ?? nil
    }
    
    var currentSelectMatch: NSTextCheckingResult? {
        let isIndexValid = matches?.indices.contains(selectIndex)
        return (isIndexValid == true) ? matches?[selectIndex] : nil
    }
    
    
    func scrollToTop() {
        if self.text.count > 0 {
            let top = NSMakeRange(0, 1)
            self.scrollRangeToVisible(top)
        }
    }
    
    func scrollToBottom() {
        if self.text.count > 0 {
            let location = self.text.count - 1
            let bottom = NSMakeRange(location, 1)
            self.scrollRangeToVisible(bottom)
        }
    }
    
    func focusCurrentSelectIndex() {
        guard let matche = currentSelectMatch else { return }
        self.scrollRangeToVisible(matche.range)
    }
    
    func focusNextSelectIndex() {
        // 搜尋為 0 時，搜尋沒有意義。
        if searchCount == 0 { return }
        
        var nextIndex = selectIndex + 1
        if nextIndex >= searchCount {
            nextIndex = 0
        }
        
        moveSelectIndex(nextIndex: nextIndex)
    }
    
    func focusPreviousSelectIndex() {
        // 搜尋為 0 時，搜尋沒有意義。
        if searchCount == 0 { return }
        
        var nextIndex = selectIndex - 1
        if nextIndex < 0 {
            nextIndex = searchCount - 1
        }
        
        moveSelectIndex(nextIndex: nextIndex)
    }
    
    func moveSelectIndex(nextIndex: Int) {
        
        // 先判斷下一個索引是否正確
        let isIndexValid = matches?.indices.contains(nextIndex) ?? false
        if !isIndexValid { return }
        
        // 開始調整顏色，並移至該位置。
        if let nextMatch = matches?[nextIndex] {
            
            // 清除現有顏色
            if let matche = currentSelectMatch {
                replaceHightlight(match: matche, color: blurColor)
            }
            
            // 調整目前底色
            replaceHightlight(match: nextMatch, color: focusColor)
            
            // 開始焦點下一個搜尋文字
            self.selectIndex = nextIndex
            
            // 移動位置
            focusCurrentSelectIndex()
        }
    }
    
    //  開始
    func startSearchTextHightlight() {
        
        // 清除標記
        self.clearHightlight()
        
        guard let matches = self.matches, let options = self.searchOptions else { return }
        
        // 取得目前
        let attributedText = self.attributedText.mutableCopy() as! NSMutableAttributedString
        
        // 重新設定搜尋顏色
        for (index, match) in matches.enumerated() {
            let isBlur = (options.selectIndex == -1 ||  index != options.selectIndex)
            let color: UIColor = isBlur ? blurColor : focusColor
            let matchRange = match.range
            attributedText.addAttribute(.backgroundColor, value: color, range: matchRange)
        }
        
        self.attributedText = (attributedText.copy() as! NSAttributedString)
    }
    
    // 更新標記
    func replaceHightlight(match: NSTextCheckingResult, color: UIColor) {
        
        let range = match.range
        
        let attributedText = self.attributedText.mutableCopy() as! NSMutableAttributedString
        attributedText.removeAttribute(.backgroundColor, range: range)
        attributedText.addAttribute(.backgroundColor, value: color, range: range)
        
        self.attributedText = (attributedText.copy() as! NSAttributedString)
    }
    
    // 清除標記
    func clearHightlight() {
        // 取得目前
        let attributedText = self.attributedText.mutableCopy() as! NSMutableAttributedString
        
        // 清除目前底色
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(.backgroundColor, range: attributedTextRange)
        
        self.attributedText = (attributedText.copy() as! NSAttributedString)
    }
    
    // 顯示搜尋結果
    private func getSearchResult() -> [NSTextCheckingResult]? {
        guard let options = self.m_searchOptions else { return nil }
        
        if let regex = try? NSRegularExpression(options: options) {
            let range = NSRange(self.text.startIndex..., in: self.text)
            return regex.matches(in: self.text, options: [], range: range)
        }
        
        return nil
    }
}

extension NSRegularExpression {
  
    convenience init?(options: SearchOptions) throws {
        let searchString = options.searchString
        let isCaseSensitive = options.matchCase
        let isWholeWords = options.wholeWords
    
        let regexOption: NSRegularExpression.Options = isCaseSensitive ? [] : .caseInsensitive // 預設不區分大小寫
        let pattern = isWholeWords ? "\\b\(searchString)\\b" : searchString

        try self.init(pattern: pattern, options: regexOption)
    }
}

struct SearchOptions
{
    var searchString: String
    var matchCase: Bool
    var wholeWords: Bool
    var selectIndex: Int
    
    
    init(searchString: String, matchCase: Bool, wholeWords: Bool, selectIndex: Int = -1) {
        self.searchString = searchString
        self.matchCase = matchCase
        self.wholeWords = wholeWords
        self.selectIndex = selectIndex
    }
}
