//
//  ViewModel.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import RxSwift
import RxCocoa


protocol ViewModelType {
    var didTapAllFilter: PublishSubject<Void> {get set}
    var didTapRankFilter: PublishSubject<Void> {get set}
}


final class ViewModel: ViewModelType {
    
    //MARK: Property
    
    public var didTapAllFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var didTapRankFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var lotteShopUseCase: FetchLotteShopUseCase
    public var entities: [ShopList] = []
    
    public var count: Int {
        return entities.count
    }
    
    init(lotteShopUseCase: FetchLotteShopUseCase) {
        self.lotteShopUseCase = lotteShopUseCase
        appendEntities()
    }
    
    
    public func appendEntities() {
        lotteShopUseCase.execute { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let value):
                self.entities = value
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func bindTotalCount(completion: @escaping (String) -> Void) {
        let transformString = lotteShopUseCase.executeTransform(reqeustValue: count)
        completion(transformString)
    }
    
}
