//
//  LoginViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var continueBtn: BaseButton!
    @IBOutlet weak var passwordTfx: BaseTextField!
    @IBOutlet weak var showHideBtn: BaseButton!
    
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
    }
    
    @IBAction func showHideAction(_ sender: Any) {
        passwordTfx.isSecureTextEntry = !passwordTfx.isSecureTextEntry
        showHideBtn.setImage(passwordTfx.isSecureTextEntry ? UIImage(systemName: "eye.slash")
                                : UIImage(systemName: "eye"), for: .normal)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        navigationController?.returnRootViewController()
    }
}
