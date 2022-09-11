//
//  DiscoverIntroCollectionViewModel.swift
//  Practice
//
//  Created by user on 2022/6/23.
//

import UIKit

import RxSwift


class DiscoverIntroCollectionViewModel
{
    struct Input {
        let introTitleTapGesture: Observable<UITapGestureRecognizer>
        let logoTapGesture: Observable<UITapGestureRecognizer>
        let tipTapGesture: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let onClickIntro: Observable<Void>
        let onClickTip: Observable<Void>
    }
    
    
    // MARK: input -> output
    func transform(input: Input) -> Output {
    
        let onClickIntro = Observable.merge(input.introTitleTapGesture, input.logoTapGesture).map { _ in Void() }
        let onClickTip = input.tipTapGesture.map { _ in Void() }
        
        return Output(onClickIntro: onClickIntro,
                      onClickTip: onClickTip)
        
    }
}
