//
//  TopUpViewModel.swift
//  DealApp
//
//  Created by Macbook on 09/10/2021.
//

import Foundation

class TopUpViewModel {
    
    private let walletRepo = WalletRepository()
    var listAdress: Observable<[WalletAddress]> = Observable([])
    var coinDeposit: Observable<[CoinDeposit]> = Observable([])
    var walletBalance: Observable<WalletBalance> = Observable(WalletBalance())
    var searchBarText: String = ""
    
    func getCoinDeposit(completion: @escaping(()->Void)) {
        walletRepo.getCoinDeposit { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let coinResponse = try response.map(GetCoinDeposit.self)
                    if let listCoin = coinResponse.result, coinResponse.status == true {
                        self?.coinDeposit.value = listCoin
                        completion()
                    } else {
                        Helper.shared.expire(message: coinResponse.message ?? "")
                    }
                } catch {
                    print("get wallet address failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAddress(symbol: String, completion: @escaping(()->Void)) {
        walletRepo.getWalletAddress(currency: symbol) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let walletResponse = try response.map(GetWalletAddress.self)
                    if let walleAddress = walletResponse.result, walletResponse.status == true {
                        self?.listAdress.value = walleAddress
                        completion()
                    } else {
                        Helper.shared.expire(message: walletResponse.message ?? "")
                    }
                } catch {
                    print("get wallet address failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterDepositCoin() -> [CoinDeposit] {
        if searchBarText.count > 0 {
            return coinDeposit.value?.filter({($0.currency?.lowercased() ?? "").contains(searchBarText.lowercased())}) ?? []
        } else {
            return coinDeposit.value ?? []
        }
    }
    
    func getBalance(completion: @escaping(()->Void)) {
        walletRepo.getBalance { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let balanceResponse = try response.map(GetWalletBalance.self)
                    if let walletBalance = balanceResponse.result, balanceResponse.status == true {
                        self?.walletBalance.value = walletBalance.first
                        completion()
                    } else {
                        Helper.shared.expire(message: balanceResponse.message ?? "")
                    }
                } catch {
                    print("get balance failed")
                }
            case .failure(_): break
            }
        }
    }
}
