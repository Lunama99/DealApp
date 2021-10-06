//
//  AccountRepository.swift
//  DealApp
//
//  Created by Macbook on 22/09/2021.
//

import Foundation
import Moya

class AccountRepository: NetworkManager {
    func register(FullName: String, Sponsor: String?, Email: String, UserName: String, Password: String, Type: String?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.Register(FullName: FullName, Sponsor: Sponsor, Email: Email, UserName: UserName, Password: Password, Type: Type)) { result  in
            completion(result)
        }
    }
    
    func login(UserName: String, Password: String, RememberMe: Bool, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.Login(UserName: UserName, Password: Password, RememberMe: RememberMe)) { result  in
            completion(result)
        }
    }
    
    func forgotPassword(Email: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.ForgotPassword(Email: Email)) { result  in
            completion(result)
        }
    }
    
    func changePassword(OldPassword: String, NewPassword: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.ChangePassword(OldPassword: OldPassword, NewPassword: NewPassword)) { result  in
            completion(result)
        }
    }
    
    func updateUserInfor(user: User, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.UpdateUserInfor(User: user)) { result in
            completion(result)
        }
    }
    
    func getUser(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetUser) { result in
            completion(result)
        }
    }
    
    func formVerifyUser(FullName: String, CardNumber: String, CardPlace: String, IssuedOn: String, Birthday: String, Gender: String, FontImage: String, BackImage: String, PortraitImage: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.FormVerifyUser(FullName: FullName, CardNumber: CardNumber, CardPlace: CardPlace, IssuedOn: IssuedOn, Birthday: Birthday, Gender: Gender, FontImage: FontImage, BackImage: BackImage, PortraitImage: PortraitImage)) { result in
            completion(result)
        }
    }
}

class DefaultResponse: Codable {
    var status: Bool?
    var message: String?
    var result: String?
}
