//
//  ReceiveViewController.swift
//  Vera
//
//  Created by Macbook on 30/06/2021.
//

import UIKit

class ReceiveViewController: BaseViewController {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var walletAddressLbl: BaseLabel!
    @IBOutlet weak var titleLbl: BaseLabel!
    @IBOutlet weak var copyBtn: BaseButton!
    @IBOutlet weak var historyView: UIView!

    var displayStyle: DisplayStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        switch displayStyle {
        case .wallet(let wallet):
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = Helper.shared.generateQRCode(from: wallet?.address ?? "")
            }
            
            walletAddressLbl.text = wallet?.address
            historyView.isHidden = false
            title = wallet?.currency
        case .normal(let string):
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = Helper.shared.generateQRCode(from: string)
            }
            walletAddressLbl.text = string
            historyView.isHidden = true
            title = "Voucher"
        case .none:
            break
        }
    }
    
    @IBAction func copyActionButton(_ sender: Any) {
        switch displayStyle {
        case .wallet(let wallet):
            Helper.shared.copyString(string: wallet?.address ?? "")
        case .normal(let string):
            Helper.shared.copyString(string: string)
        case .none:
            break
        }
    }
    
    @IBAction func historyAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.receiveViewController.showTransaction, sender: self)
    }
}

extension ReceiveViewController {
    enum DisplayStyle {
        case wallet(wallet: WalletAddress?)
        case normal(string: String)
    }
}
