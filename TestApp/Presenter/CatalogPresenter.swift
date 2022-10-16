//
//  CatalogPresenter.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 16.10.2022.
//

protocol CatalogPresenterProtocol {
    func animating(_ animate: Bool)
    func presentProducts(products: [ProductModel])
    func presentError(text: String)
}

class CatalogPresenter {
    var presenter: CatalogPresenterProtocol!
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter;
    }
    
    func getProducts(categoryName: String ) {
        self.presenter.animating(true)
        NetworkManager.sharedInstance.getProducts(with: categoryName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.presenter.presentProducts(products: products)
            case .failure(let error):
                self.presenter.presentError(text: error.localizedDescription)
            }
            self.presenter.animating(false)
        }
    }
}
