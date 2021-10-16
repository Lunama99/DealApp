//
//  UIAlert.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import BRYXBanner

class ShowAlert {
    static let shared = ShowAlert()
    var banner = Banner()

//
//    func showResponseMassage(string: String, isSuccess: Bool = true) {
//        banner.dismiss()
//        banner = Banner(title: string, subtitle: "", image: isSuccess ? R.image.ic_transactiondetail_check() : R.image.ic_close() , backgroundColor: UIColor.init(hexString: isSuccess ? "#009944" : "#cf000f"))
//        banner.dismissesOnSwipe = true
//        banner.show(duration: 2)
//    }

    func showCopySuccessful() {
        banner.dismiss()
        banner = Banner(title: "Copied", subtitle: "", image: nil, backgroundColor: UIColor.init(hexString: "#009944"))
        banner.dismissesOnSwipe = true
        banner.show(duration: 2)
    }

//    func mnemonicSelectIsWrong(_ vc: UIViewController?) {
//        banner.dismiss()
//        banner = Banner(title: R.string.localize.tryAgain(preferredLanguages: lang), subtitle: R.string.localize.wrongMnemonic(preferredLanguages: lang), image: R.image.ic_close(), backgroundColor: UIColor.init(hexString: "#cf000f"))
//        banner.dismissesOnSwipe = true
//        banner.show(duration: 2)
//    }
//
//    func inputAmountInvalid(_ vc: UIViewController?) {
//        banner.dismiss()
//        banner = Banner(title: R.string.localize.pleaseInputAgain(preferredLanguages: lang), subtitle: R.string.localize.amountInvalid(preferredLanguages: lang), image: R.image.ic_close(), backgroundColor: UIColor.init(hexString: "#cf000f"))
//        banner.dismissesOnSwipe = true
//        banner.show(duration: 2)
//    }
//
//    func inputMnemonicWrong(_ vc: UIViewController?) {
//        banner.dismiss()
//        banner = Banner(title: R.string.localize.pleaseInputAgain(preferredLanguages: lang), subtitle: R.string.localize.valueInvalid(preferredLanguages: lang), image: R.image.ic_close(), backgroundColor: UIColor.init(hexString: "#cf000f"))
//        banner.dismissesOnSwipe = true
//        banner.show(duration: 2)
//    }
//
//    func deleteChainAlert(_ vc: UIViewController?, completion: @escaping()->Void) {
//        let alert = UIAlertController(title: "", message: R.string.localize.deleteToken(preferredLanguages: lang), preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: R.string.localize.oK(preferredLanguages: lang), style: .default, handler: { alert in
//            completion()
//        }))
//        alert.addAction(UIAlertAction(title: R.string.localize.cancel(preferredLanguages: lang), style: .cancel, handler: nil))
//        vc?.present(alert, animated: true, completion: nil)
//    }
//
//    func importWalletError(_ vc: UIViewController?) {
//        banner.dismiss()
//        banner = Banner(title: R.string.localize.pleaseInputAgain(preferredLanguages: lang), subtitle: R.string.localize.walletUsed(preferredLanguages: lang), image: R.image.ic_close(), backgroundColor: UIColor.init(hexString: "#cf000f"))
//        banner.dismissesOnSwipe = true
//        banner.show(duration: 2)
//    }
//
//    func deleteAddressBookAlert(_ vc: UIViewController?, completion: @escaping()->Void) {
//        let alert = UIAlertController(title: "", message: R.string.localize.deleteAddress(preferredLanguages: lang), preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: R.string.localize.oK(preferredLanguages: lang), style: .default, handler: { alert in
//            completion()
//        }))
//        alert.addAction(UIAlertAction(title: R.string.localize.cancel(preferredLanguages: lang), style: .cancel, handler: nil))
//        vc?.present(alert, animated: true, completion: nil)
//    }
}
