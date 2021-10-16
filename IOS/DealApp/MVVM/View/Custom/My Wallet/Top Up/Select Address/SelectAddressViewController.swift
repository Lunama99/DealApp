//
//  SelectAddressViewController.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import UIKit

class SelectAddressViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var balanceLbl: UILabel!
    
    let viewModel = SelectAddressViewModel()
    var addressSelected: ((WalletAddress?)->Void)?
    var chainImg: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }
    
    func setupView() {
        tableView.register(R.nib.selectAddressTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(_ cell: SelectAddressTableViewCell, indexPath: IndexPath) {
        let item = viewModel.listAdress.value?[indexPath.row]
        cell.imgView.image = chainImg
        cell.symbolLbl.text = item?.currency
        cell.contractLbl.text = item?.type
        cell.getAddressBtn.setBorderButton(color: UIColor.init(hexString: "#00B4D8"))
    }
    
    func setupObservable() {
        viewModel.listAdress.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
//        viewModel.balance.bind { [weak self] value in
//            self?.balanceLbl.text = "Balance: \(value?.available?.toBalance() ?? "0") \(value?.currency ?? "")"
//        }
    }
    
    func fetchData() {
//        viewModel.getBalance { }
    }
    
    @IBAction func tapOutsideAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectAddressViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listAdress.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectAddressTableViewCell.identifier, for: indexPath) as? SelectAddressTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.addressSelected?(self.viewModel.listAdress.value?[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
