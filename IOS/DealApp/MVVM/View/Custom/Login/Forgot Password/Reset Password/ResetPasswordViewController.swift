//
//  ResetPasswordViewController.swift
//  DealApp
//
//  Created by Macbook on 28/10/2021.
//

import UIKit

class ResetPasswordViewController: BaseViewController {

    @IBOutlet weak var newPasswordTfx: BaseTextField!
    @IBOutlet weak var confirmPasswordTfx: BaseTextField!
    @IBOutlet weak var codeTfx: BaseTextField!
    @IBOutlet weak var updateBtn: BaseButton!
    
    private let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        newPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.newPasswordTfx.setwWarning(false) }
        }
        
        confirmPasswordTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.confirmPasswordTfx.setwWarning(false) }
        }
        
        codeTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.codeTfx.setwWarning(false) }
        }
    }
    
    func verifyTfx() -> Bool {
        newPasswordTfx.setwWarning((newPasswordTfx.text?.count ?? 0) <= 0)
        confirmPasswordTfx.setwWarning((confirmPasswordTfx.text?.count ?? 0) <= 0)
        codeTfx.setwWarning((codeTfx.text?.count ?? 0) <= 0)
        
        guard newPasswordTfx.text != "" && newPasswordTfx.text != nil else { return false }
        guard confirmPasswordTfx.text != "" && confirmPasswordTfx.text != nil else { return false }
        guard codeTfx.text != "" && codeTfx.text != nil else { return false }
        
        return true
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        guard verifyTfx() else { return }
        stateView = .loading
        accountRepo.resetPassword(NewPassword: newPasswordTfx.text ?? "", ConfirmPassword: confirmPasswordTfx.text ?? "", Token: codeTfx.text ?? "") { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                        if model.status == true {
                            self?.navigationController?.returnRootViewController()
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                    self?.present(alert, animated: true, completion: nil)
                } catch {
                    print("reset password failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
