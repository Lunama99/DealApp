//
//  ForgotPasswordViewController.swift
//  DealApp
//
//  Created by Macbook on 28/09/2021.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTfx: BaseTextField!
    @IBOutlet weak var sendBtn: BaseButton!

    private let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        emailTfx.didChangeValue = { [weak self] string in
            self?.sendBtn.isEnabled = string.count > 0
        }
    }
    
    @IBAction func sentAction(_ sender: Any) {
        stateView = .loading
        accountRepo.forgotPassword(Email: emailTfx.text ?? "") { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                        if model.status == true {
                            self?.performSegue(withIdentifier: R.segue.forgotPasswordViewController.showResetPassword, sender: self)
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                    self?.present(alert, animated: true, completion: nil)
                } catch {
                    print("login failed")
                }
            case .failure(_): break
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
