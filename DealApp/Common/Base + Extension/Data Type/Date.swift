//
//  Date.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation

extension Date {
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    enum DateFormatted: String {
        case format1 = "MM/dd/yyyy h:mm:ss a"
    }
    
    func millisecondsSince1970() -> Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func getFormattedDate(format: DateFormatted) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format.rawValue
        return dateformat.string(from: self)
    }
    
    func toString() -> String {
        return "\(self.millisecondsSince1970())"
    }
}
