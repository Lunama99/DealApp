//
//  UISearchBar.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class BaseSearchBar: UISearchBar {
    
    var didChangeValue: ((String)->Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        delegate = self
        searchBarStyle = .minimal
    }
}

extension BaseSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        didChangeValue?(searchText)
    }
}
