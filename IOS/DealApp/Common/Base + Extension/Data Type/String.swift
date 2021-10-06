//
//  String.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation
import RNCryptor

extension String {
    func toDate(format: Date.DateFormatted) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    func isUppercase() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[A-Z]")
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isLowercase() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[a-z]")
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isNumber() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]")
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isAtLeast8Charater() -> Bool {
        return self.count >= 8
    }
    
    func encryptMessage() -> String {
        let messageData = self.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: Const.keyCrypt)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage() -> String {
        do {
            let encryptedData = Data(base64Encoded: self)!
            let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: Const.keyCrypt)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            return decryptedString ?? ""
        } catch {
            return "Failed"
        }
    }
    
    func dotbetween() -> String {
        var t = ""
        let numberChar = 12
        if (self.count >= (numberChar * 2)) {
            t = self.prefix(upTo: self.index(self.startIndex, offsetBy: numberChar)) + "..." + self.suffix(from: self.index(self.endIndex, offsetBy: -numberChar))
        }
        return t
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
