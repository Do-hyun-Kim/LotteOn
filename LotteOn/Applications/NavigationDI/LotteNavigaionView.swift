//
//  LotteNavigaionView.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import UIKit

//MARK: DI

final class LotteNavigaionView {
    
    //MARK: Property
    
    public let lotteController: UINavigationController
    public let controllerDI: LotteNaviationDI
    
    
    //MARK: Init
    
    init(lotteController: UINavigationController, controllerDI: LotteNaviationDI) {
        self.lotteController = lotteController
        self.controllerDI = controllerDI
        configure()
    }
    
    //MARK: Configure
    
    public func configure() {
        
        lotteController.navigationBar.topItem?.title = controllerDI.lotteTitle
        lotteController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: controllerDI.lotteTitleColor ?? UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        lotteController.navigationBar.shadowImage = UIImage()

        guard controllerDI.lotteRightBarisHidden else {
            let lotteRightBarItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(didTapCancelButton))
            lotteRightBarItem.tintColor = .gray
            lotteController.navigationBar.topItem?.rightBarButtonItem = lotteRightBarItem
            return
        }
    }
    
    //MARK: Action
    
    @objc
    public func didTapCancelButton() {
        
    }

}
