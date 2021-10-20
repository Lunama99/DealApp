//
//  VoucherManagerTableViewCell.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import UIKit

class VoucherManagerTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: BaseLabel!
    @IBOutlet weak var newPriceLbl: BaseLabel!
    @IBOutlet weak var oldPriceLbl: BaseLabel!
    @IBOutlet weak var dateLbl: BaseLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
