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
        case format1 = "MM/dd/yyyy h:mm:ss"
        case format2 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        case format3 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case format4 = "MM/dd/yyyy"
    }
    
    func millisecondsSince1970() -> Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func getFormattedDate(format: DateFormatted) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format.rawValue
        return dateformat.string(from: self)
    }
    
    func toString(format: DateFormatted? = nil) -> String {
        if let stringFormat = format?.rawValue {
            let formatter = DateFormatter()
            formatter.dateFormat = stringFormat
            return formatter.string(from: self)
        } else {
            return "\(self.millisecondsSince1970())"
        }
    }
    
    func getTimeSession() -> String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 6..<12 : return "Good Morning"
        case 12..<17 : return "Good Afternoon"
        case 17..<22 : return "Good Evening"
        default: return "Good Night"
        }
    }
}
