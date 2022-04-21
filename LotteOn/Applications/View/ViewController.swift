//
//  ViewController.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel: ViewModel = ViewModel(lotteShopUseCase: DefaultLotteShopUseCase(lotteRepository: DefaultShopListRepository()))
                                    
                                                 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    //MARK: configure
    
    private func configure() {
        view.backgroundColor = .white
        viewModel.lotteShopUseCase.execute { result in
            print("value Check \(result)")
        }
        
    }


}

