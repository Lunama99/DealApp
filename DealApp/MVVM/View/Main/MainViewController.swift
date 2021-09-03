//
//  ViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class MainViewController: BaseViewController {
    
    var isLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLogin {
            self.perform(#selector(self.showHomeViewController), with: nil, afterDelay: 0.01)
        } else {
            self.perform(#selector(self.showLoginViewController), with: nil, afterDelay: 0.01)
        }        
    }
    
    @objc func showLoginViewController() {
        if let registerViewController = R.storyboard.login.instantiateInitialViewController() {
            registerViewController.modalPresentationStyle = .fullScreen
            present(registerViewController, animated: false, completion: nil)
        }
    }
    
    @objc func showHomeViewController() {
        if let registerViewController = R.storyboard.tabbar.instantiateInitialViewController() {
            registerViewController.modalPresentationStyle = .fullScreen
            present(registerViewController, animated: true, completion: nil)
        }
    }
}

