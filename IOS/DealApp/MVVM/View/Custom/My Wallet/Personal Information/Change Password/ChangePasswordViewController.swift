//
//  ChangePasswordViewController.swift
//  DealApp
//
//  Created by Macbook on 29/09/2021.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var oldPasswordTfx: BaseTextField!
    @IBOutlet weak var newPasswordTfx: BaseTextField!
    @IBOutlet weak var confirmNewPasswordTfx: BaseTextField!
    @IBOutlet weak var updateBtn: BaseButton!
    
    private let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        oldPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.oldPasswordTfx.setwWarning(false) }
        }
        
        newPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.newPasswordTfx.setwWarning(false) }
        }
        
        confirmNewPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.confirmNewPasswordTfx.setwWarning(false) }
        }
    }
    
    func verifyTfx() -> Bool {
        oldPasswordTfx.setwWarning((oldPasswordTfx.text?.count ?? 0) <= 0)
        newPasswordTfx.setwWarning((newPasswordTfx.text?.count ?? 0) <= 0)
        confirmNewPasswordTfx.setwWarning((confirmNewPasswordTfx.text?.count ?? 0) <= 0)
        
        guard oldPasswordTfx.text != "" && oldPasswordTfx.text != nil else { return false }
        guard newPasswordTfx.text != "" && newPasswordTfx.text != nil else { return false }
        guard confirmNewPasswordTfx.text != "" && confirmNewPasswordTfx.text != nil else { return false }

        guard newPasswordTfx.text == confirmNewPasswordTfx.text else {
            let alert = UIAlertController(title: "", message: "Password does not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    @IBAction func updateAction(_ sender: Any) {
        guard verifyTfx() else { return }
        
        stateView = .loading
        accountRepo.changePassword(OldPassword: oldPasswordTfx.text ?? "", NewPassword: newPasswordTfx.text ?? "") { [weak self] result in
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
}
