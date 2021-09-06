//
//  PersonalInformationViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class PersonalInformationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showNoticeButton()
        showBackButton()
    }

    @IBAction func editAboutMeAction(_ sender: Any) {
    }
    
    @IBAction func editContactAction(_ sender: Any) {
    }
}
