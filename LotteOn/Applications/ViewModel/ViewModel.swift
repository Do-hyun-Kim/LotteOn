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
    
    public var didTapAllFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var didTapRankFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var lotteShopUseCase: FetchLotteShopUseCase
    
    
    init(lotteShopUseCase: FetchLotteShopUseCase) {
        self.lotteShopUseCase = lotteShopUseCase
    }
    
}
