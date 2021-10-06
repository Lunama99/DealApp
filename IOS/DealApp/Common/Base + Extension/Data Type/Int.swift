//
//  Int.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(format: "%\(self)f", self)
    }
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: Double(self)/1000)
    }
}

