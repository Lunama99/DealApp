//
//  ViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(self.showHomeViewController), with: nil, afterDelay: 0.01)
    }
    
    @objc func showHomeViewController() {
        if let registerViewController = R.storyboard.login.instantiateInitialViewController() {
            registerViewController.modalPresentationStyle = .fullScreen
            present(registerViewController, animated: false, completion: nil)
        }
    }
}

