//
//  CategoriesReusableView.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 15.10.2022.
//

import UIKit

protocol CategoriesDelegate: AnyObject {
    func changeCategory(categoryName: String)
}

class CategoriesReusableView: UICollectionReusableView, NibReusable {
    
    weak var delegate: CategoriesDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
   
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(cellType: CategoriesCollectionViewCell.self)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTagSection()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private var categories: [String]!
        
    func setupCollection(categories: [String]) {
        self.categories = categories
        collectionView.reloadData()
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }
    
    func createTagSection() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 20
        let estimatedWidth: CGFloat = 80
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(8), top: .fixed(0), trailing: .fixed(8), bottom: .fixed(0))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                               heightDimension: .estimated(estimatedHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
}

extension CategoriesReusableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoriesCollectionViewCell.self)
        cell.setupCell(with: categories[indexPath.item])
        if indexPath == selectedIndexPath {
            cell.selected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap to cell")
        selectedIndexPath = indexPath
        delegate?.changeCategory(categoryName: categories[indexPath.item])
    }
}
