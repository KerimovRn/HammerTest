//
//  Reusable.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 15.10.2022.
//

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(reflecting: self)
    }
}

typealias NibReusable = NibLoadable & Reusable
