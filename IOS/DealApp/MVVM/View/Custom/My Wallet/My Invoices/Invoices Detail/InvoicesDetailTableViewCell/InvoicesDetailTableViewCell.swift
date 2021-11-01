//
//  InvoicesDetailTableViewCell.swift
//  DealApp
//
//  Created by Macbook on 26/10/2021.
//

import UIKit

class InvoicesDetailTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var vendorLbl: UILabel!
    @IBOutlet weak var codeVoucherLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dimBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
