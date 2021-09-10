//
//  MyWalletViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class MyWalletViewController: BaseViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BaseLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        
        userImg.layer.cornerRadius = 34
        userImg.layer.masksToBounds = true
        userImg.sd_setImage(with: URL(string: Helper.shared.user?.imageURL ?? ""), placeholderImage: nil)
        userName.text = Helper.shared.user?.name
    }
    
    @IBAction func showPersonalInfomationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.myWalletViewController.showPerson, sender: self)
    }
}
