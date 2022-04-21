//
//  LotteNaivagionConstruction.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import UIKit

//MARK: Interface

protocol LotteNaviationDI {
    var lotteTitle: String? {get set}
    var lotteTitleColor: UIColor? {get set}
    var lotteRightBarisHidden: Bool {get set}
}



final class LotteNaivagionConstruction: LotteNaviationDI {
    
    //MARK: Property
    
    var lotteTitle: String?
    var lotteTitleColor: UIColor?
    var lotteRightBarisHidden: Bool
    
    //MARK: Init
    
    init(lotteRightBarisHidden: Bool) {
        self.lotteRightBarisHidden = lotteRightBarisHidden
    }
    
    
    init(lotteTitle:String?, lotteTitleColor: UIColor?) {
        self.lotteTitle = lotteTitle
        self.lotteTitleColor = lotteTitleColor
        self.lotteRightBarisHidden = false
    }
}
