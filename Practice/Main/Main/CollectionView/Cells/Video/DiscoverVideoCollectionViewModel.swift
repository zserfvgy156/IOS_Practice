//
//  DiscoverVideoCollectionViewModel.swift
//  Practice
//
//  Created by user on 2022/6/24.
//

import UIKit

import RxSwift


class DiscoverVideoCollectionViewModel
{
    struct Input {
        let itemTapGesture: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let onClickItem: Observable<Void>
    }
    
    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        let onClickItem = input.itemTapGesture.map {_ in Void() }.asObservable()
        
        return Output(onClickItem: onClickItem)
    }
}
