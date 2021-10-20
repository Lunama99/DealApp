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
    case FormVerifyUser(User: FormVerifyUser)
    // Product
    case GetNewProduct(Page: Int, Limit: Int, OrderType: String?)
    // Product Category
    case GetAllCategory
    // Notification
    case GetListNotification
    // Wallet
    case GetWalletAddress(currency: String)
    case GetBalance(currency: String)
    case GetTransactionHistory(Page: Int, Limit: Int, Order: String?)
    case GetCoinDeposit
    // Vendor
    case RegisterVendor(IDCategory: String, Name: String, PaymentDiscountPercent: String, LicenseBase64: String)
    case GetListVendorRegisted
    case GetListVendor(Page: Int, Limit: Int, orderType: String)
    case UpdateVendorInformation(ID: String, Name: String, Description: String, AvatarBase64: String?, ImageListBase64: [String]?, address: [VendorAddress]?)
    case GetVendortById(Id: String)
    // Voucher
    case GetListVoucherByIDVendor(IdVendor: String, Page: Int, Limit: Int, OrderType: String)
    case GetListVoucher(Page: Int, Limit: Int, OrderType: String)
    case AddVoucher(voucher: GetVoucher)
    case DeleteVoucher(IdVoucher: String)
    // Invoice
    case AddInvoiceVoucher(PaymentMethod: Int)
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
        case .ChangePassword, .UpdateUserInfor, .GetUser, .GetWalletAddress, .FormVerifyUser, .GetBalance,
                .GetTransactionHistory, .RegisterVendor, .GetListVendorRegisted, .UpdateVendorInformation, .GetListVoucherByIDVendor,
                .AddVoucher, .DeleteVoucher:
            print("token: \(Helper.shared.userToken ?? "")")
            return ["Authorization": "Bearer \(Helper.shared.userToken ?? "")",
                    "Content-Type": "application/json"]
