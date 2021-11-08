//
//  Helper.swift
//  Vera
//
//  Created by Macbook on 31/08/2021.
//

import Foundation
import SVProgressHUD
import KeychainSwift

class Helper {
    
    private init() {}
    
    static let shared = Helper()
    
    private let keyChain = KeychainSwift()
    
    var user: User = User()
    
    var userToken: String? {
        get {
            return keyChain.get(KeyChainName.token.rawValue)
        } set {
            if let value = newValue {
                keyChain.set(value, forKey: KeyChainName.token.rawValue)
            }
        }
    }
    
    var cart: CartReponse? {
        didSet {
            NotificationCenter.default.post(name: NotificationName.updateCart, object: nil)
        }
    }
    
    func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func clearUserInfor() {
        user = User()
        keyChain.clear()
    }
    
    func expire(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
            self.clearUserInfor()
            self.getTopViewController()?.navigationController?.returnRootViewController()
        })

        getTopViewController()?.present(alert, animated: true, completion: nil)
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    func showWebView(title: String, url: String, parent: BaseViewController) {
        guard let webViewController = R.storyboard.webView.instantiateInitialViewController() else { return }
        webViewController.webViewTitle = title
        webViewController.stringURL = url
        parent.navigationController?.pushViewController(webViewController, animated: true)
    }

    func showScan(parent: BaseViewController, completion: @escaping(String)->Void) {
        guard let scanViewController = R.storyboard.scan.instantiateInitialViewController() else { return }
        scanViewController.modalPresentationStyle = .fullScreen
        scanViewController.callBack = { value in
            completion(value)
        }
        parent.navigationController?.present(scanViewController, animated: true, completion: nil)
    }

    func copyString(string: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
        ShowAlert.shared.showCopySuccessful()
    }

//    func showInputPopup(_ displayStyle: InputPopupViewController.InputPopupStyle, parent: BaseViewController, completion: @escaping()->Void) {
//        guard let inputPopupViewController = R.storyboard.inputPopup.instantiateInitialViewController() else { return }
//        inputPopupViewController.displayStyle = displayStyle
//        inputPopupViewController.callBack = {
//            completion()
//        }
//        parent.navigationController?.present(inputPopupViewController, animated: true, completion: nil)
//    }
//
    func showQRCode(displayStyle: ReceiveViewController.DisplayStyle, parent: BaseViewController) {
        guard let receiveViewController = R.storyboard.receive.instantiateInitialViewController() else { return }
        receiveViewController.displayStyle = displayStyle
        parent.navigationController?.pushViewController(receiveViewController, animated: true)
    }

