//
//  VendorDetailImageView.swift
//  DealApp
//
//  Created by Macbook on 06/09/2021.
//

import UIKit

class VendorDetailImageView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.vendorDetailImageView.name, owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
}
