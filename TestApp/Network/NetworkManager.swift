//
//  NetworkManager.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 16.10.2022.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = { NetworkManager() }()
    
    private let baseURL = "https://ig-food-menus.herokuapp.com/"
    
    
    func getProducts(with category: String, completion: @escaping (Result<[ProductModel], Error>) -> Void ) {
        let urlString = baseURL + category
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let products = try decoder.decode([ProductModel].self, from: data)
                    completion(.success(products))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
