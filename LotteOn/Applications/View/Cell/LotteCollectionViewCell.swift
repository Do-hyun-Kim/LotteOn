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
    private var collectionViewModel: ViewModel!
    
    private(set) var discountRate: Int = 0 {
        didSet {
            if discountRate > 0 {
                discountRateLabel.isHidden = false
                discountPriceLabel.isHidden = false
                costLabel.snp.remakeConstraints {
                    $0.top.equalTo(discountRateLabel.snp.bottom).offset(10)
                    $0.left.equalTo(discountRateLabel)
                }
            } else {
                discountRateLabel.isHidden = true
                discountPriceLabel.isHidden = true
                costLabel.snp.remakeConstraints {
                    $0.top.equalTo(productNameLabel.snp.bottom).offset(5)
                    $0.left.equalTo(productNameLabel)
                    $0.width.lessThanOrEqualTo(contentView.frame.width)
                }
            }
        }
    }
    
    public var productImageView: UIImageView = {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
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
    
    public var discountRateLabel: UILabel = {
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
        [productImageView,productNameLabel,discountRateLabel,costLabel,discountPriceLabel].forEach {
            addSubview($0)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
        }
        
        discountRateLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(5)
            $0.left.equalTo(productNameLabel)
            $0.centerY.equalTo(discountPriceLabel)
            $0.height.equalTo(10)
        }
        
        discountPriceLabel.snp.makeConstraints {
            $0.top.equalTo(discountRateLabel)
            $0.left.equalTo(discountRateLabel.snp.right).offset(5)
            $0.height.equalTo(discountRateLabel)
        }
        
    }

    public func itemBind(_ shopList: ShopList, _ viewModel: ViewModel) {
        collectionViewModel = viewModel
        let filterName = shopList.brandName.filter{ !String($0).isEmpty}.appending(" ")
        productImageView.setCacheImage(shopList.productImage)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.discountRate = shopList.productDiscountRate
            let combineName = filterName + shopList.productName
            self.productNameLabel.attributedText = self.boldFromString(to: combineName, from: shopList.brandName)
            self.discountRateLabel.text = "\(shopList.productDiscountRate)%"
            let transformDiscount = self.collectionViewModel.lotteShopUseCase.executeTransform(reqeustValue: shopList.productCost)
            self.discountPriceLabel.attributedText = self.strikeFromString(discount: transformDiscount + "원")
            let transformPrice = self.collectionViewModel.lotteShopUseCase.executeTransform(reqeustValue: shopList.productPrice)
            self.costLabel.attributedText = self.systemFromString(to: transformPrice + "원")
        }
    }
}



extension LotteCollectionViewCell {

    private func strikeFromString(discount item: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: item)
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    private func boldFromString(to name: String, from transfrom: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: name)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: (name as NSString).range(of: transfrom))
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: (name as NSString).range(of: transfrom))
        return attributedString
    }
    
    private func systemFromString(to price: String, transfrom: String = "원") -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: price)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 11), range: (price as NSString).range(of: transfrom))
        return attributedString
    }
    
}
