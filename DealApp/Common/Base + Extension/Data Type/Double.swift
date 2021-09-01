//
//  Double.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//
import Foundation

extension Double {
    func toBalance() -> String {
        return self.toString(decimal: 6)
    }
    
    func toDollar() -> String {
        return self.toString(decimal: 4)
    }
    
    func toPercent() -> String {
        return self.toString(decimal: 2)
    }
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self/1000.0)
    }
    
    func toString(decimal: Int) -> String {
        let value = decimal < 0 ? 0 : decimal
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = value
        formatter.minimumFractionDigits = value
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        if let str = formatter.string(from: NSNumber(value: self)) {
            var string = str.trimmingCharacters(in: .whitespaces)
            while string.last == "," || string.last == "0" || string.last == "."  {
                if string.last == "." { string = String(string.dropLast()); break}
                if string.last == "," { string = String(string.dropLast()); break}
                string = String(string.dropLast())
            }
            return string
        }
    
        return ""
    }
}
