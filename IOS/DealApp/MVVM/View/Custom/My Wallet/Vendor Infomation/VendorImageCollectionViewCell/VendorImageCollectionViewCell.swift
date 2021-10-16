//
//  VendorImageCollectionViewCell.swift
//  DealApp
//
//  Created by Macbook on 12/10/2021.
//

import UIKit

class VendorImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vendorImg: UIImageView!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var deleteBtn: BaseButton!

    var callBack: (()->Void)?
    
    @IBAction func deleteAction(_ sender: Any) {
        callBack?()
    }
}
