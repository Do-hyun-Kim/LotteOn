//
//  FetchLotteShopListUseCase.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import Foundation


protocol FetchLotteShopUseCase {
    func execute(completion: @escaping(Result<[ShopList],Error>) -> Void)
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
}


struct RequestValue {
    var value: ShopList
}
