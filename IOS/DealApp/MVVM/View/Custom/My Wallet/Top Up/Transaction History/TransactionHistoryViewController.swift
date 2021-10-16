//
//  TransactionHistoryViewController.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import UIKit

class TransactionHistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = TransactionHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }
    
    func setupView() {
        showBackButton()
        
        tableView.register(R.nib.historyTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupObservable() {
        viewModel.listTransaction.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func fetchData() {
        viewModel.getTransaction(page: 1)
    }
    
    func setupCell(_ cell: HistoryTableViewCell, indexPath: IndexPath) {
        let item = viewModel.listTransaction.value?[indexPath.row]
        cell.addressLbl.text = item?.userAddress
        cell.urlLbl.text = item?.txid
        cell.tyleLbl.text = item?.type
        cell.amountLbl.text = "\(item?.amount?.toBalance() ?? "0") \(item?.currency ?? "")"
        
        if item?.status == true {
            cell.statusBtn.setTitle("Confirmed", for: .normal)
            cell.statusBtn.setTitleColor(UIColor.init(hexString: "#48A500"), for: .normal)
            cell.statusBtn.backgroundColor = UIColor.init(hexString: "#F2FFE9")
            cell.statusBtn.setBorderButton(color: UIColor.init(hexString: "#48A500"))
        } else {
            cell.statusBtn.setTitle("Pending", for: .normal)
            cell.statusBtn.setTitleColor(UIColor.init(hexString: "#D89935"), for: .normal)
            cell.statusBtn.backgroundColor = UIColor.init(hexString: "#F7CC74")
            cell.statusBtn.setBorderButton(color: UIColor.init(hexString: "#D89935"))
        }
        
        if (item?.amount ?? 0) > 0 {
            cell.amountLbl.textColor = .systemGreen
        } else {
            cell.amountLbl.textColor = .red
        }
        
        cell.dateLbl.text = item?.dateCreate?.toDate(format: .format5)?.toString(format: .format1)
    }
}

extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listTransaction.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.historyTableViewCell, for: indexPath)
        else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.listTransaction.value?[indexPath.row]
        Helper.shared.showWebView(title: "Transaction Detail", url: item?.txid ?? "", parent: self)
    }
}
