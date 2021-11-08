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
    case Login(UserName: String, Password: String, RememberMe: Bool, TokenDevice: String)
    case ForgotPassword(Email: String)
    case ChangePassword(OldPassword: String, NewPassword: String)
    case UpdateUserInfor(User: User)
    case GetUser
    case FormVerifyUser(User: FormVerifyUser)
    case ResetPassword(NewPassword: String, ConfirmPassword: String, Token: String)
    // Product
    case GetNewProduct(Page: Int, Limit: Int, OrderType: String?)
    // Product Category
    case GetAllCategory
    // Notification
    case GetListNotification
    // Wallet
    case GetWalletAddress(currency: String)
    case GetBalance
    case GetTransactionHistory(Page: Int, Limit: Int, Type: String)
    case GetCoinDeposit
    // Vendor
    case RegisterVendor(ID: String?, IDCategory: String, Name: String, PaymentDiscountPercent: String, LicenseBase64: String)
    case GetListVendorRegisted
    case GetListVendor(Page: Int, Limit: Int, orderType: String)
    case UpdateVendorInformation(ID: String, Name: String, Description: String, AvatarBase64: String?, ImageListBase64: [String]?, address: [VendorAddress]?)
    case GetListVendorByIDVendorType(IdCategory: String, Page: Int, Limit: Int, OrderType: String)
    case GetVendortById(Id: String)
    case SearchVendor(key: String, page: Int, limit: Int)
    // Voucher
    case GetListVoucherByIDVendor(IdVendor: String)
    case GetListVoucher(Page: Int, Limit: Int, OrderType: String)
    case AddVoucher(voucher: GetVoucher)
    case DeleteVoucher(IdVoucher: String)
    case SearchVoucher(key: String, page: Int, limit: Int)
    case GetListNewVoucher
    // Invoice
    case AddInvoiceVoucher(PaymentMethod: Int)
    case GetListInvoice
    case GetInvoiceByTxTransaction(tx: String)
    // Cart
    case GetListCartUser
    case AddVoucherToCart(Id: String?, IdVoucher: String, Quantity: Int)
    case UpdateStatusItemCart(Id: [String], Status: Bool)
    // VoucherInvoice
    case UpdateStatusVoucher(code: String)
    case RegisterPartner
    // Notification
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
                .AddVoucher, .DeleteVoucher, .GetListCartUser, .AddVoucherToCart, .UpdateStatusItemCart, .AddInvoiceVoucher, .GetListInvoice, .UpdateStatusVoucher, .RegisterPartner, .GetListNotification, .GetInvoiceByTxTransaction:
            print("token: \(Helper.shared.userToken ?? "")")
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
      case .GetListCartUser: return .get
      case .AddVoucherToCart: return .put
      case .UpdateStatusItemCart: return .put
      case .GetListVendorByIDVendorType: return .put
      case .GetListInvoice: return .get
      case .SearchVendor: return .put
      case .SearchVoucher: return .put
      case .UpdateStatusVoucher: return .get
      case .GetListNewVoucher: return .get
      case .ResetPassword: return .put
      case .RegisterPartner: return .post
      case .GetInvoiceByTxTransaction: return .get
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
        case .GetBalance: return "/Wallet/GetBalance"
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
        case .GetListCartUser: return "/Cart/GetListCartUser"
        case .AddVoucherToCart: return "/Cart/AddVoucherToCart"
        case .UpdateStatusItemCart: return "/Cart/UpdateStatusItemCart"
        case .GetListVendorByIDVendorType: return "/Vendor/GetListVendorByIDVendorType"
        case .GetListInvoice: return "/Invoice/GetListInvoice"
        case .SearchVendor: return "/Vendor/SearchVendor"
        case .SearchVoucher: return "/Voucher/SearchVoucher"
        case .UpdateStatusVoucher: return "/VoucherInvoice/UpdateStatusVoucher"
        case .GetListNewVoucher: return "/Voucher/GetListNewVoucher"
        case .ResetPassword: return "/Account/ResetPassword"
        case .RegisterPartner: return "/Account/RegisterPartner"
        case .GetInvoiceByTxTransaction:
            return "/Invoice/GetInvoiceByTxTransaction"
        }
    }
    
    public var task: Task {
      switch self {
      case .GetServerTime, .GetUser, .GetAllCategory, .GetListNotification, .GetWalletAddress, .GetBalance, .GetCoinDeposit,
              .GetListVendorRegisted, .GetVendortById, .GetListCartUser, .GetListInvoice:
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
          
      case .Login(let UserName, let Password, let RememberMe, let TokenDevice):
          let parameters: [String: Any] = ["UserName": UserName,
                                           "Password": Password,
                                           "RememberMe": RememberMe,
                                           "TokenDevice": TokenDevice]
          
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
                                         "District": User.district ?? "",
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
          
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .GetTransactionHistory(let Page, let Limit, let Type):
        let parameters: [String: Any] = ["Page": Page,
                                         "Limit": Limit,
                                         "type": Type]
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .RegisterVendor(let ID, let IDCategory, let Name, let PaymentDiscountPercent, let licenseBase64):
          var parameters: [String: Any] = ["IDCategory": IDCategory,
                                           "Name": Name,
                                           "PaymentDiscountPercent": PaymentDiscountPercent,
                                           "licenseBase64": licenseBase64]
          if let ID = ID {
              parameters["ID"] = ID
          }
          
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
      case .GetListVoucherByIDVendor(let IdVendor):
          return .requestParameters(parameters: ["IdVendor": IdVendor], encoding: JSONEncoding.default)
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
        return .requestParameters(parameters: ["paymentMethod": PaymentMethod], encoding: JSONEncoding.default)
      case .AddVoucherToCart(let Id, let IdVoucher, let Quantity):
          var parameters: [String: Any] = ["IdVoucher": IdVoucher,
                                           "Quantity": Quantity]
          
          if let id = Id {
              parameters["Id"] = id
          }
          
          return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
      case .UpdateStatusItemCart(let Id, let Status):
          return .requestParameters(parameters: ["listID": Id,
                                                 "status": Status], encoding: JSONEncoding.default)
      case .GetListVendorByIDVendorType(let IdCategory, let Page, let Limit, let OrderType):
          return .requestParameters(parameters: ["IdCategory": IdCategory,
                                                 "Page": Page,
                                                 "Limit": Limit,
                                                 "OrderType": OrderType], encoding: JSONEncoding.default)
          
      case .SearchVendor(let key, let page, let limit):
          return .requestParameters(parameters: ["key": key,
                                                 "page": page,
                                                 "limit": limit], encoding: JSONEncoding.default)
      case .SearchVoucher(let key, let page, let limit):
          return .requestParameters(parameters: ["key": key,
                                                 "page": page,
                                                 "limit": limit], encoding: JSONEncoding.default)
      case .UpdateStatusVoucher(let code):
          return .requestParameters(parameters: ["code": code], encoding: URLEncoding.queryString)
      case .ResetPassword(let NewPassword, let ConfirmPassword, let Token):
          return .requestParameters(parameters: ["newPassword": NewPassword,
                                                 "confirmPassword": ConfirmPassword,
                                                 "token": Token], encoding: JSONEncoding.default)
      case .GetInvoiceByTxTransaction(let tx):
          return .requestParameters(parameters: ["tx": tx], encoding: URLEncoding.queryString)
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
