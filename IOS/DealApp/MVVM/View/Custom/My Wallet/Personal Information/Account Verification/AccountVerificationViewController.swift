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
    @IBOutlet weak var issueOnDatePicker: UIDatePicker!
    @IBOutlet weak var issueOnTfx: BaseTextField!
    @IBOutlet weak var identityView: UIView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var step2Btn: UIButton!
    @IBOutlet weak var step3Btn: UIButton!
    @IBOutlet weak var captureFrontBtn: BaseButton!
    @IBOutlet weak var captureBackBtn: BaseButton!
    @IBOutlet weak var capturePortraitBtn: BaseButton!
    @IBOutlet weak var cardNumberTfx: BaseTextField!
    @IBOutlet weak var cardPlaceTfx: BaseTextField!
    @IBOutlet weak var portraitImg: UIImageView!
    @IBOutlet weak var fulNameTfx: BaseTextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var birthDayPicker: UIDatePicker!
    @IBOutlet weak var birthDayTfx: BaseTextField!
    @IBOutlet weak var frontImageLbl: BaseLabel!
    @IBOutlet weak var backImageLbl: BaseLabel!
    
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
                
                user.gender = "Male"
            default: break
            }
        }
    }
    
    private let accountRepo = AccountRepository()
    private let imagePicker = UIImagePickerController()
    private var user = FormVerifyUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        scrollView.alwaysBounceVertical = true
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        portraitImg.layer.cornerRadius = portraitImg.frame.size.height/2
        portraitImg.layer.masksToBounds = true
        portraitImg.contentMode = .scaleAspectFill
        
        birthDayPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        issueOnDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        cardPlaceTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.cardPlaceTfx.setwWarning(false)
                self?.user.cardPlace = string
            }
        }
        
        cardNumberTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.cardNumberTfx.setwWarning(false)
                self?.user.cardNumber = string
            }
        }
        
        fulNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.fulNameTfx.setwWarning(false)
                self?.user.fullName = string
            }
        }
        
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
    
    func verifyTfx() -> Bool {
        switch step {
        case 1:
            cardNumberTfx.setwWarning((cardNumberTfx.text?.count ?? 0) <= 0)
            cardPlaceTfx.setwWarning((cardPlaceTfx.text?.count ?? 0) <= 0)
            issueOnTfx.setwWarning((user.issuedOn?.count ?? 0) <= 0)
            captureFrontBtn.setwWarning(user.fontImage == nil)
            captureBackBtn.setwWarning(user.backImage == nil)
            
            guard cardNumberTfx.text != "" && cardNumberTfx.text != nil else { return false }
            guard cardPlaceTfx.text != "" && cardPlaceTfx.text != nil else { return false }
            guard (user.issuedOn?.count ?? 0) > 0 else { return false }
            guard user.fontImage != nil else { return false }
            guard user.backImage != nil else { return false }

            return true
        case 2:
            capturePortraitBtn.setwWarning(user.portraitImage == nil)
            guard user.portraitImage != nil else { return false }
            
            return true
        case 3:
            fulNameTfx.setwWarning((fulNameTfx.text?.count ?? 0) <= 0)
            birthDayTfx.setwWarning((user.birthday?.count ?? 0) <= 0)
            
            guard (user.birthday?.count ?? 0) > 0 else { return false }
            guard fulNameTfx.text != "" && fulNameTfx.text != nil else { return false }
            
            return true
        default:
            return false
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        if sender == issueOnDatePicker {
            user.issuedOn = sender.date.toString(format: .format7)
            issueOnTfx.setwWarning(false)
        } else {
            user.birthday = sender.date.toString(format: .format7)
            birthDayTfx.setwWarning(false)
        }

    }
    
    @IBAction func captureFrontAction(_ sender: Any) {
        imagePicker.restorationIdentifier = ImagePicker.Front.rawValue
        present(imagePicker, animated: true)
    }
    
    @IBAction func captureBackAction(_ sender: Any) {
        imagePicker.restorationIdentifier = ImagePicker.Back.rawValue
        present(imagePicker, animated: true)
    }
    
    @IBAction func capturePortraitTfx(_ sender: Any) {
        imagePicker.restorationIdentifier = ImagePicker.Portrait.rawValue
        present(imagePicker, animated: true)
    }
    
    @IBAction func maleAction(_ sender: Any) {
        maleBtn.setImage(R.image.ic_checked(), for: .normal)
        femaleBtn.setImage(R.image.ic_uncheck(), for: .normal)
        user.gender = "Male"
    }
    
    @IBAction func femaleAction(_ sender: Any) {
        maleBtn.setImage(R.image.ic_uncheck(), for: .normal)
        femaleBtn.setImage(R.image.ic_checked(), for: .normal)
        user.gender = "Female"
    }
    
    @IBAction func continueAction(_ sender: Any) {
        guard verifyTfx() else { return }
        if step == 3 {
            stateView = .loading
            accountRepo.formVerifyUser(User: user) { [weak self] result in
                self?.stateView = .ready
                switch result {
                case .success(let response):
                    do {
                        let model = try response.map(DefaultResponse.self)
                        
                        let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                            if model.status == true {
                                self?.navigationController?.popViewController(animated: true)
                            } else {
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                        self?.present(alert, animated: true, completion: nil)
                    } catch {
                        print("verify account failed")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            step += 1
        }
    }
}

extension AccountVerificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let filename = (info[.imageURL] as? NSURL)?.lastPathComponent ?? ""
        
        switch picker.restorationIdentifier {
        case ImagePicker.Front.rawValue:
            user.fontImage = image.pngData()?.base64EncodedString()
            frontImageLbl.text = filename
            captureFrontBtn.setwWarning(false)
        case ImagePicker.Back.rawValue:
            user.backImage = image.pngData()?.base64EncodedString()
            backImageLbl.text = filename
            captureBackBtn.setwWarning(false)
        case ImagePicker.Portrait.rawValue:
            portraitImg.image = image
            user.portraitImage = image.pngData()?.base64EncodedString()
            capturePortraitBtn.setwWarning(false)
        default: break
        }
        dismiss(animated: true)
    }
}

extension AccountVerificationViewController {
    enum ImagePicker: String {
        case Front = "Front"
        case Back = "Back"
        case Portrait = "Portrait"
    }
}
