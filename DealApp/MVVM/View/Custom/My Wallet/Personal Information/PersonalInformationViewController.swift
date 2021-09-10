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
    
    let facebookBtn = FBLoginButton(frame: .zero, permissions: [.publicProfile])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showNoticeButton()
        showBackButton()
        
        userImg.layer.cornerRadius = 34
        userImg.layer.masksToBounds = true
        userImg.sd_setImage(with: URL(string: Helper.shared.user?.imageURL ?? ""), placeholderImage: nil)
        userName.text = Helper.shared.user?.name
        
        facebookBtn.permissions = ["public_profile", "email"]
        facebookBtn.delegate = self
        facebookBtn.isHidden = true
    }

    @IBAction func editAboutMeAction(_ sender: Any) {
    }
    
    @IBAction func editContactAction(_ sender: Any) {
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        facebookLoginBtn.sendActions(for: .touchUpInside)
    }
}

extension PersonalInformationViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        navigationController?.returnRootViewController()
    }
}
