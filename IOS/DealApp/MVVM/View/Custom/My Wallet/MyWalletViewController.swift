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
    @IBOutlet weak var listVendorView: UIView!
    @IBOutlet weak var listVendorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerVendorView: UIView!
    @IBOutlet weak var registerVendorHeightConstraint: NSLayoutConstraint!
    
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
        
        if (Helper.shared.user.type?.filter({$0.type == 2}).count ?? 0) > 0 {
            registerVendorView.isHidden = true
            registerVendorHeightConstraint.constant = 0
            
            listVendorView.isHidden = false
            listVendorHeightConstraint.constant = 70
        } else {
            registerVendorView.isHidden = false
            registerVendorHeightConstraint.constant = 100
            
            listVendorView.isHidden = true
            listVendorHeightConstraint.constant = 0
        }
    }
    
    @IBAction func showPersonalInfomationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.myWalletViewController.showPerson, sender: self)
    }
    
    @IBAction func registerPartnerAction(_ sender: Any) {
    }
    
    @IBAction func registerVendorAction(_ sender: Any) {
    }
}