//        case .FormVerifyUser:
//            return ["Authorization": "Bearer \(Helper.shared.userToken ?? "")",
//                    "Content-Type": "application/json"]
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
      case .GetWalletAddress: return .get
      case .GetBalance: return .get
      case .GetTransactionHistory: return .put
      case .GetCoinDeposit: return .get
      case .RegisterVendor: return .put
      case .GetListVendorRegisted: return .get
      case .UpdateVendorInformation: return .put
      case .GetVendortById: return .get
      case .GetListVoucherByIDVendor: return .put
      case .AddVoucher: return .put
      case .DeleteVoucher: return .put
      case .GetListVoucher: return .put
      case .AddInvoiceVoucher: return .put
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
        case .GetWalletAddress(let currency): return "/Wallet/GetWalletAddress/\(currency)"
        case .GetBalance(let currency): return "/Wallet/GetBalance/\(currency)"
        case .GetTransactionHistory: return "/Wallet/TransactionHistory"
        case .GetCoinDeposit: return "/Wallet/GetCoinDeposit"
        case .RegisterVendor: return "/Vendor/RegisterVendor"
        case .GetListVendorRegisted: return "/Vendor/GetListVendorRegisted"
        case .UpdateVendorInformation: return "/Vendor/UpdateVendorInformation"
        case .GetVendortById(let id): return "/Vendor/GetVendortById/\(id)"
        case .GetListVoucherByIDVendor: return "/Voucher/GetListVoucherByIDVendor"
        case .AddVoucher: return "/Voucher/AddVoucher"
        case .DeleteVoucher: return "/Voucher/DeleteVoucher"
        case .GetListVoucher: return "/Voucher/GetListVoucher"
        case .AddInvoiceVoucher: return "/Invoice/AddInvoiceVoucher"
        }
    }
    
    public var task: Task {
      switch self {
      case .GetServerTime, .GetUser, .GetAllCategory, .GetListNotification, .GetWalletAddress, .GetBalance, .GetCoinDeposit,
              .GetListVendorRegisted, .GetVendortById:
          return .requestParameters(parameters: ["ver": Date().millisecondsSince1970()], encoding: URLEncoding.queryString)
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
                                         "PhoneNumber": User.phoneNumber ?? "",
                                         "Country": User.country ?? "",
                                         "City": User.city ?? "",
                                         "Commune": User.commune ?? "",
                                         "Street": User.street ?? ""]
        
        if let avatar = User.avatarBase64 {
            parameters["AvatarBase64"] = avatar
        }
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .GetNewProduct(let Page, let Limit, let OrderType):
        var parameters: [String: Any] = ["Page": Page,
                                         "Limit": Limit]
        if let orderType = OrderType {
            parameters["OrderType"] = orderType
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    
      case .GetListVendor(let Page, let Limit, let orderType):
        return .requestParameters(parameters: ["Page": Page,
                                               "Limit": Limit,
                                               "orderType": orderType], encoding: JSONEncoding.default)
      case .FormVerifyUser(let User):
        let parameters: [String: Any] = ["FullName": User.fullName ?? "",
                                         "CardNumber": User.cardNumber ?? "",
                                         "CardPlace": User.cardPlace ?? "",
                                         "IssuedOn": User.issuedOn ?? "",
                                         "Birthday": User.birthday ?? "",
                                         "Gender": User.gender ?? "",
                                         "FontImageBase64": User.fontImage ?? "",
                                         "BackImageBase64": User.backImage ?? "",
                                         "PortraitImageBase64": User.portraitImage ?? ""]
//        let fullName = User.fullName?.data(using: String.Encoding.utf8) ?? Data()
//        let cardPlace = User.cardPlace?.data(using: String.Encoding.utf8) ?? Data()
//        let cardNumber = User.cardNumber?.data(using: String.Encoding.utf8) ?? Data()
//        let issuedOn = User.issuedOn?.data(using: String.Encoding.utf8) ?? Data()
//        let birthday = User.birthday?.data(using: String.Encoding.utf8) ?? Data()
//        let gender = User.gender?.data(using: String.Encoding.utf8) ?? Data()
//        let fontImage = User.fontImage?.data(using: String.Encoding.utf8) ?? Data()
//        let backImage = User.backImage?.data(using: String.Encoding.utf8) ?? Data()
//        let portraitImage = User.portraitImage?.data(using: String.Encoding.utf8) ?? Data()
//
//        var data: [MultipartFormData] = []
//
//        data.append(MultipartFormData(provider: .data(fullName), name: "fullName"))
//        data.append(MultipartFormData(provider: .data(cardPlace), name: "cardPlace"))
//        data.append(MultipartFormData(provider: .data(cardNumber), name: "cardNumber"))
//        data.append(MultipartFormData(provider: .data(issuedOn), name: "issuedOn"))
//        data.append(MultipartFormData(provider: .data(birthday), name: "birthday"))
//        data.append(MultipartFormData(provider: .data(gender), name: "gender"))
//        data.append(MultipartFormData(provider: .data(fontImage), name: "fontImage"))
//        data.append(MultipartFormData(provider: .data(backImage), name: "backImage"))
//        data.append(MultipartFormData(provider: .data(portraitImage), name: "portraitImage"))
//
//        return .uploadMultipart(data)
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .GetTransactionHistory(let Page, let Limit, let Order):
        var parameters: [String: Any] = ["Page": Page,
                                         "Limit": Limit]
        
        if let order = Order {
            parameters["Order"] = order
        }
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .RegisterVendor(let IDCategory, let Name, let PaymentDiscountPercent, let licenseBase64):
        return .requestParameters(parameters: ["IDCategory": IDCategory,
                                               "Name": Name,
                                               "PaymentDiscountPercent": PaymentDiscountPercent,
                                               "licenseBase64": licenseBase64], encoding: JSONEncoding.default)
      case .UpdateVendorInformation(let ID, let Name, let Description, let AvatarBase64, let ImageListBase64, let Address):
          var parameters: [String: Any] = ["ID": ID,
                                           "Name": Name,
                                           "Description": Description]
          
          if let avatarBase64 = AvatarBase64 {
              parameters["AvatarBase64"] = avatarBase64
          }
          
          if let imageListBase64 = ImageListBase64 {
              parameters["ImageListBase64"] = imageListBase64
          }
          
          if let listAddress = Address {
              var addressParameters: [[String: Any]] = []
              
              listAddress.forEach({ item in
                  var newAddress: [String: Any] = ["PhoneNumber": item.phoneNumber ?? "",
                                                   "Street": item.street ?? "",
                                                   "Ward": item.ward ?? "",
                                                   "District": item.district ?? "",
                                                   "City": item.city ?? "",
                                                   "State": item.state ?? "",
                                                   "Country": item.country ?? ""]
                  
                  if let id = item.id {
                      newAddress["Id"] = id
                  }
                  
                  addressParameters.append(newAddress)
              })
              
              parameters["Address"] = addressParameters
          }
          
          return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .GetListVoucherByIDVendor(let IdVendor, let Page, let Limit, let OrderType):
          return .requestParameters(parameters: ["IdVendor": IdVendor,
                                                 "Page": Page,
                                                 "Limit": Limit,
                                                 "OrderType": OrderType], encoding: JSONEncoding.default)
      case .AddVoucher(let voucher):
          var parameters: [String: Any] = ["idVendor": voucher.idVendor ?? "",
                                           "name": voucher.name ?? "",
                                           "description": voucher.description ?? "",
                                           "oldPrice": voucher.oldPrice ?? 0,
                                           "newPrice": voucher.newPrice ?? 0,
                                           "quantityWare": voucher.quantityWare ?? 0,
                                           "dateEnd": voucher.dateEnd ?? "",
                                           "dateStart": voucher.dateStart ?? ""]
          
          if let id = voucher.id {
              parameters["id"] = id
          }
          
          if let status = voucher.status {
              parameters["status"] = status
          }
          
          if let imageBase64 = voucher.imageBase64 {
              parameters["imageBase64"] = imageBase64
          }
          
          if let active = voucher.active {
              parameters["active"] = active
          }
          
          return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .DeleteVoucher(let IdVoucher):
          return .requestParameters(parameters: ["idVoucher": IdVoucher], encoding: URLEncoding.queryString)
      case .GetListVoucher(let Page, let Limit, let OrderType):
          return .requestParameters(parameters: ["Page": Page,
                                                 "Limit": Limit,
                                                 "OrderType": OrderType], encoding: JSONEncoding.default)
      case .AddInvoiceVoucher(let PaymentMethod):
        return .requestParameters(parameters: ["PaymentMethod": PaymentMethod], encoding: JSONEncoding.default)
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
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
