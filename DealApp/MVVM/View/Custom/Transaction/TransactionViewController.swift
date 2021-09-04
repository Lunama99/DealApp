//
//  TransactionViewController.swift
//  DealApp
//
//  Created by Macbook on 04/09/2021.
//

import UIKit

class TransactionViewController: BaseViewController {

    @IBOutlet weak var shoppingView: BaseView!
    @IBOutlet weak var topUpView: BaseView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
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
        
        tableView.register(R.nib.transactionTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(_ cell: TransactionTableViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_transaction_demo_4()
            cell.confirmBtn.isHidden = false
            cell.pointView.isHidden = true
        case 1:
            cell.imgView.image = R.image.img_transaction_demo_5()
            cell.confirmBtn.isHidden = true
            cell.pointView.isHidden = false
        case 2:
            cell.imgView.image = R.image.img_transaction_demo_3()
            cell.confirmBtn.isHidden = false
            cell.pointView.isHidden = true
        case 3:
            cell.imgView.image = R.image.img_transaction_demo_1()
            cell.confirmBtn.isHidden = false
            cell.pointView.isHidden = true
        default:
            cell.imgView.image = R.image.img_transaction_demo_2()
            cell.confirmBtn.isHidden = false
            cell.pointView.isHidden = true
        }
        
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
    }
    
    @IBAction func shoppingAction(_ sender: Any) {
        topUpView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        shoppingView.backgroundColor = .white
    }
    
    @IBAction func topUpAction(_ sender: Any) {
        topUpView.backgroundColor = .white
        shoppingView.backgroundColor = UIColor.init(hexString: "EFF3F6")
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.transactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
