//
//  ViewModel.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import RxSwift
import RxCocoa
import UIKit

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
    public var prefetchImage: UIImage?
    
    public var numberOfItemsInSection: Int {
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
        let transformString = lotteShopUseCase.executeTransform(reqeustValue: numberOfItemsInSection)
        completion(transformString)
    }
    
    public func prefetchImage(index item: Int, complection: @escaping(UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
            let url = URL(string: self.entities[item].productImage)
            URLSession.shared.dataTask(with: url!) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.prefetchImage = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheFetch.shared.setObject(image, forKey: self.entities[item].productImage as NSString)
                        self.prefetchImage = image
                        complection(self.prefetchImage!)
                    }
                }
            }.resume()
        }
    }
}
