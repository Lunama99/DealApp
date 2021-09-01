//
//  API.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation
import Moya

public enum API {
    case getAddressByMnemonic(chainName: String, mnemonic: String)
    case getAddressByPrivateKey(chainName: String, privateKey: String)
    case getMnemonic
    case getBlockChains
    case getLogo(chainName:String, symbol: String?)
    case getBalance(chainName: String, symbol: String, address: String, contract: String, decimals: Int)
    case getRecommendToken(chainName: String)
    case getTransaction(chainName: String, symbol: String, address: String, contract: String, decimals: Int, lastTime: Double)
    case send(mnemonic: String, chainName: String, symbol: String, contract: String, decimals: Int, fromAddress: String, toAddress: String ,amount: Double)
    case getPrice(symbol: String)
    case searchToken(chainName: String, key: String)
    case searchTokenBySmartContract(chainName: String, smartContract: String)
    case getMarket
    case getChainID
}

extension API: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .getPrice:
            return URL(string: "https://api.binance.com/api/v3/ticker")!
        case .getChainID:
            return URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest")!
        default:
            return URL(string: "https://wallet.verafti.uk/api")!
        }
    }
    
    public var headers: [String: String]? {
        switch self {
//        case .send:
//            let auth = Helper.shared.currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.Auth ?? ""
//            return ["auth": auth,
//                    "Content-Type": "application/json"]
        case .getChainID:
            return ["X-CMC_PRO_API_KEY": "f0911813-55c6-4c70-a58c-91d2b0d3e9eb"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    public var method: Moya.Method {
      switch self {
      case .getAddressByMnemonic: return .get
      case .getAddressByPrivateKey: return .get
      case .getMnemonic: return .get
      case .getBlockChains: return .get
      case .getLogo: return .get
      case .getRecommendToken: return .get
      case .getBalance: return .get
      case .getTransaction: return .get
      case .send: return .post
      case .getPrice: return .get
      case .searchToken: return .get
      case .searchTokenBySmartContract: return .get
      case .getMarket: return .get
      case .getChainID: return .get
      }
    }

    public var path: String {
        switch self {
        case .getAddressByMnemonic: return "/GetAddress"
        case .getAddressByPrivateKey: return "/GetAddressByPrivateKey"
        case .getMnemonic: return "/GetMnemonic"
        case .getBlockChains: return "/GetBlockChain"
        case .getLogo: return "/GetLogo"
        case .getRecommendToken: return "/RecommendToken"
        case .getBalance: return "/GetBalance"
        case .getTransaction: return "/GetTransaction"
        case .send: return "/Send"
        case .getPrice: return "/price"
        case .searchToken: return "/SearchToken"
        case .searchTokenBySmartContract: return "/SearchTokenBySmartContract"
        case .getMarket: return "/MarketCap"
        case .getChainID: return ""
        }
    }
    
    public var task: Task {
      switch self {
      case .getAddressByMnemonic(let chainName, let mnemonic):
        return .requestParameters(parameters: ["mnemonic": mnemonic,
                                               "chainName": chainName,
                                               "deviceAddress": UIDevice.current.identifierForVendor?.uuidString ?? ""],
                                    encoding: URLEncoding.default)
      case .getAddressByPrivateKey(let chainName, let privateKey):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "privateKey": privateKey,
                                               "deviceAddress": UIDevice.current.identifierForVendor?.uuidString ?? ""],
                                    encoding: URLEncoding.default)
      case .getBalance(let chainName, let symbol, let address, let contract, let decimals):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "symbol": symbol,
                                               "address": address,
                                               "contract": contract,
                                               "decimals": decimals],
                                  encoding: URLEncoding.default)
      case .getLogo(let chainName, let symbol):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "symbol": symbol ?? ""],
                                  encoding: URLEncoding.default)
      case .getRecommendToken(let chainName):
        return .requestParameters(parameters: ["chainName": chainName], encoding: URLEncoding.default)
      case .getTransaction(let chainName, let symbol, let address, let contract, let decimals, let lastTime):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "symbol": symbol,
                                               "address": address,
                                               "contract": contract,
                                               "decimals": decimals,
                                               "lastTime": lastTime],
                                  encoding: URLEncoding.default)
      case .send(let mnemonic, let chainName, let symbol, let contract, let decimals, let fromAddress, let toAddress, let amount):
        return .requestParameters(parameters: ["mnemonic": mnemonic,
                                               "chainName": chainName,
                                               "symbol": symbol,
                                               "contract": contract,
                                               "decimals": decimals,
                                               "fromAddress": fromAddress,
                                               "toAddress": toAddress,
                                               "amount": amount],
                                  encoding: URLEncoding.queryString)
      case .getPrice(let symbol):
        return .requestParameters(parameters: ["symbol": "\(symbol)USDT"], encoding: URLEncoding.default)
      case .searchToken(let chainName, let key):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "key": key],
                                  encoding: URLEncoding.default)
      case .searchTokenBySmartContract(let chainName, let smartContract):
        return .requestParameters(parameters: ["chainName": chainName,
                                               "smartContract": smartContract],
                                  encoding: URLEncoding.default)
      case .getChainID:
        return .requestParameters(parameters: ["limit": 5000], encoding: URLEncoding.default)
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

