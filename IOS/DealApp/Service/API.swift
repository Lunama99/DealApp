//
//  API.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation
import Moya

public enum API {
    // Tool
    case GetServerTime
    // Account
    case Register(FullName: String, Sponsor: String?, Email: String, UserName: String, Password: String, Type: String?)
    case Login(UserName: String, Password: String, RememberMe: Bool)
    case ForgotPassword(Email: String)
    case ChangePassword(OldPassword: String, NewPassword: String)
    case UpdateUserInfor(User: User)
    case GetUser
    case FormVerifyUser(FullName: String, CardNumber: String, CardPlace: String, IssuedOn: String, Birthday: String, Gender: String, FontImage: String, BackImage: String, PortraitImage: String)
    // Product
    case GetNewProduct(Page: Int, Limit: Int, OrderType: String?)
    // Product Category
    case GetAllCategory
    // Notification
    case GetListNotification
    // Vendor
    case GetListVendor(IdCategory: String, Page: Int, Limit: Int, orderType: String)
}

extension API: TargetType {
    
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://dealapp.verafti.com")!
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .ChangePassword, .UpdateUserInfor, .GetUser, .FormVerifyUser:
            return ["Authorization": "Bearer \(Helper.shared.userToken ?? "")",
                    "Content-Type": "application/json"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    public var method: Moya.Method {
      switch self {
      case .GetServerTime: return .get
      case .Register: return .put
      case .Login: return .put
      case .ForgotPassword: return .put
      case .ChangePassword: return .put
      case .UpdateUserInfor: return .put
      case .GetUser: return .get
      case .GetNewProduct: return .get
      case .GetAllCategory: return .get
      case .FormVerifyUser: return .put
      case .GetListNotification: return .get
      case .GetListVendor: return .put
      }
    }

    public var path: String {
        switch self {
        case .GetServerTime: return "/Tool/GetServerTime"
        case .Register: return "/Account/Register"
        case .Login: return "/Account/Login"
        case .ForgotPassword: return "/Account/ForgotPassword"
        case .ChangePassword: return "/Account/ChangePassword"
        case .UpdateUserInfor: return "/Account/FormUpdateInfoUser"
        case .GetUser: return "/Account/GetUser"
        case .GetNewProduct: return "/Product/GetNewProduct"
        case .GetAllCategory: return "/ProductCategory/GetAllCategory"
        case .FormVerifyUser: return "/Account/FormVerifyUser"
        case .GetListNotification: return "/Notification/GetListNotification"
        case .GetListVendor: return "/Vendor/GetListVendor"
        }
    }
    
    public var task: Task {
      switch self {
      case .Register(let FullName, let Sponsor, let Email, let UserName, let Password, let Type):
        var parameters: [String: Any] = ["FullName": FullName,
                          "Email": Email,
                          "Sponsor": Sponsor ?? "test",
                          "UserName": UserName,
                          "Password": Password,
                          "ConfirmPassword": Password]
        
        if let Type = Type {
            parameters["Type"] = Type
        }
        
        return .requestParameters(parameters: parameters,
                                    encoding: JSONEncoding.default)
        
      case .Login(let UserName, let Password, let RememberMe):
        let parameters: [String: Any] = ["UserName": UserName,
                          "Password": Password,
                          "RememberMe": RememberMe]
        
//        let name = UserName.data(using: String.Encoding.utf8) ?? Data()
//        let pass = Password.data(using: String.Encoding.utf8) ?? Data()
//
//        var data: [MultipartFormData] = []
//        let nameData = MultipartFormData(provider: .data(name), name: "UserName")
//        let passData = MultipartFormData(provider: .data(pass), name: "Password")
//        data.append(nameData)
//        data.append(passData)
//
//        return .uploadMultipart(data)
        
        return .requestParameters(parameters: parameters,
                                  encoding: JSONEncoding.default)
        
      case .ForgotPassword(let Email):
        return .requestParameters(parameters: ["Email": Email], encoding: JSONEncoding.default)
      case .ChangePassword(let OldPassword, let NewPassword):
        return .requestParameters(parameters: ["oldPassword": OldPassword,
                                               "newPassword": NewPassword], encoding: JSONEncoding.default)
      case .UpdateUserInfor(let User):
        var parameters: [String: Any] = ["FullName": User.fullName ?? "",
                                         "Email": User.email ?? "",
                                         "PhoneNumber": User.phoneNumber ?? ""]
        
        if let avatar = User.avatarBase64 {
            parameters["AvatarBase64"] = avatar
        }
        
        if let country = User.country {
            parameters["Country"] = country
        }
        
        if let state = User.state {
            parameters["State"] = state
        }
        
        if let city = User.city {
            parameters["City"] = city
        }
        
        if let street = User.street {
            parameters["Street"] = street
        }
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .GetNewProduct(let Page, let Limit, let OrderType):
        var parameters: [String: Any] = ["Page": Page,
                                         "Limit": Limit]
        if let orderType = OrderType {
            parameters["OrderType"] = orderType
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    
      case .GetListVendor(let IdCategory, let Page, let Limit, let orderType):
        return .requestParameters(parameters: ["IdCategory": IdCategory,
                                               "Page": Page,
                                               "Limit": Limit,
                                               "orderType": "string"], encoding: JSONEncoding.default)
      default:
        return .requestPlain
      }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var validationType: ValidationType {
      return .successCodes
    }
}

extension Encodable {
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
