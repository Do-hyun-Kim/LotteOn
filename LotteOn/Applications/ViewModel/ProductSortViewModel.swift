//
//  ProductSortViewModel.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/26.
//

import RxSwift
import RxCocoa


final class ProductSortViewModel {
    
    public var didTapRankFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var didTapRowFilter: PublishSubject<Void> = PublishSubject<Void>()
    public var didTapHighFilter: PublishSubject<Void> = PublishSubject<Void>()
    
    
    
    init() {}
    
}
