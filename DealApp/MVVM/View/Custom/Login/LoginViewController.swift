//
//  LoginViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var continueBtn: BaseButton!
    @IBOutlet weak var passwordTfx: BaseTextField!
    @IBOutlet weak var showHideBtn: BaseButton!
    
    let facebookBtn = FBLoginButton(frame: .zero, permissions: [.publicProfile])
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        passwordTfx.isSecureTextEntry = true
        passwordTfx.didChangeValue = { [weak self] string in
            self?.showHideBtn.isHidden = string.count == 0
        }
        
        facebookBtn.delegate = self
        facebookBtn.permissions = ["public_profile", "email"]
        facebookBtn.isHidden = true
    }
    
    @IBAction func showHideAction(_ sender: Any) {
        passwordTfx.isSecureTextEntry = !passwordTfx.isSecureTextEntry
        showHideBtn.setImage(passwordTfx.isSecureTextEntry ? UIImage(systemName: "eye.slash")
                                : UIImage(systemName: "eye"), for: .normal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        navigationController?.returnRootViewController()
    }
    
    @IBAction func facebookLoginAction(_ sender: Any) {
        facebookBtn.sendActions(for: .touchUpInside)
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        Helper.shared.getFaceBookUser(result: result) { [weak self] in
            self?.navigationController?.returnRootViewController()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Log out")
    }
}
