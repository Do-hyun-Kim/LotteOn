//
//  ShopList.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import Foundation

struct ShopList: Codable {
    var divisionNumber: String
    var productName: String
    var brandName: String
    var productImage: String
    var productCost: Int
    var productPrice: Int
    var productDiscountRate: Int
    
    enum codingKeys: String, CodingKey {
        case divisionNumber = "t"
        case productName = "n"
        case brandName = "b"
        case productImage = "i"
        case productCost = "op"
        case productPrice = "p"
        case productDiscountRate = "d"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        divisionNumber = try values.decode(String.self, forKey: .divisionNumber)
        productName = try values.decode(String.self, forKey: .productName)
        brandName = try values.decode(String.self, forKey: .brandName)
        productImage = try values.decode(String.self, forKey: .productImage)
        productCost = try values.decode(Int.self, forKey: .productCost)
        productPrice = try values.decode(Int.self, forKey: .productPrice)
        productDiscountRate = try values.decode(Int.self, forKey: .productDiscountRate)
    }
}
