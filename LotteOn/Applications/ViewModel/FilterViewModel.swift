//
//  FilterViewModel.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/26.
//

import Foundation



final class FilterViewModel {
    
    public var storeEntities: StoreList = StoreList()
    public var providerEntities: [ShopList] = [ShopList]()
    
    
    public var numberOfItemsInSection: Int {
        return storeEntities.name.count
    }
    
    public var indexPath: [Int] = []
    
    public var productCount: String?
    

    
    
    public func selectProductCount(index: [Int]) -> [ShopList] {
        var filterData: [ShopList] = []
        
        let _ = index.forEach { item in
            filterData.append(contentsOf: providerEntities.filter{ $0.divisionNumber == String(item) })
        }
        productCount = transFormNumber(count: filterData.count)
        
        return filterData
    }
   
    public func transFormNumber(count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count))!
    }
    
}
