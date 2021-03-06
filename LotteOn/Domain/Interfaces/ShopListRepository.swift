//
//  ShopListRepository.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import Foundation



protocol ShopListRepository {
    func fetchShopList(completion: (Result<[ShopList],Error>) -> Void)
    func fetchStringTransform(transform: Int) -> String
}


final class DefaultShopListRepository: ShopListRepository {
    
    func fetchShopList(completion: (Result<[ShopList], Error>) -> Void) {
        let decoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "product_list", withExtension: "json"), let data = try? Data(contentsOf: url), let result = try? decoder.decode([ShopList].self, from: data) else { return }
        completion(.success(result))
    }
    
    func fetchStringTransform(transform: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: transform))!
    }
    
}

