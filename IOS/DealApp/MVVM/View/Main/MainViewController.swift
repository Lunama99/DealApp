//
//  ViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class MainViewController: BaseViewController {
    
    private let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Helper.shared.userToken != nil {
            self.getUser()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
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
                            self?.expire(message: userResponse.message ?? "")
                        }
                    } catch {
                        print("get user failed")
                    }
                case .failure(_): break
                }
            }
        }
    }
    
    func expire(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
            Helper.shared.clearUserInfor()
            self.perform(#selector(self.showLoginViewController), with: nil, afterDelay: 0.01)
        })

        present(alert, animated: true, completion: nil)
    }
}

