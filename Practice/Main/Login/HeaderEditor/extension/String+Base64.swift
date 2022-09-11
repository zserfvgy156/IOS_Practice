//
//  String+Base64.swift
//  Practice
//
//  Created by user on 2022/7/22.
//


import UIKit


extension String {
    func imageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }

        return UIImage(data: data)
    }
}
