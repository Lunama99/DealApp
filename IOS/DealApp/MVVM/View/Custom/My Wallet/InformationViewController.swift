//
//  InformationViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class InformationController: BaseViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BaseLabel!
    @IBOutlet weak var idLbl: BaseLabel!
    @IBOutlet weak var listVendorView: UIView!
    @IBOutlet weak var listVendorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerVendorView: UIView!
    @IBOutlet weak var registerVendorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerPartnerView: UIView!
    @IBOutlet weak var registerPartnerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userTypeLbl: BaseLabel!
    
    private let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showRightButtons()

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
        
        if (Helper.shared.user.type?.filter({$0.type == 1}).count ?? 0) > 0 {
            registerPartnerView.isHidden = true
            registerPartnerHeightConstraint.constant = 0
        } else {
            registerPartnerView.isHidden = false
            registerPartnerHeightConstraint.constant = 100
        }

        if let userType = Helper.shared.user.type {
            if userType.count == 3 {
                let partner = TypeUser.init(rawValue: userType.filter({$0.type == 1}).first?.type ?? 0)?.title ?? ""
                let vendor = TypeUser.init(rawValue: userType.filter({$0.type == 2}).first?.type ?? 0)?.title ?? ""
                userTypeLbl.text = "\(vendor)/\(partner)"
            } else if userType.count == 2 {
                let value = TypeUser.init(rawValue: userType.filter({$0.type != 0}).first?.type ?? 0)?.title ?? ""
                userTypeLbl.text = value
            } else {
                userTypeLbl.text = TypeUser.init(rawValue: userType.last?.type ?? 0)?.title
            }
        }
    }
    
    @IBAction func showPersonalInfomationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.informationController.showPerson, sender: self)
    }
    
    @IBAction func settingAction(_ sender: Any) {
    }
    
    @IBAction func registerPartnerAction(_ sender: Any) {
        stateView = .loading
        accountRepo.registerPartner { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    
                    let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                        if model.status == true {
                            self?.accountRepo.getUser { [weak self] (_) in
                                self?.setupView()
                            }
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                    self?.present(alert, animated: true, completion: nil)
                } catch {
                    print("register partner failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
