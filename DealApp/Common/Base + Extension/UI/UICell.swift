//
//  UITableViewCell.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
}

extension UICollectionViewCell {
    func setShadow() {
        layer.cornerRadius = 15.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
}
