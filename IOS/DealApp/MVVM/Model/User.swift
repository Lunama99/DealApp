//
//  User.swift
//  DealApp
//
//  Created by Macbook on 30/09/2021.
//

import Foundation

public class User: Codable {
    var id: String?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var userName: String?
    var email: String?
    var phoneNumber: String?
    var gender: String?
    var birthday: String?
    var avatar: String?
    var avatarBase64: String?
    var country: String?
    var state: String?
    var city: String?
    var street: String?
    var fullAddress: String?
    var code: String?
    var codeRef: String?
    var lockExchange: Bool?
    var lockTransfer: Bool?
    var lockWithdraw: Bool?
    var activity: Bool?
    var lock: Bool?
    var dateCreate: String?
    var agencyActive: Bool?
    var agencySetting: Bool?
    var agencyBonus: Int?
    var percentDiscount: Int?
    var type: Int?
    var lat: String?
    var lng: String?
}

public class FormVerifyUser: Codable {
    var fullName: String?
    var cardNumber: String?
    var cardPlace: String?
    var issuedOn: String?
    var birthday: String?
    var gender: String?
    var fontImage: String?
    var backImage: String?
    var portraitImage: String?
}
