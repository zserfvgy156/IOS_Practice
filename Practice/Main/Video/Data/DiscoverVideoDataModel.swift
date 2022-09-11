//
//  DiscoverVideoContentDataModel.swift
//  Practice
//
//  Created by user on 2022/5/17.
//



class DiscoverVideoDataModel {
    
    private var m_data: [IDiscoverVideoSectionInfo]?
    
    
    var data: [IDiscoverVideoSectionInfo]?
    {
        get {
            return self.m_data
        }
        set {
            self.m_data = newValue
        }
    }
    
    var count: Int {
        guard let data = m_data else { return 0 }
        return data.count
    }
    
    
    func getItemData(item: Int) -> IDiscoverVideoSectionInfo? {
        guard let data = self.m_data else { return nil }
        if count <= item || item < 0 {return nil }
        return data[item]
    }
}
