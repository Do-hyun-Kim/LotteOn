//
//  LotteCollectionViewCell.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/22.
//

import UIKit
import SnapKit



class LotteCollectionViewCell: UICollectionViewCell {
    
    //MARK: Property
    static let reuseIdentifier = String(describing: LotteCollectionViewCell.self)
    
    public var productImageView: UIImageView = {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    public var productNameLabel: UILabel = {
        $0.font  = .systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    public var brandNameLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    public var discountLabel: UILabel = {
        $0.font = .systemFont(ofSize: 9)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
        $0.textColor = .magenta
        return $0
    }(UILabel())
    
    public var discountPriceLabel: UILabel = {
        $0.font = .systemFont(ofSize: 9)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        
        return $0
    }(UILabel())
    
    public var costLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .black
        
        return $0
    }(UILabel())
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Configure
    private func configure() {
        [productImageView,productNameLabel,brandNameLabel,discountLabel,costLabel,discountPriceLabel].forEach {
            addSubview($0)
        }
    }
    
    private func strikeFromString(discount item: ShopList) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(item.productCost)")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    public func itemBind(_ shopList: ShopList) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let imageURL = URL(string: shopList.productImage)
            guard let imageData = try? Data(contentsOf: imageURL!) else { return }
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.productNameLabel.text = shopList.productName
                self.brandNameLabel.text = shopList.brandName
                self.productImageView.image = UIImage(data: imageData)
                
                if shopList.productDiscountRate > 0 {
                    self.discountLabel.isHidden = false
                    self.discountLabel.text = "\(shopList.productDiscountRate)%"
                    self.discountPriceLabel.attributedText = self.strikeFromString(discount: shopList)
                    self.costLabel.text = "\(shopList.productPrice)원"
                } else {
                    self.discountLabel.isHidden = true
                    self.discountPriceLabel.isHidden = true
                    self.costLabel.text = "\(shopList.productCost)원"
                }
            }
        }
    }

}
