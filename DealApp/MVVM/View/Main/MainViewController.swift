//
//  ViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import FBSDKLoginKit

class MainViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                     parameters: ["fields": "email, name"],
                                                     tokenString: token,
                                                     version: nil,
                                                     httpMethod: .get)
            request.start { connection, result, error in
                self.perform(#selector(self.showHomeViewController), with: nil, afterDelay: 0.01)
            }
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

