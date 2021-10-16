//
//  ReceiveViewController.swift
//  Vera
//
//  Created by Macbook on 30/06/2021.
//

import UIKit

class ReceiveViewController: BaseViewController {

    @IBOutlet weak var walletNameLbl: BaseLabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var walletAddressLbl: BaseLabel!
    @IBOutlet weak var titleLbl: BaseLabel!
    @IBOutlet weak var titleHeader: BaseButton!
    @IBOutlet weak var copyBtn: BaseButton!
    
    var wallet: WalletAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = Helper.shared.generateQRCode(from: self?.wallet?.address ?? "")
        }
        
        walletAddressLbl.text = wallet?.address
        title = wallet?.currency
    }
    
    @IBAction func backActionButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyActionButton(_ sender: Any) {
        Helper.shared.copyString(string: wallet?.address ?? "")
    }
    
    @IBAction func historyAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.receiveViewController.showTransaction, sender: self)
    }
}
