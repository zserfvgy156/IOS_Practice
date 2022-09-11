//
//  DiscoverContentLinkText.swift
//  Practice
//
//  Created by user on 2022/4/29.
//


import UIKit

class DiscoverContentLinkText
{
    unowned var txtLink: UITextView
    
    
    init(txtLink: UITextView) {
        self.txtLink = txtLink
    }
    
    func setup(linkInfo: (title: String, URL: String), color: UIColor, font: UIFont) {
        let attributedString = NSMutableAttributedString(string: linkInfo.title)
        let url = URL(string: linkInfo.URL)!
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url, .font: font], range: NSMakeRange(0, linkInfo.title.count))

        self.txtLink.attributedText = attributedString
        self.txtLink.isUserInteractionEnabled = true
        self.txtLink.isEditable = false

        // Set how links should appear: blue and underlined
        self.txtLink.linkTextAttributes = [
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
}
