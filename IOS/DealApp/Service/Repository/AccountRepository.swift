//
//  AccountRepository.swift
//  DealApp
//
//  Created by Macbook on 22/09/2021.
//

import Foundation
import Result
import Moya

class AccountRepository: NetworkManager {
    func register(FullName: String, Sponsor: String?, Email: String, UserName: String, Password: String, Type: String?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.Register(FullName: FullName, Sponsor: Sponsor, Email: Email, UserName: UserName, Password: Password, Type: Type)) { result  in
            completion(result)
        }
    }
    
    func login(UserName: String, Password: String, RememberMe: Bool, TokenDevice: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.Login(UserName: UserName, Password: Password, RememberMe: RememberMe, TokenDevice: TokenDevice)) { result  in
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
    
    func formVerifyUser(User: FormVerifyUser, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.FormVerifyUser(User: User)) { result in
            completion(result)
        }
    }
    
    func resetPassword(NewPassword: String, ConfirmPassword: String, Token: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.ResetPassword(NewPassword: NewPassword, ConfirmPassword: ConfirmPassword, Token: Token)) { result in
            completion(result)
        }
    }
    
    func registerPartner(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.RegisterPartner) { result in
            completion(result)
        }
    }
}

class DefaultResponse: Codable {
    var status: Bool?
    var message: String?
    var result: String?
}
