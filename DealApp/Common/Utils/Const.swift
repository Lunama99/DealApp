//
//  Const.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation

class Const {
    
    private init() {}
    
    static let shared = Const()

    var isProduction: Bool {
        return false
    }
    
    static let keyCrypt = "key-vera-wallet"
    
    static let privacyURL = "https://wallet.verafti.uk/api/privacy"
}