//    func currentWalllet() -> WalletModel? {
//        return RealmService.shared.getWallet().filter({$0.Mnemonic.decryptMessage() == Default.shared.getMnemonic()}).first
//    }
//
//    func getTransaction(ID: String?) -> BlockChainTransactionModel? {
//        return RealmService.shared.getTransactions().filter("ID == %@", ID ?? "").first
//    }
//
//    func getWalletTransaction(_ address: String?) -> [TransactionModel] {
//        return RealmService.shared.getTransactions().filter({$0.Address == address}).map({ chain -> [TransactionModel] in
//            return Array(chain.Transactions)
//        }).reduce([], +)
//    }
//
//    func getMarket() -> Results<MarketModel>? {
//        return RealmService.shared.getMarket()
//    }
//
//    func getAddressBook() -> Results<AddressBookModel>? {
//        return RealmService.shared.getAddressBook()
//    }
//
//    func saveWalletNamePass(name: String?, password: String?) {
//        if let wallet = currentWalllet() {
//
//            var dict: [String: Any?] = [:]
//
//            if let name = name {
//                dict["Name"] = name
//            }
//
//            if let password = password {
//                Default.shared.setValue(newValue: password, key: .Pass)
//                dict["Password"] = password.encryptMessage()
//            }
//
//            RealmService.shared.update(wallet, with: dict)
//        }
//    }
//
//    func deleteWallet() {
//        if let currentWallet = Helper.shared.currentWalllet() {
//            currentWallet.Chain.forEach { chain in
//                chain.UserAddresses.forEach { address in
//                    if let transation = getTransaction(ID: address.ID) {
//                        transation.Transactions.forEach { tran in
//                            RealmService.shared.delete(tran)
//                        }
//                        RealmService.shared.delete(transation)
//                    }
//                    RealmService.shared.delete(address)
//                }
//                RealmService.shared.delete(chain)
//            }
//            RealmService.shared.delete(currentWallet)
//
//            if let nextWallet = RealmService.shared.getWallet().first {
//                setCurrentWallet(wallet: nextWallet, currentChain: nextWallet.Chain.first)
//            } else {
//                Default.shared.removeAll()
//            }
//        }
//    }
//
//    func updateChain(chain: AddressesModel, isActive: Bool) {
//        RealmService.shared.update(chain, with: ["Active": isActive])
//    }
//
//    func saveWallet(_ model: GetAddressDataModel?, Name: String?, Password: String?, mnemonic: String?) {
//        if let currentWallet = Helper.shared.currentWalllet(), currentWallet.Mnemonic.decryptMessage() == model?.Mnemonic {
//            let newChain = ChainModel.init(ID: model?.ID,
//                                           TokenType: model?.TokenType,
//                                             Address: model?.Address,
//                                             PrivateKey: model?.PrivateKey,
//                                             Mnemonic: model?.Mnemonic,
//                                             Auth: model?.Auth,
//                                             ChainSymbol: model?.ChainSymbol,
//                                             Name: model?.Name,
//                                             DeviceAddress: model?.DeviceAddress)
//            model?.UserAddresses?.forEach({ value in
//                let newUserAddresses = AddressesModel.init(Logo: value.Logo,
//                                                           ID: value.ID,
//                                                           Name: value.Name,
//                                                           Symbol: value.Symbol,
//                                                           Decimals: value.Decimals,
//                                                           TokenType: value.TokenType,
//                                                           Active: value.Active,
//                                                           IDUserWallet: value.IDUserWallet,
//                                                           Contract: value.Contract,
//                                                           Address: value.Address,
//                                                           UserWallet: value.UserWallet,
//                                                           isManChain: true,
//                                                           Balance: nil,
//                                                           Price: nil)
//                newChain.UserAddresses.append(newUserAddresses)
//            })
//
//            RealmService.shared.addNewChain(wallet: currentWallet, newChain: newChain)
//        } else {
//            let newWallet = WalletModel.init(Name: Name,
//                                             Password: Password,
//                                             Mnemonic: mnemonic)
//            let newChain = ChainModel.init(ID: model?.ID,
//                                           TokenType: model?.TokenType,
//                                             Address: model?.Address,
//                                             PrivateKey: model?.PrivateKey,
//                                             Mnemonic: model?.Mnemonic,
//                                             Auth: model?.Auth,
//                                             ChainSymbol: model?.ChainSymbol,
//                                             Name: model?.Name,
//                                             DeviceAddress: model?.DeviceAddress)
//
//            model?.UserAddresses?.forEach({ value in
//                let newUserAddresses = AddressesModel.init(Logo: value.Logo,
//                                                           ID: value.ID,
//                                                           Name: value.Name,
//                                                           Symbol: value.Symbol,
//                                                           Decimals: value.Decimals,
//                                                           TokenType: value.TokenType,
//                                                           Active: value.Active,
//                                                           IDUserWallet: value.IDUserWallet,
//                                                           Contract: value.Contract,
//                                                           Address: value.Address,
//                                                           UserWallet: value.UserWallet,
//                                                           isManChain: true,
//                                                           Balance: nil,
//                                                           Price: nil)
//                newChain.UserAddresses.append(newUserAddresses)
//            })
//
//            newWallet.Chain.append(newChain)
//            RealmService.shared.create(newWallet)
//        }
//    }
//
//    func setCurrentWallet(wallet: WalletModel, currentChain: ChainModel?) {
//        Default.shared.setValue(newValue: wallet.Name, key: .Name)
//        Default.shared.setValue(newValue: wallet.Password.decryptMessage(), key: .Pass)
//        Default.shared.setValue(newValue: wallet.Mnemonic.decryptMessage(), key: .Mnemonic)
//        if let chain = currentChain {
//            Default.shared.setValue(newValue: chain.Name, key: .ChainName)
//            Default.shared.setValue(newValue: chain.ChainSymbol, key: .ChainSymbol)
//        }
//    }
//
//    func saveChain(chain: AddressesModel, logo: String) {
//        let newChain = AddressesModel.init(Logo: logo,
//                                           ID: UUID().uuidString,
//                                           Name: chain.Name,
//                                           Symbol: chain.Symbol,
//                                           Decimals: chain.Decimals,
//                                           TokenType: nil,
//                                           Active: true,
//                                           IDUserWallet: currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.ID,
//                                           Contract: chain.Contract,
//                                           Address: currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.Address,
//                                           UserWallet: nil,
//                                           isManChain: false,
//                                           Balance: chain.Balance,
//                                           Price: chain.Price)
//
//        if let oldToken = currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.UserAddresses.filter({$0.Name == newChain.Name}).first {
//            RealmService.shared.update(oldToken, with: ["Active": true])
//        } else {
//            RealmService.shared.addNewToken(wallet: currentWalllet(), newChain: newChain)
//        }
//    }
//
//    func saveChainBalance(ID: String, model: GetBalanceModel?) {
//        if let blockChain = currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.UserAddresses.filter({ $0.ID == ID }).first {
//            if blockChain.Price != model?.price {
//                RealmService.shared.update(blockChain, with: ["Price": model?.price])
//            }
//
//            if blockChain.Balance != model?.balance {
//                RealmService.shared.update(blockChain, with: ["Balance": model?.balance])
//            }
//        }
//    }
//
//    func saveTransaction(_ blockChain: AddressesModel?, transactions: [GetTransactionDataTransactionModel]?) {
//        if let blockTransactionDB = getTransaction(ID: blockChain?.ID ?? "") {
//            transactions?.forEach({ trans in
//                let newTransactions = TransactionModel.init(Category: trans.Category,
//                                                            Block: trans.Block,
//                                                            TimeStamp: trans.TimeStamp,
//                                                            Hash: trans.Hash,
//                                                            From: trans.From,
//                                                            To: trans.To,
//                                                            Amount: trans.Amount,
//                                                            Status: trans.Status,
//                                                            Explorer: trans.Explorer,
//                                                            Symbol: trans.Symbol)
//                if let oldChain = blockTransactionDB.Transactions.filter({$0.Hash == newTransactions.Hash}).first, !oldChain.Status {
//                    RealmService.shared.update(oldChain, with: ["Category" : newTransactions.Category,
//                                                "Block" : newTransactions.Block,
//                                            "TimeStamp": newTransactions.TimeStamp,
//                                            "Status": newTransactions.Status,
//                                            "Explorer": newTransactions.Explorer])
//                } else if blockTransactionDB.Transactions.filter({$0.Hash == newTransactions.Hash}).count == 0 {
//                    RealmService.shared.addTransaction(blockChain: blockTransactionDB, newChain: newTransactions)
//                }
//            })
//        } else {
//            let newBlockChainTransactions = BlockChainTransactionModel.init(ID: blockChain?.ID, Address: blockChain?.Address)
//            var newListTransacions: [TransactionModel] = []
//            transactions?.forEach({ trans in
//                let newTransactions = TransactionModel.init(Category: trans.Category,
//                                                            Block: trans.Block,
//                                                            TimeStamp: trans.TimeStamp,
//                                                            Hash: trans.Hash,
//                                                            From: trans.From,
//                                                            To: trans.To,
//                                                            Amount: trans.Amount,
//                                                            Status: trans.Status,
//                                                            Explorer: trans.Explorer,
//                                                            Symbol: trans.Symbol)
//                newBlockChainTransactions.Transactions.append(newTransactions)
//                newListTransacions.append(newTransactions)
//            })
//
//            RealmService.shared.create(newBlockChainTransactions)
//        }
//    }
//
//    func saveAddressBook(address: AddressBookModel) {
//        RealmService.shared.create(address)
//    }
//
//    func updateAddressBook(old: AddressBookModel, new: AddressBookModel) {
//        RealmService.shared.update(old, with: ["Name": new.Name,
//                                               "Address": new.Address,
//                                               "Description": new.Description,
//                                               "ChainName": new.ChainName,
//                                               "Logo": new.Logo])
//    }
//
//    func deleteAddressBook(address: AddressBookModel) {
//        RealmService.shared.delete(address)
//    }
//
//    func saveMarket(market: [GetMarketModel]) {
//        market.forEach { model in
//            if let oldMarket = getMarket()?.filter({$0.Symbol.uppercased() == model.Symbol?.uppercased()}).first {
//                if let oldMarketData = oldMarket.MarketData.first {
//                    RealmService.shared.update(oldMarketData, with: ["MarketCapRank": model.MarketData?.MarketCapRank ?? 0,
//                                                                     "PriceChange24H": model.MarketData?.PriceChange24H ?? 0,
//                                                                     "PriceChangePercentage7D": model.MarketData?.PriceChangePercentage7D ?? "",
//                                                                     "PriceChangePercentage24H": model.MarketData?.PriceChangePercentage24H ?? 0,
//                                                                     "MarketCapChange24H": model.MarketData?.MarketCapChange24H ?? 0,
//                                                                     "MarketCapChangePercentage24H": model.MarketData?.MarketCapChangePercentage24H ?? 0,
//                                                                     "CirculatingSupply": model.MarketData?.CirculatingSupply ?? "",
//                                                                     "TotalSupply": model.MarketData?.TotalSupply ?? 0])
//                    if let oldMarketDataCurrentPrice = oldMarketData.CurrentPrice.first {
//                        RealmService.shared.update(oldMarketDataCurrentPrice, with: ["usd": model.MarketData?.CurrentPrice?.usd ?? 0])
//                    }
//                }
//                if let oldMarketImage = oldMarket.Image.first {
//                    RealmService.shared.update(oldMarketImage, with: ["Thumb": model.Image?.Thumb ?? "",
//                                                                      "Small": model.Image?.Small ?? "",
//                                                                      "Large": model.Image?.Large ?? ""])
//                }
//            } else {
//                let newMarket = MarketModel.init(Id: model.Id,
//                                                 Name: model.Name,
//                                                 Symbol: model.Symbol,
//                                                 LastUpdated: model.LastUpdated)
//                newMarket.Image.append(MarketImageModel.init(Thumb: model.Image?.Thumb,
//                                                             Small: model.Image?.Small,
//                                                             Large: model.Image?.Large))
//                let newMarketData = MarketDataModel.init(MarketCapRank: model.MarketData?.MarketCapRank,
//                                                         PriceChange24H: model.MarketData?.PriceChange24H,
//                                                         PriceChangePercentage7D: model.MarketData?.PriceChangePercentage7D,
//                                                         PriceChangePercentage24H: model.MarketData?.PriceChangePercentage24H,
//                                                         MarketCapChange24H: model.MarketData?.MarketCapChange24H,
//                                                         MarketCapChangePercentage24H: model.MarketData?.MarketCapChangePercentage24H,
//                                                         CirculatingSupply: model.MarketData?.CirculatingSupply,
//                                                         TotalSupply: model.MarketData?.TotalSupply)
//                newMarketData.CurrentPrice.append(MarketCurrentPriceModel.init(usd: model.MarketData?.CurrentPrice?.usd))
//                newMarket.MarketData.append(newMarketData)
//                RealmService.shared.create(newMarket)
//            }
//        }
//
//    }
//
//    func calculateTotal(listChain: [AddressesModel]?) -> (balance: Double, price: Double) {
//        let total = listChain?.map { chain -> Double in
//            return chain.Price*chain.Balance
//        }.reduce(0, +) ?? 0
//
//        let mainChainPrice = listChain?.filter({$0.Address == Helper.shared.currentWalllet()?.Chain.filter("Name == %@", Helper.shared.currentChain.name).first?.Address}).first?.Price ?? 0
//        return (total/(mainChainPrice > 0 ? mainChainPrice : 1), total)
//    }
}

extension Helper {
    enum KeyChainName: String {
        case token = "token"
    }
    
    func DetachedCopy<T:Codable>(of object:T) -> T?{
        do{
            let json = try JSONEncoder().encode(object)
            return try JSONDecoder().decode(T.self, from: json)
        }
        catch let error{
            print(error)
            return nil
        }
     }
}
