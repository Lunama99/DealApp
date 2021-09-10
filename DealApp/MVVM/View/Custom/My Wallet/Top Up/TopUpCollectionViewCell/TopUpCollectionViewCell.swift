//
//  TopUpCollectionViewCell.swift
//  DealApp
//
//  Created by Macbook on 07/09/2021.
//

import UIKit

class TopUpCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: BaseLabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBotConstraint: NSLayoutConstraint!
}
