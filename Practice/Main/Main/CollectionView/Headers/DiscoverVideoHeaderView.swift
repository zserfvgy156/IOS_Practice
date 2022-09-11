//
//  DiscoverVideoHeaderView.swift
//  Practice
//
//  Created by user on 2022/4/14.
//

import UIKit

class DiscoverVideoHeaderView: UICollectionReusableView {

    @IBOutlet weak var txtTitle: UILabel!
    
    
    var title: String? {
        set {
            self.txtTitle.text = newValue
        }
        get {
            return self.txtTitle.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
