//
//  ViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import FBSDKLoginKit

class MainViewController: BaseViewController {
    
    private let accountRepo = AccountRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let token = AccessToken.current, !token.isExpired {
//            let token = token.tokenString
//            let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
//                                                     parameters: ["fields": "email, name"],
//                                                     tokenString: token,
//                                                     version: nil,
//                                                     httpMethod: .get)
//            request.start { connection, result, error in
        if Helper.shared.userToken != nil {
            stateView = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.getUser()
            }
//            }
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
    
    func getUser() {
        stateView = .loading
        self.accountRepo.getUser { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let userResponse = try response.map(GetUserResponse.self)
                    if let user = userResponse.result, userResponse.status == true {
                        Helper.shared.user = user
                        self?.perform(#selector(self?.showHomeViewController), with: nil, afterDelay: 0.01)
                    } else {
                        Helper.shared.expire(message: userResponse.message ?? "")
                    }
                } catch {
                    print("get user failed")
                }
            case .failure(_): break
            }
        }
    }
}

