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
    @IBOutlet weak var idLbl: BaseLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        
        idLbl.text = "#\(Helper.shared.user.id?.split(separator: "-").first ?? "")"
        userImg.layer.cornerRadius = 34
        userImg.layer.masksToBounds = true
        userImg.sd_setImage(with: URL(string: Helper.shared.user.avatar ?? ""), completed: nil)
        userName.text = Helper.shared.user.fullName
    }
    
    @IBAction func showPersonalInfomationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.myWalletViewController.showPerson, sender: self)
    }
}
