//
//  LoginViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import FirebaseMessaging

class LoginViewController: BaseViewController {

    @IBOutlet weak var continueBtn: BaseButton!
    @IBOutlet weak var userNameTfx: BaseTextField!
    @IBOutlet weak var passwordTfx: BaseTextField!
    @IBOutlet weak var showHideBtn: BaseButton!
    @IBOutlet weak var checkBtn: BaseButton!
    
    let accountRepo = AccountRepository()
    var remember: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        passwordTfx.isSecureTextEntry = true
        checkBtn.layer.borderWidth = !remember ? 1 : 0
        userNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.userNameTfx.setwWarning(false) }
        }
        
        passwordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.passwordTfx.setwWarning(false) }
            self?.showHideBtn.isHidden = string.count == 0
        }
    }
    
    @IBAction func showHideAction(_ sender: Any) {
        passwordTfx.isSecureTextEntry = !passwordTfx.isSecureTextEntry
        showHideBtn.setImage(passwordTfx.isSecureTextEntry ? UIImage(systemName: "eye.slash")
                                : UIImage(systemName: "eye"), for: .normal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        guard verifyTfx() else { return }
        
        let token = Messaging.messaging().fcmToken ?? ""
        print(token)
        
        stateView = .loading
        
        accountRepo.login(UserName: userNameTfx.text ?? "", Password: passwordTfx.text ?? "", RememberMe: remember, TokenDevice: token) { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if let token = model.result, model.status == true  {
                        print("token: \(token)")
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
    
    @IBAction func rememberAction(_ sender: Any) {
        remember = !remember
        checkBtn.layer.borderWidth = !remember ? 1 : 0
        checkBtn.setImage(remember ? R.image.ic_checkbox_blue() : nil, for: .normal)
    }
}
