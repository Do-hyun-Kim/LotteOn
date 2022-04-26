//
//  StoreCollectionViewCell.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/26.
//

import UIKit
import SnapKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    //MARK: Property
    
    static let reuseIdentifier = String(describing: StoreCollectionViewCell.self)
    var storeButtonAction : (() -> ())?

    
    public let storeButton: UIButton = {
        $0.setTitleColor(.lightGray, for: .normal)
        $0.layer.borderWidth = 0.1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        $0.layer.cornerRadius = 5
        $0.setImage(UIImage(named: "checkedOff"), for: .normal)
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapStoreButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Configure
    
    private func configure() {
        addSubview(storeButton)
        
        storeButton.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    public func itemBind(storeList: Store, index: Int) {
        DispatchQueue.main.async {
            self.storeButton.setTitle(storeList.name[index], for: .normal)
        }
    }
    
    //MARK: Action
    
    @objc
    public func didTapStoreButton() {
        storeButtonAction?()
    }
}



