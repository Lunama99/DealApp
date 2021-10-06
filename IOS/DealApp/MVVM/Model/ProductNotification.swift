//
//  Notification.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation

class GetListNotification: Codable {
    var imageList: [ImageList]?
    var name: String?
    var description: String?
    var dateCreate: String?
    var active: Bool?
    var dateStart: String?
    var typeUser: Int?
    var status: String?
}
