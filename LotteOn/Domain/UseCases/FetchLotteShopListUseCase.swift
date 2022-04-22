//
//  FetchLotteShopListUseCase.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import Foundation


protocol FetchLotteShopUseCase {
    func execute(completion: @escaping(Result<[ShopList],Error>) -> Void)
    func executeTransform(reqeustValue: Int) -> String
}



final class DefaultLotteShopUseCase: FetchLotteShopUseCase {
    
    private let lotteRepository: ShopListRepository
    
    init(lotteRepository: ShopListRepository) {
        self.lotteRepository = lotteRepository
    }
    
    func execute(completion: @escaping (Result<[ShopList], Error>) -> Void) {
        
        return lotteRepository.fetchShopList { result in
            if case .success = result {
                completion(result)
            }
        }
    }
    
    func executeTransform(reqeustValue: Int) -> String {
        return lotteRepository.fetchStringTransform(transform: reqeustValue)
    }
}


struct RequestValue {
    var value: ShopList
}
