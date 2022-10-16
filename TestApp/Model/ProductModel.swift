//
//  ProductModel.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 16.10.2022.
//

import Foundation

struct ProductModel: Decodable {
    let id: String
    let img: String
    let name, dsc: String
    let price: Double
    let rate: Int
    let country: String
}
