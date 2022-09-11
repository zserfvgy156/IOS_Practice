//
//  DiscoverData.swift
//  Practice
//
//  Created by user on 2022/4/15.
//

import Foundation
import RxDataSources


// MARK: - 要綁定的 cell 內容
protocol DiscoverCellDataBase {
    associatedtype IntentType: DiscoverCellIntentModel
    var intentModel: IntentType { get }
}

protocol DiscoverCellDataCollect {
    var isCollect: Bool { get set }
}

class DiscoverIntroCellData: DiscoverCellDataBase {

    var imgLogoURL: String

    var introTitle: String
    var introContent: String
    var readMoreText: String

    var tipText: String
    
    var intentModel: DiscoverIntroCellIntentModel


    init(imgLogoURL: String, introTitle: String, introContent: String, readMoreText: String, tipText: String, introIntentInfo: DiscoverContentViewIntentInfo, tipIntentInfo: DiscoverContentViewIntentInfo)
    {
        self.imgLogoURL = imgLogoURL
        self.introTitle = introTitle
        self.introContent = introContent
        self.readMoreText = readMoreText
        self.tipText = tipText

        self.intentModel = .init(introIntentInfo: introIntentInfo, tipIntentInfo: tipIntentInfo)
    }
}

class DiscoverVideoCellData: DiscoverCellDataBase, DiscoverCellDataCollect {

    var imgVideoURL: String
    var classifyText: EDiscoverVideoClassify
    var contentText: String
    
    var isCollect: Bool = false

    var intentModel: DiscoverVideoCellIntentModel


    init(imgVideoURL: String, classifyText: EDiscoverVideoClassify, contentText: String, intentInfo: DiscoverVideoViewIntentInfo)
    {
        self.imgVideoURL = imgVideoURL
        self.classifyText = classifyText
        self.contentText = contentText

        self.intentModel = .init(intentInfo: intentInfo)
    }
}



// MARK: - 要綁定的 cell 內容類型
enum DiscoverCellStyle {
    case Intro(DiscoverIntroCellData)
    case Video(DiscoverVideoCellData)
    case Collect(DiscoverVideoCellData)
}

extension DiscoverCellStyle {
    
    mutating func IntroCell(_ body: (inout DiscoverIntroCellData) -> Void) -> Void {
        if case .Intro(var item) = self {
            body(&item)
        }
    }
    
    mutating func videoCell(_ body: (inout DiscoverVideoCellData) -> Void) -> Void {
        
        switch self {
        case .Video(var item), .Collect(var item):
            body(&item)
        default:
            break
        }
    }
}


// MARK: - 給 rxDataSource 綁定的規格
struct DiscoverCellItem {

    var id: String = UUID().uuidString
    var date: Date = Date()

    var ui: DiscoverCellStyle


    init(ui: DiscoverCellStyle) {
        self.ui = ui
    }
}

extension DiscoverCellItem: IdentifiableType, Equatable {

    typealias Identity = String

    var identity: String {
        return id
    }

    static func == (lhs: DiscoverCellItem, rhs: DiscoverCellItem) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date
    }
}
