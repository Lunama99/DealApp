//
//  CustomSearchBar.swift
//  DealApp
//
//  Created by Macbook on 01/09/2021.
//

import UIKit

class CustomSearchBar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchTfx: BaseTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.customSearchBar.name, owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    
//        contentView.layer.shadowColor = UIColor.gray.cgColor
//        contentView.layer.shadowOpacity = 0.3
//        contentView.layer.shadowOffset = CGSize.zero
//        contentView.layer.shadowRadius = 6
//        contentView.layer.masksToBounds = true
//        contentView.layer.borderWidth = 1.5
//        contentView.layer.borderColor = UIColor.white.cgColor
    }
}
