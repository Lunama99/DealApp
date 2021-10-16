//
//  AddNewAddressViewController.swift
//  DealApp
//
//  Created by Macbook on 15/10/2021.
//

import UIKit

class AddNewAddressViewController: BaseViewController {

    @IBOutlet weak var phoneNumberTfx: BaseTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countryTfx: BaseTextField!
    @IBOutlet weak var stateTfx: BaseTextField!
    @IBOutlet weak var cityTfx: BaseTextField!
    @IBOutlet weak var streetTfx: BaseTextField!
    @IBOutlet weak var districtTfx: BaseTextField!
    @IBOutlet weak var wardTfx: BaseTextField!

    var address = VendorAddress()
    var callBack: ((VendorAddress)->Void)?
    var displayStyle: DisplayStyle = .AddNew
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        showBackButton()
        
        if displayStyle == .AddNew {
            title = "Add New Address"
        } else {
            title = "Update Address"
        }
        
        scrollView.alwaysBounceVertical = true
        phoneNumberTfx.text = address.phoneNumber
        cityTfx.text = address.city
        stateTfx.text = address.state
        countryTfx.text = address.country
        streetTfx.text = address.street
        wardTfx.text = address.ward
        districtTfx.text = address.district
        
        phoneNumberTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.address.phoneNumber = string
            }
        }
        
        countryTfx.didChangeValue = { [weak self] string in
            self?.address.country = string
        }
        
        stateTfx.didChangeValue = { [weak self] string in
            self?.address.state = string
        }
        
        districtTfx.didChangeValue = { [weak self] string in
            self?.address.district = string
        }
        
        wardTfx.didChangeValue = { [weak self] string in
            self?.address.ward = string
        }
        
        cityTfx.didChangeValue = { [weak self] string in
            self?.address.city = string
        }
        
        streetTfx.didChangeValue = { [weak self] string in
            self?.address.street = string
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        callBack?(address)
        navigationController?.popViewController(animated: true)
    }
}

extension AddNewAddressViewController {
    enum DisplayStyle {
        case AddNew
        case Update
    }
}
