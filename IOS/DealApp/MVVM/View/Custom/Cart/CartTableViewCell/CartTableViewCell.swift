//
//  CartTableViewCell.swift
//  DealApp
//
//  Created by Macbook on 22/10/2021.
//

import UIKit

class CartTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var checkBoxBtn: BaseButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pointLbl: BaseLabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    var callBack: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        callBack?()
    }
}
