//
//  UIViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum State {
      case normal
      case loading
      case ready
      case error
    }
    
    var stateView: State = .normal {
      didSet {
        switch stateView {
        case .loading:
            SVProgressHUD.show()
        case .error:
            SVProgressHUD.dismiss()
            print("Get API response failed")
        default:
            SVProgressHUD.dismiss()
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isTransparent()
        navigationController?.hideSeparator()
    }
}

