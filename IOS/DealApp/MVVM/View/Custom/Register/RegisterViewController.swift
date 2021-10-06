//
//  RegisterViewController.swift
//  DealApp
//
//  Created by Macbook on 24/09/2021.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var firstNameTfx: BaseTextField!
    @IBOutlet weak var lastNameTfx: BaseTextField!
    @IBOutlet weak var userNameTfx: BaseTextField!
    @IBOutlet weak var emailTfx: BaseTextField!
    @IBOutlet weak var passwordTfx: BaseTextField!
    @IBOutlet weak var confirmPasswordTfx: BaseTextField!
    
    let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        firstNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.firstNameTfx.setwWarning(false) }
        }
        
        lastNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.lastNameTfx.setwWarning(false) }
        }
        
        emailTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.emailTfx.setwWarning(false) }
        }
        
        userNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.userNameTfx.setwWarning(false) }
        }
        
        passwordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.passwordTfx.setwWarning(false) }
        }
        
        confirmPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.confirmPasswordTfx.setwWarning(false) }
        }
    }
    
    func verifyTfx() -> Bool {
        firstNameTfx.setwWarning((firstNameTfx.text?.count ?? 0) <= 0)
        lastNameTfx.setwWarning((lastNameTfx.text?.count ?? 0) <= 0)
        emailTfx.setwWarning((emailTfx.text?.count ?? 0) <= 0)
        userNameTfx.setwWarning((userNameTfx.text?.count ?? 0) <= 0)
        passwordTfx.setwWarning((passwordTfx.text?.count ?? 0) <= 0)
        confirmPasswordTfx.setwWarning((confirmPasswordTfx.text?.count ?? 0) <= 0)
        
        guard firstNameTfx.text != "" && firstNameTfx.text != nil else { return false }
        guard lastNameTfx.text != "" && lastNameTfx.text != nil else { return false }
        guard emailTfx.text != "" && emailTfx.text != nil else { return false }
        guard userNameTfx.text != "" && userNameTfx.text != nil else { return false }
        guard passwordTfx.text != "" && passwordTfx.text != nil else { return false }
        guard confirmPasswordTfx.text != "" && confirmPasswordTfx.text != nil else { return false }
        guard passwordTfx.text == confirmPasswordTfx.text else {
            let alert = UIAlertController(title: "", message: "Password does not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    @IBAction func continueAction(_ sender: Any) {

        guard verifyTfx() else { return }
        
        stateView = .loading
        accountRepo.register(FullName: "\(firstNameTfx.text ?? "") \(lastNameTfx.text ?? "")" , Sponsor: nil, Email: emailTfx.text ?? "", UserName: userNameTfx.text ?? "", Password: passwordTfx.text ?? "", Type: nil) { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    
                    let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                        if model.status == true {
                            self?.navigationController?.popViewController(animated: true)
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                    self?.present(alert, animated: true, completion: nil)
                } catch {
                    print("create account failed")
                }
            case .failure(_): break
//                ShowAlert.shared.showResponseMassage(string: R.string.localize.failed(preferredLanguages: self?.lang), isSuccess: false)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
