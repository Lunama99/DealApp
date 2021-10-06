//
//  FacebookUser.swift
//  DealApp
//
//  Created by Macbook on 09/09/2021.
//

import Foundation

class FaceBookUser: Codable {
    var id: String?
    var name: String?
    var email: String?
    var imageURL: String?
    
    convenience init(id: String?, name: String?, email: String?) {
        self.init()
        self.id = id ?? ""
        self.name = name ?? ""
        self.email = email ?? ""
    }
}
