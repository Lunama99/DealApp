//
//  HistoryTableViewCell.swift
//  Vera
//
//  Created by Macbook on 06/07/2021.
//

import UIKit

class HistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var addressLbl: BaseLabel!
    @IBOutlet weak var statusBtn: BaseButton!
    @IBOutlet weak var amountLbl: BaseLabel!
    @IBOutlet weak var tyleLbl: BaseLabel!
    @IBOutlet weak var dateLbl: BaseLabel!
    @IBOutlet weak var urlLbl: BaseLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
