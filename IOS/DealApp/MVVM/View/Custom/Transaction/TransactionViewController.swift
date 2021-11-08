//
//  TransactionViewController.swift
//  DealApp
//
//  Created by Macbook on 04/09/2021.
//

import UIKit

class TransactionViewController: BaseViewController {

    @IBOutlet weak var allView: BaseView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var depositView: BaseView!
    @IBOutlet weak var voucherView: BaseView!
    @IBOutlet weak var withDrawView: BaseView!
    
    private let viewModel = TransactionHistoryViewModel()
    
    var tableDisplay: TransactionType = .All {
        didSet {
            viewModel.currentPage = 1
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }
    
    func setupView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
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
        viewModel.getTransaction(tyle: tableDisplay)
    }
    
    func setupCell(_ cell: HistoryTableViewCell, indexPath: IndexPath) {
        let item = viewModel.listTransaction.value?[indexPath.row]
        if TransactionType.init(rawValue: item?.type ?? "") == TransactionType.Deposit {
            cell.addressLbl.text = item?.userAddress
        } else {
            cell.addressLbl.text = "My Wallet"
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("loading more \(Date())")
            fetchData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.transactionViewController.showInvoiceDetail.identifier,
           let invoicesDetailViewController = segue.destination as? InvoicesDetailViewController {
            invoicesDetailViewController.invoice = viewModel.invoice
        }
    }
    
    @IBAction func allAction(_ sender: Any) {
        allView.backgroundColor = .white
        voucherView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        depositView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        withDrawView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        tableDisplay = .All
    }
    
    @IBAction func voucherAction(_ sender: Any) {
        allView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        voucherView.backgroundColor = .white
        depositView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        withDrawView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        tableDisplay = .BuyVoucher
    }
    
    @IBAction func depositAction(_ sender: Any) {
        allView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        voucherView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        depositView.backgroundColor = .white
        withDrawView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        tableDisplay = .Deposit
    }
    
    @IBAction func withDrawAction(_ sender: Any) {
        allView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        voucherView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        depositView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        withDrawView.backgroundColor = .white
        tableDisplay = .WithDraw
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
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
        if TransactionType.init(rawValue: item?.type ?? "") != TransactionType.BuyVoucher {
            Helper.shared.showWebView(title: "Transaction Detail", url: item?.txid ?? "", parent: self)
        } else {
            stateView = .loading
            viewModel.getInvoiceByTxTransaction(tx: item?.txid ?? "") { [weak self] in
                self?.stateView = .ready
                self?.performSegue(withIdentifier: R.segue.transactionViewController.showInvoiceDetail, sender: self)
            }
        }
    }
}
