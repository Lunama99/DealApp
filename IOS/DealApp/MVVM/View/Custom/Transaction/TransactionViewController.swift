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
    
    var tableDisplay: CollectionDisplay = .Shopping {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        
        tableView.register(R.nib.shoppingTableViewCell)
        tableView.register(R.nib.topUpTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupShoppingCell(_ cell: ShoppingTableViewCell, indexPath: IndexPath) {
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
    
    func setupTopUpCell(_ cell: TopUpTableViewCell, indexPath: IndexPath) {
    }
    
    @IBAction func shoppingAction(_ sender: Any) {
        topUpView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        shoppingView.backgroundColor = .white
        tableDisplay = .Shopping
    }
    
    @IBAction func topUpAction(_ sender: Any) {
        topUpView.backgroundColor = .white
        shoppingView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        tableDisplay = .TopUp
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableDisplay == .Shopping {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.shoppingTableViewCell.identifier, for: indexPath) as? ShoppingTableViewCell else { return UITableViewCell() }
            setupShoppingCell(cell, indexPath: indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.topUpTableViewCell.identifier, for: indexPath) as? TopUpTableViewCell else { return UITableViewCell() }
            setupTopUpCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension TransactionViewController {
    enum CollectionDisplay {
        case Shopping
        case TopUp
    }
}
