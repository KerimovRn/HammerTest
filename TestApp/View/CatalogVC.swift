//
//  CatalogVC.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 15.10.2022.
//

import UIKit

class CatalogVC: UIViewController {
    
    private let categories = [
        "bbqs",
        "best-foods",
        "breads",
        "burgers",
        "chocolates",
        "desserts",
        "drinks",
        "fried-chicken",
        "ice-cream",
        "pizzas",
        "porks",
        "sandwiches",
        "sausages",
        "steaks"
    ]

    @IBOutlet weak var activityIndidcator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: CatalogPresenter!
    private var products: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CatalogPresenter(presenter: self)
        setupCollection()
        presenter.getProducts(categoryName: categories[0])
    }
    
    private var collectionViewLayout: UICollectionViewLayout {
        get {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                return self.createSection(with: sectionIndex)
            }
            return layout
        }
    }
    
    private func createSection(with section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return createBannerSection()
        default:
            return createProductsSection()
        }
    }

    private func setupCollection() {
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: BannerCollectionViewCell.self)
        collectionView.register(viewType: CategoriesReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(cellType: ProductCollectionViewCell.self)
    }
}

// MARK: Метод по обработке смены категории
extension CatalogVC: CategoriesDelegate {
    func changeCategory(categoryName: String) {
        presenter.getProducts(categoryName: categoryName)
    }
}

// MARK: Обработка методов presenter'а
extension CatalogVC: CatalogPresenterProtocol {
    func animating(_ animate: Bool) {
        DispatchQueue.main.async {
            animate ? self.activityIndidcator.startAnimating() : self.activityIndidcator.stopAnimating()
        }
    }
    
    func presentProducts(products: [ProductModel]) {
        self.products = products
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func presentError(text: String) {
        let alert = UIAlertController(title: "Error!", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: Настройка внешнего вида таблицы с помощью UICollectionViewCompositionalLayout
extension CatalogVC {
    func createBannerSection() -> NSCollectionLayoutSection {
        let estimatedWidth: CGFloat = view.frame.width - 75
        let estimatedHeight: CGFloat = 112
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .estimated(estimatedHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(view.frame.width),
            heightDimension: .estimated(estimatedHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return section
    }
    

    func createProductsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerElement = createCategoriesHeader()
        section.boundarySupplementaryItems += [headerElement]
        return section

    }
    
    func createCategoriesHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        headerElement.pinToVisibleBounds = true
        return headerElement
    }
}

// MARK: Поведение и заполнение таблицы
extension CatalogVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return products.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(for: indexPath, cellType: BannerCollectionViewCell.self)
        default:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProductCollectionViewCell.self)
            
            cell.setupCell(with: products[indexPath.item])
            
            if indexPath.item == 0 {
                cell.setRadius()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let categoriesHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: indexPath,
            viewType: CategoriesReusableView.self)
        categoriesHeader.delegate = self
        categoriesHeader.setupCollection(categories: categories)
        return categoriesHeader
    }
    
}
