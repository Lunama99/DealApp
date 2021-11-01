//
//  PersonalInformationViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit
import SDWebImage
import FBSDKLoginKit

class PersonalInformationViewController: BaseViewController {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BaseLabel!
    @IBOutlet weak var createDateLbl: BaseLabel!
    @IBOutlet weak var geneLbl: BaseLabel!
    @IBOutlet weak var birthDayLbl: BaseLabel!
    @IBOutlet weak var phoneLbl: BaseLabel!
    @IBOutlet weak var emailLbl: BaseLabel!
    @IBOutlet weak var addressLbl: BaseLabel!
    @IBOutlet weak var idLbl: BaseLabel!
    @IBOutlet weak var verifyBtn: BaseButton!
    
    let facebookBtn = FBLoginButton(frame: .zero, permissions: [.publicProfile])

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        showBackButton()
        
        let user = Helper.shared.user
        
        idLbl.text = "#\(user.id?.split(separator: "-").first ?? "")"
        userImg.layer.cornerRadius = 34
        userImg.layer.masksToBounds = true
        userImg.sd_setImage(with: URL(string: Helper.shared.user.avatar ?? ""), completed: nil)
        userName.text = Helper.shared.user.fullName
        createDateLbl.text = user.dateCreate?.toDate(format: .format3)?.toString(format: .format4)
        birthDayLbl.text = user.birthday?.toDate(format: .format5)?.toString(format: .format4)
        geneLbl.text = user.gender
        phoneLbl.text =  user.phoneNumber ?? "N/A"
        emailLbl.text = user.email ?? "N/A"
        addressLbl.text = user.fullAddress ?? "N/A"
        facebookBtn.permissions = ["public_profile", "email"]
        facebookBtn.delegate = self
        facebookBtn.isHidden = true
        
        verifyBtn.setTitle(user.verify, for: .normal)
        verifyBtn.layer.cornerRadius = 4
        verifyBtn.layer.masksToBounds = true
        
        if user.verify?.lowercased() == "verified" {
            verifyBtn.setTitleColor(UIColor.init(hexString: "#48A500"), for: .normal)
            verifyBtn.backgroundColor = UIColor.init(hexString: "#F2FFE9")
            verifyBtn.setBorderButton(color: UIColor.init(hexString: "#48A500"))
        } else {
            verifyBtn.setTitleColor(UIColor.init(hexString: "#D89935"), for: .normal)
            verifyBtn.backgroundColor = UIColor.init(hexString: "#F7CC74")
            verifyBtn.setBorderButton(color: UIColor.init(hexString: "#D89935"))
        }
    }

    @IBAction func signOutAction(_ sender: Any) {
        Helper.shared.clearUserInfor()
        stateView = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stateView = .ready
            self.navigationController?.returnRootViewController()
        }
        
//        facebookBtn.sendActions(for: .touchUpInside)
    }
    
    @IBAction func verificationAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.personalInformationViewController.showAccountVerification, sender: self)
    }
}

extension PersonalInformationViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        navigationController?.returnRootViewController()
    }
}
