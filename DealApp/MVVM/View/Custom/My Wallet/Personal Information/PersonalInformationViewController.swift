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
        let noticeView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let noticeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        noticeImg.center = noticeView.center
        noticeImg.image = R.image.ic_notification()
        noticeImg.contentMode = .scaleAspectFit
        noticeView.layer.cornerRadius = 4
        noticeView.backgroundColor = .systemGray6
        noticeView.addSubview(noticeImg)
        let noticeRightBarButton = UIBarButtonItem(customView: noticeView)
        
        navigationItem.rightBarButtonItem = noticeRightBarButton
    }

    @IBAction func editAboutMeAction(_ sender: Any) {
    }
    
    @IBAction func editContactAction(_ sender: Any) {
    }
}
