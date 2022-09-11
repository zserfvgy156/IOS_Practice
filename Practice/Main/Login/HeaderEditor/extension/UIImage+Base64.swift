//
//  UIImage+Base64.swift
//  Practice
//
//  Created by user on 2022/7/22.
//

import UIKit


enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
    func base64(format: ImageFormat) -> String? {
        var imageData: Data?

        switch format {
        case .png: imageData = self.pngData()
        case .jpeg(let compression): imageData = self.jpegData(compressionQuality: compression)
        }
        
        return imageData?.base64EncodedString()
    }
}
