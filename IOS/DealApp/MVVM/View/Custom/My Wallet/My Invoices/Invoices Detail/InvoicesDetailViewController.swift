//
//  InvoicesDetailViewController.swift
//  DealApp
//
//  Created by Macbook on 26/10/2021.
//

import UIKit

class InvoicesDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customeSearchBar: CustomSearchBar!
    
    var invoice: GetInvoices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        title = "#\(invoice?.code ?? "")"
        
        tableView.register(R.nib.invoicesDetailTableViewCell)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(R.nib.myInvoicesTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        customeSearchBar.searchTfx.didChangeValue = { [weak self] string in
            self?.tableView.reloadData()
        }
    }
    
    func invoicesFilter() -> [VoucherInvoices] {
        if let string = customeSearchBar.searchTfx.text, string != "" {
            return invoice?.voucherInvoices?.filter({ item in
                if (item.name?.lowercased() ?? "").contains(string.lowercased()) {
                    return true
                } else if (item.nameVendor?.lowercased() ?? "").contains(string.lowercased()) {
                    return true
                } else if (item.code?.lowercased() ?? "").contains(string.lowercased()) {
                    return true
                }
                
                return false
            }) ?? []
        } else {
            return invoice?.voucherInvoices ?? []
        }
    }
    
    func setupCell(_ cell: InvoicesDetailTableViewCell, indexPath: IndexPath) {
        let item = invoicesFilter()[indexPath.row]
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: R.image.img_placeholder())
        cell.nameLbl.text = item.name
        cell.vendorLbl.text = item.nameVendor
        cell.codeVoucherLbl.text = item.code
        cell.startDateLbl.text = item.dateStart?.toDate(format: .format5)?.toString(format: .format4)
        cell.endDateLbl.text = item.dateEnd?.toDate(format: .format5)?.toString(format: .format4)
        cell.statusLbl.text = item.status == true ? "Avalable" : "Unavalable"
        cell.statusLbl.textColor = item.status == true ? .systemGreen : .systemRed
        cell.dimBackgroundView.backgroundColor = item.status == true ? UIColor.clear : UIColor.lightGray.withAlphaComponent(0.4)
    }
}
extension InvoicesDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoicesFilter().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.invoicesDetailTableViewCell.identifier, for: indexPath) as? InvoicesDetailTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = invoice?.voucherInvoices?[indexPath.row]
        Helper.shared.showQRCode(displayStyle: .normal(string: item?.code ?? ""), parent: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
