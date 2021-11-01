//
//  MyInvoicesTableViewCell.swift
//  DealApp
//
//  Created by Macbook on 26/10/2021.
//

import UIKit

class MyInvoicesTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var creaetDateLbl: UILabel!
    @IBOutlet weak var priceLbl: BaseLabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var quantityValueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
