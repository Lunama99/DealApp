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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: R.font.poppinsMedium(size: 16)!]
    }
    
    func showNoticeButton() {
        let noticeView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let noticeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        noticeImg.center = noticeView.center
        noticeImg.image = R.image.ic_notification()
        noticeImg.contentMode = .scaleAspectFit
        noticeView.layer.cornerRadius = 4
        noticeView.backgroundColor = .systemGray6
        noticeView.addSubview(noticeImg)
        noticeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNoticeView)))
        let noticeRightBarButton = UIBarButtonItem(customView: noticeView)
        navigationItem.rightBarButtonItem = noticeRightBarButton
    }
    
    func showBackButton() {
        let backButton = BaseButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.style = 4
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backLeftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backLeftBarButton
    }
    
    @objc private func showNoticeView() {
        guard let notiveVC = R.storyboard.notification.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(notiveVC, animated: true)
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

