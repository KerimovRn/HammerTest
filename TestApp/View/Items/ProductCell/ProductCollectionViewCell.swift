//
//  ProductCollectionViewCell.swift
//  TestApp
//
//  Created by Ruslan Kerimov on 15.10.2022.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell, NibReusable {
    
    private let textPinkColor = UIColor(named: "custom_pink_textColor")

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    
    
    func setupCell(with model: ProductModel) {
        setupUI()
        
        productTitle.text = model.name
        productDescription.text = model.dsc
        let priceString = String(model.price)
        priceBtn.setTitle(priceString, for: .normal)
        if let url = URL(string: model.img) {
            productImageView.kf.setImage(with: url)
        }
        
    }
    
    func setupUI() {
        priceBtn.layer.cornerRadius = 6
        priceBtn.layer.borderWidth = 1
        priceBtn.layer.borderColor = textPinkColor?.cgColor
    }
    
    func setRadius() {
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func priceBtnT(_ sender: Any) {
        print("price button tapped")
    }
    
}
