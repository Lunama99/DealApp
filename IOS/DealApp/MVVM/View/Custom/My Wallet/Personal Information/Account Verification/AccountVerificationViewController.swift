//
//  AccountVerificationViewController.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import UIKit

class AccountVerificationViewController: BaseViewController {

    @IBOutlet weak var continueBtn: BaseButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var identityView: UIView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var step2Btn: UIButton!
    @IBOutlet weak var step3Btn: UIButton!
    @IBOutlet weak var captureFrontBtn: BaseButton!
    @IBOutlet weak var captureBackBtn: BaseButton!
    @IBOutlet weak var capturePortraitBtn: BaseButton!
    
    private var step: Int = 1 {
        didSet {
            switch step {
            case 2:
                step2Btn.setImage(R.image.ic_checked(), for: .normal)
                identityView.isHidden = true
                uploadImageView.isHidden = false
                personalView.isHidden = true
            case 3:
                step3Btn.setImage(R.image.ic_checked(), for: .normal)
                identityView.isHidden = true
                uploadImageView.isHidden = true
                personalView.isHidden = false
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        scrollView.alwaysBounceVertical = true
//        continueBtn.isEnabled = false
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if let imageView =  captureFrontBtn.imageView {
            captureFrontBtn.bringSubviewToFront(imageView)
            captureFrontBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5);
            captureFrontBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0);
        }
        
        if let imageView =  captureBackBtn.imageView {
            captureBackBtn.bringSubviewToFront(imageView)
            captureBackBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5);
            captureBackBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0);
        }
        
        if let imageView =  capturePortraitBtn.imageView {
            capturePortraitBtn.bringSubviewToFront(imageView)
            capturePortraitBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5);
            capturePortraitBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0);
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
//        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
//        userInfor.birthday = sender.date.toString()
//        birthdayTfx.setwWarning(false)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        step += 1
    }
}
