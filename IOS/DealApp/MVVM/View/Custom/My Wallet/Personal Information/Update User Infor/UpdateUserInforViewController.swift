//
//  UpdateUserInforViewController.swift
//  DealApp
//
//  Created by Macbook on 30/09/2021.
//

import UIKit

class UpdateUserInforViewController: BaseViewController {

    @IBOutlet weak var fullNameTfx: BaseTextField!
    @IBOutlet weak var emailTfx: BaseTextField!
    @IBOutlet weak var phoneNumberTfx: BaseTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countryTfx: BaseTextField!
    @IBOutlet weak var stateTfx: BaseTextField!
    @IBOutlet weak var cityTfx: BaseTextField!
    @IBOutlet weak var streetTfx: BaseTextField!
    @IBOutlet weak var avatarImg: UIImageView!
    
    let userInfor = Helper.shared.DetachedCopy(of: Helper.shared.user)!
    let accountRepo = AccountRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        showBackButton()
        
        scrollView.alwaysBounceVertical = true
        avatarImg.sd_setImage(with: URL(string: Helper.shared.user.avatar ?? ""), completed: nil)
        avatarImg.layer.cornerRadius = avatarImg.frame.size.height/2
        avatarImg.layer.masksToBounds = true
        
        fullNameTfx.text = "\(userInfor.firstName ?? "") \(userInfor.lastName ?? "")"
        emailTfx.text = userInfor.email
        phoneNumberTfx.text = userInfor.phoneNumber
        cityTfx.text = userInfor.city
        stateTfx.text = userInfor.state
        countryTfx.text = userInfor.country
        streetTfx.text = userInfor.street
        
        fullNameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 { self?.fullNameTfx.setwWarning(false) }
        }
        
        emailTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.emailTfx.setwWarning(false)
                self?.userInfor.email = string
            }
        }
        
        phoneNumberTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.phoneNumberTfx.setwWarning(false)
                self?.userInfor.phoneNumber = string
            }
        }
        
        countryTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.countryTfx.setwWarning(false)
                self?.userInfor.country = string
            }
        }
        
        stateTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.stateTfx.setwWarning(false)
                self?.userInfor.state = string
            }
        }
        
        cityTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.cityTfx.setwWarning(false)
                self?.userInfor.city = string
            }
        }
        
        streetTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.streetTfx.setwWarning(false)
                self?.userInfor.street = string
            }
        }
    }
    
    func verifyTfx() -> Bool {
        fullNameTfx.setwWarning((fullNameTfx.text?.count ?? 0) <= 0)
        emailTfx.setwWarning((emailTfx.text?.count ?? 0) <= 0)
        phoneNumberTfx.setwWarning((phoneNumberTfx.text?.count ?? 0) <= 0)
//        genderTfx.setwWarning((genderTfx.text?.count ?? 0) <= 0)
//        birthdayTfx.setwWarning(userInfor.Birthday == nil)
//        countryTfx.setwWarning((countryTfx.text?.count ?? 0) <= 0)
//        stateTfx.setwWarning((stateTfx.text?.count ?? 0) <= 0)
//        cityTfx.setwWarning((cityTfx.text?.count ?? 0) <= 0)
//        streetTfx.setwWarning((streetTfx.text?.count ?? 0) <= 0)
        
        guard fullNameTfx.text != "" && fullNameTfx.text != nil else { return false }
        guard emailTfx.text != "" && emailTfx.text != nil else { return false }
        guard phoneNumberTfx.text != "" && phoneNumberTfx.text != nil else { return false }
//        guard genderTfx.text != "" && genderTfx.text != nil else { return false }
//        guard userInfor.Birthday != nil else { return false }
//        guard countryTfx.text != "" && countryTfx.text != nil else { return false }
//        guard stateTfx.text != "" && stateTfx.text != nil else { return false }
//        guard cityTfx.text != "" && cityTfx.text != nil else { return false }
//        guard streetTfx.text != "" && streetTfx.text != nil else { return false }
        
        return true
    }
    
    @IBAction func importImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard verifyTfx() else { return }
        userInfor.fullName = fullNameTfx.text
        
        stateView = .loading
        accountRepo.updateUserInfor(user: userInfor) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        self?.accountRepo.getUser { [weak self] result in
                            self?.stateView = .ready
                            switch result {
                            case .success(let response):
                                do {
                                    let user = try response.map(User.self)
                                    Helper.shared.user = user
                                } catch {
                                    print("get user failed")
                                }
                            case .failure(_): break
                            }
                            
                            let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                if model.status == true {
                                    self?.navigationController?.popViewController(animated: true)
                                } else {
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            })
                            self?.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "", message: model.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                alert.dismiss(animated: true, completion: nil)
                        })
                        self?.present(alert, animated: true, completion: nil)
                    }
                } catch {
                    print("create account failed")
                }
            case .failure(let error):
                print(error)
//                ShowAlert.shared.showResponseMassage(string: R.string.localize.failed(preferredLanguages: self?.lang), isSuccess: false)
            }
        }
    }
}

extension UpdateUserInforViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        avatarImg.image = image
        userInfor.avatarBase64 = image.pngData()?.base64EncodedString()
        dismiss(animated: true)
    }
}

