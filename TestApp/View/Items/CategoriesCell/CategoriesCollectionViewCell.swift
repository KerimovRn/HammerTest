//
//  CategoriesCollectionViewCell.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 16.10.2022.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell, NibReusable {
    
    private let pinkColor = UIColor(named: "custom_pink_color")
    private let textPinkColor = UIColor(named: "custom_pink_textColor")
    
    override var isSelected: Bool {
        didSet {
            isSelected ? selected() : unselected()
        }
    }
 
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func selected() {
        titleLabel.textColor = textPinkColor
        borderView.backgroundColor = pinkColor?.withAlphaComponent(0.2)
        borderView.layer.borderWidth = 0
    }
    
    private func unselected() {
        titleLabel.textColor = pinkColor
        borderView.backgroundColor = .clear
        borderView.layer.borderWidth = 1
    }
    
    func setupCell(with name: String) {
        self.titleLabel.text = name
        self.borderView.layer.cornerRadius = 16
        self.borderView.layer.borderColor = pinkColor?.withAlphaComponent(0.4).cgColor
        self.borderView.layer.borderWidth = 1
    }
}
