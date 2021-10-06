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
    @IBOutlet weak var userNameTfx: BaseTextField!
    @IBOutlet weak var passwordTfx: BaseTextField!
    @IBOutlet weak var showHideBtn: BaseButton!
    @IBOutlet weak var checkBtn: BaseButton!
    
    let facebookBtn = FBLoginButton(frame: .zero, permissions: [.publicProfile])
    let accountRepo = AccountRepository()
    var remember: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        passwordTfx.isSecureTextEntry = true
        
        userNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.userNameTfx.setwWarning(false) }
        }
        
        passwordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.passwordTfx.setwWarning(false) }
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
        
        guard verifyTfx() else { return }
        
        stateView = .loading
        accountRepo.login(UserName: userNameTfx.text ?? "", Password: passwordTfx.text ?? "", RememberMe: remember) { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if let token = model.result, model.status == true  {
                        print(token)
                        Helper.shared.userToken = token
                        self?.navigationController?.returnRootViewController()
                    } else {
                        let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                            alert.dismiss(animated: true, completion: nil)
                        })
                        self?.present(alert, animated: true, completion: nil)
                    }
                } catch {
                    print("login failed")
                }
            case .failure(_): break
//                ShowAlert.shared.showResponseMassage(string: R.string.localize.failed(preferredLanguages: self?.lang), isSuccess: false)
            }
        }
    }
    
    func verifyTfx() -> Bool {
        userNameTfx.setwWarning((userNameTfx.text?.count ?? 0) <= 0)
        passwordTfx.setwWarning((passwordTfx.text?.count ?? 0) <= 0)
        
        guard userNameTfx.text != "" && userNameTfx.text != nil else { return false }
        guard passwordTfx.text != "" && passwordTfx.text != nil else { return false }
        
        return true
    }
    
    @IBAction func facebookLoginAction(_ sender: Any) {
        facebookBtn.sendActions(for: .touchUpInside)
    }
    
    @IBAction func rememberAction(_ sender: Any) {
        remember = !remember
        checkBtn.setImage(remember ? UIImage(systemName: "checkmark") : nil, for: .normal)
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
