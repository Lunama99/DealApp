//
//  UIViewController.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let badgeButton = BadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    enum State {
      case normal
      case loading
      case ready
      case error
    }
    
    enum AppearanceMode {
        case Dark
        case Light
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart), name: NotificationName.updateCart, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.updateCart, object: nil)
    }
    
    @objc func updateCart() {
        let itemQuantity = Helper.shared.cart?.result?.listCartItem?.map({ item -> Int in
            return item.quantity ?? 0
        }).reduce(0, +)
        
        badgeButton.badge = itemQuantity ?? 0
    }
    
    func showRightButtons() {
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
        
        let cartView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cartView.backgroundColor = .systemGray6
        cartView.layer.cornerRadius = 4
        badgeButton.center = cartView.center
        badgeButton.badgeImage = R.image.ic_cart()
        badgeButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 5)
        badgeButton.badgeImageFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        updateCart()
        badgeButton.addTarget(self, action: #selector(showCartView), for: .touchUpInside)
        cartView.addSubview(badgeButton)
        
        let cartRightBarButton = UIBarButtonItem(customView: cartView)
        
        navigationItem.rightBarButtonItems = [noticeRightBarButton, cartRightBarButton]
    }
    
    func showBackButton(mode: AppearanceMode? = nil) {
        let backButton = BaseButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.style = 4
        backButton.layer.cornerRadius = 4
        backButton.layer.masksToBounds = true
        
        let currWidth = backButton.widthAnchor.constraint(equalToConstant: 30)
        currWidth.isActive = true
        let currHeight = backButton.heightAnchor.constraint(equalToConstant: 30)
        currHeight.isActive = true
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        if let mode = mode, mode == .Light {
            backButton.backgroundColor = .systemGray6
        } else {
            backButton.backgroundColor = .clear
        }
        let backLeftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backLeftBarButton
    }
    
    func addToCartAnimation(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 0.1,
                       animations: {
            tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = self.badgeButton.convert(self.badgeButton.frame, to: nil).midX
                tempView.frame.origin.y = self.badgeButton.convert(self.badgeButton.frame, to: nil).midY
            }, completion: { _ in
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.badgeButton.badgeImageView.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    self.badgeButton.badgeImageView.animationZoom(scaleX: 1.0, y: 1.0)
                    self.navigationController?.popViewController(animated: true)
                })
            })
        })
    }
    
    @objc private func showNoticeView() {
        guard let notiveVC = R.storyboard.notification.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(notiveVC, animated: true)
    }
    
    @objc private func showCartView() {
        guard let notiveVC = R.storyboard.cart.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(notiveVC, animated: true)
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

