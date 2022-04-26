//
//  FilterViewModel.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/26.
//

import Foundation



final class FilterViewModel {
    
    public var storeEntities: Store = Store()
    public var providerEntities: [ShopList] = [ShopList]()
    
    
    public var numberOfItemsInSection: Int {
        return storeEntities.name.count
    }
    
    public var productCount: String?
    

    
    
    public func selectProductCount(index: Int) -> [ShopList] {
        let filterData = providerEntities.filter {$0.divisionNumber == String(index)}
        productCount = transFormNumber(count: filterData.count)
        return filterData
    }
   
    public func transFormNumber(count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count))!
    }
    
}



struct Store {
    var name: [String]
    
    init() {
        self.name = ["롯데ON","롯데백화점","롯데마트","룹스","하이마트","롯데홈쇼핑"]
    }
}
