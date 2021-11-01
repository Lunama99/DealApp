//
//  MyInvoicesViewController.swift
//  DealApp
//
//  Created by Macbook on 25/10/2021.
//

import UIKit

class MyInvoicesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customeSearchBar: CustomSearchBar!
    
    private let viewModel = MyInvoicesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func setupView() {
        showBackButton()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(R.nib.myInvoicesTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        customeSearchBar.searchTfx.didChangeValue = { [weak self] string in
            self?.viewModel.searchBarTex.value = string
        }
    }
    
    func fetchData() {
        viewModel.getListInvoice { [weak self] in
            self?.stateView = .ready
        }
    }
    
    func setupObservable() {
        viewModel.listInvoices.bind { [weak self] string in
            self?.tableView.reloadData()
        }
        
        viewModel.searchBarTex.bind { [weak self] string in
            self?.tableView.reloadData()
        }
    }
    
    func setupCell(_ cell: MyInvoicesTableViewCell, indexPath: IndexPath) {
        let item = viewModel.listInvoicesFilter()[indexPath.row]
        
        cell.codeLbl.text = "#\(item.code ?? "")"
        cell.statusLbl.text = item.status == 1 ? "Successful" : "Failed"
        cell.priceLbl.text = item.totalPrice?.toPercent()
        cell.nameLbl.text = item.listProduct
        cell.creaetDateLbl.text = item.dateCreate?.toDate(format: .format3)?.toString(format: .format4)
        cell.paymentMethodLbl.text = "Wallet"
        cell.quantityValueLbl.text = "\(item.voucherInvoices?.count ?? 0)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.myInvoicesViewController.showInvoiceDetail.identifier,
           let invoicesDetailViewController = segue.destination as? InvoicesDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                invoicesDetailViewController.invoice = viewModel.listInvoicesFilter()[indexPath.row]
            }
        }
    }
}

extension MyInvoicesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listInvoicesFilter().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.myInvoicesTableViewCell.identifier, for: indexPath) as? MyInvoicesTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.myInvoicesViewController.showInvoiceDetail, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
