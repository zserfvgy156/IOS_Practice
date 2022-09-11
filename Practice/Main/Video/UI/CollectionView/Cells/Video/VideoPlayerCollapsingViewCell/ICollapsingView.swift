//
//  ICollapsingView.swift
//  Practice
//
//  Created by user on 2022/5/13.
//


import UIKit


class ICollapsingView: NSObject
{
    enum State: CaseIterable {
        case expand, collapsed, unknown
        
        /** 切換狀態*/
        mutating func next() -> State {
            let all = Self.allCases
            let index = all.firstIndex(of: self)!
           
            let current = all[index]
            
            switch(current)
            {
            case .expand:
                return .collapsed
            case .collapsed:
                return .expand
            default:
                return .unknown
            }
        }
    }
    
    
    static var defaultDuration: CFTimeInterval = CFTimeInterval(0.5)
    
    var view: UIView
    
    var curState: State = State.unknown
    let srcState: State
    var collapsingDuration: CFTimeInterval = defaultDuration
    var expandingDuration: CFTimeInterval = defaultDuration
   
    
    var state: State {
        get {
            return self.curState
        }
        set {
            // 相同狀態不處理
            if self.curState == newValue { return }
            
            // 設置狀態
            self.curState = newValue
            
            // 更新狀態
            updateState()
        }
    }
    
    
    init(view: UIView, state: State = State.unknown) {
        self.view = view
        self.curState = state
        self.srcState = state
    }
    
    func reset() {
        self.curState = srcState
    }
        
    func updateState() {
    }
    
    func toLayerState(to: State) {
    }
    
    func getDuration(nextState: State) -> CFTimeInterval? {
        switch(nextState) {
        case .expand:
            return self.expandingDuration
        case .collapsed:
            return self.collapsingDuration
        case .unknown:
            return nil
        }
    }
}
