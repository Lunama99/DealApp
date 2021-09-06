//
//  MyWalletViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class MyWalletViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
    }
    
    @IBAction func showPersonalInfomationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.myWalletViewController.showPerson, sender: self)
    }
}
