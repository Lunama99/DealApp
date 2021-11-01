//
//  Cart.swift
//  DealApp
//
//  Created by Macbook on 21/10/2021.
//

import Foundation

class CartReponse: Codable {
    var status: Bool?
    var message: String?
    var result: CartModel?
}

class CartModel: Codable {
    var total: Double?
    var subTotal: Double?
    var listCartItem: [CartItem]?
}

class CartItem: Codable {
    var name: String?
    var image: String?
    var dateStart: String?
    var dateEnd: String?
    var quantityWare: Int?
    var statusVoucher: Int?
    var id: String?
    var idVoucher: String?
    var quantity: Int?
    var price: Double?
    var subTotal: Double?
    var total: Double?
    var idUser: String?
    var status: Bool?
}
