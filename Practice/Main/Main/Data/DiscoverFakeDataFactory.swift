//
//  DiscoverFakeDataFactory.swift
//  Practice
//
//  Created by user on 2022/4/14.
//

import Foundation
import RxDataSources


class DiscoverFakeDataFactory
{
    // 生成假資料
    static func create() -> [DiscoverCollectionViewSection]
    {
        return [
        
            // MARK: section #1
            DiscoverCollectionViewSection(
                header: .init(type: .None),
                items: [
                    .init( ui: .Intro(
                        DiscoverIntroCellData(
                            imgLogoURL: "Discover/Cell/swift_logo.png",
                            introTitle: "Call to code.",
                            introContent: "WWDC22 is coming. Join us online June 6-10.",
                            readMoreText: "Read more",
                            tipText: "Latest news: WWDC22. Call to code.",
                            introIntentInfo: createDiscoverContentViewIntentInfo(),
                            tipIntentInfo: createDiscoverContentViewIntentInfo()
                        )
                    ))
                ]
            ),
            
            // MARK: section #2 "Recently published"
            DiscoverCollectionViewSection(
                header: .init(type: .Video, title: "Recently published"),
                items: [
                    .init( ui: .Video(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Articles,
                                              contentText: "Promote yours apps",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Articles))
                    )),
                    .init( ui: .Video(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Tech_Talks,
                                              contentText: "Explore unlisted app distribution",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Tech_Talks))
                    )),
                    .init( ui: .Video(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Articles,
                                              contentText: "Enable Family Sharing for your subscriptions",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Articles))
                    )),
                    .init( ui: .Video(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Tech_Talks,
                                              contentText: "Build and deploy Safari Extensions for iOS",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Tech_Talks))
                    ))
                ]
            ),
            
            // MARK: section #3 "WWDC21 highlights"
            DiscoverCollectionViewSection(
                header: .init(type: .Video, title: "WWDC21 highlights"),
                items: [
                    .init( ui: .Collect(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Articles,
                                              contentText: "Promote yours apps",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Articles))
                    )),
                    .init( ui: .Collect(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Tech_Talks,
                                              contentText: "Explore unlisted app distribution",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Tech_Talks))
                    )),
                    .init( ui: .Collect(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Articles,
                                              contentText: "Enable Family Sharing for your subscriptions",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Articles))
                    )),
                    .init( ui: .Collect(
                        DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                              classifyText: .Tech_Talks,
                                              contentText: "Build and deploy Safari Extensions for iOS",
                                              intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Tech_Talks))
                    ))
                ]
            )
        ]
    }
    
    // 生成單一假資料
    static func createTestDiscoverVideoCellData() -> DiscoverCellItem {
        return .init( ui:   .Video(DiscoverVideoCellData(imgVideoURL: "Discover/Cell/swift_logo.png",
                                                         classifyText: .Articles,
                                                         contentText: "Add Test CollectionView Item",
                                                         intentInfo: createDiscoverVideoViewIntentInfo(classifyText: .Articles))
        ))
    }
}


// MARK: - DiscoverFakeDataFactory 擴充 (跳轉頁面資訊)
extension DiscoverFakeDataFactory
{
    // 純內容頁
    static func createDiscoverContentViewIntentInfo() -> DiscoverContentViewIntentInfo
    {
        let result = DiscoverContentViewIntentInfo(
            newsTip: NSLocalizedString("fack_discover_content_newsTip", comment: ""),
            date: NSLocalizedString("fack_discover_content_date", comment: "日期"),
            title: NSLocalizedString("fack_discover_content_title", comment: "標題"),
            imgLogoURL: "Discover/Cell/swift_logo.png",
            content: NSLocalizedString("fack_discover_content_description", comment: "假內容"),
            link: (title: NSLocalizedString("fack_discover_content_link_title", comment: "標題"),
                   URL: NSLocalizedString("fack_discover_content_link_URL", comment: "連結"))
        )
        
        return result
    }
    
    // 純影片頁
    static func createDiscoverVideoViewIntentInfo(classifyText: EDiscoverVideoClassify) -> DiscoverVideoViewIntentInfo {
        
        // 播放影片
        let url = URL(string: "https://movietrailers.apple.com/movies/marvel/captain-marvel/captain-marvel-trailer-1_h480p.mov")
        let videoPlayInfo = DiscoverVideoPlayInfo(url: url, videoName: NSLocalizedString("fake_discover_video_name", comment: "檔案名稱"))
        
        // 設置分段資訊與文章
        let segmentedOverview = DiscoverVideoSegmentedOverview(title: NSLocalizedString("overview_article_title", comment: "標題"),
                                                               uploaderDate: Date(),
                                                               article: NSLocalizedString("overview_article_content", comment: "內容"),
                                                               classifyText: classifyText)
        let segmentedTranscript = DiscoverVideoSegmentedTranscript(article: NSLocalizedString("transcript_article", comment: "內容"))
        
        
        let segmenteds: [IDiscoverVideoSegmented] = [segmentedOverview , segmentedTranscript]
        
        let segmentedInfo = DiscoverVideoSegmentedInfo(segmenteds: segmenteds, defaultSegmented: .Overview)
        let segmentedContentInfo = DiscoverVideoSegmentedContentInfo(segmenteds: segmenteds)
        
        
        // 設定結果
        let sectionInfos: [IDiscoverVideoSectionInfo] = [videoPlayInfo, segmentedInfo, segmentedContentInfo]
        
        return DiscoverVideoViewIntentInfo(sectionInfos: sectionInfos)
    }
}
