//
//  VoucherManagerViewController.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import UIKit

class VoucherManagerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var viewModel = VoucherManagerViewModel()
    var displayStyle: DisplayStyle = .Vendor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }
    
    func setupView() {
        // Setup icon
        showBackButton()
        tableView.register(R.nib.voucherManagerTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        if displayStyle == .Vendor {
            addBtn.isHidden = false
        } else {
            addBtn.isHidden = true
        }
    }
    
    func setupObservable() {
        viewModel.listVoucher.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
    }
    
    func fetchData() {
        viewModel.getListVoucherByIDVendor { [weak self] in
            self?.stateView = .ready
        }
    }
    
    func setupCell(_ cell: VoucherManagerTableViewCell, indexPath: IndexPath) {
        let item = viewModel.listVoucher.value?[indexPath.row]
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: R.image.img_placeholder())
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item?.oldPrice?.toDollar() ?? "0")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.titleLbl.text = item?.name
        cell.oldPriceLbl.attributedText = attributeString
        cell.newPriceLbl.text = item?.newPrice?.toDollar() ?? "0"
        cell.dateLbl.text = item?.dateEnd?.toDate(format: .format5)?.toString(format: .format4)
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.voucherManagerViewController.showEditVoucher.identifier,
           let addNewVoucherViewController = segue.destination as? AddNewVoucherViewController {
            addNewVoucherViewController.displayStyle = .Edit
            
            if let indexPath = tableView.indexPathForSelectedRow, let voucher = viewModel.listVoucher.value?[indexPath.row] {
                addNewVoucherViewController.viewModel.voucher.value = voucher
            }
            
            addNewVoucherViewController.callBack = { [weak self] in
                self?.fetchData()
            }
        }
        
        if segue.identifier == R.segue.voucherManagerViewController.showAddNewVoucher.identifier,
           let addNewVoucherViewController = segue.destination as? AddNewVoucherViewController {
            addNewVoucherViewController.displayStyle = .AddNew
            let newVoucher = GetVoucher()
            newVoucher.idVendor = viewModel.idVendor
            addNewVoucherViewController.viewModel.voucher.value = newVoucher
            addNewVoucherViewController.callBack = { [weak self] in
                self?.fetchData()
            }
        }
        
        if segue.identifier == R.segue.voucherManagerViewController.showViewVoucher.identifier,
           let voucherDetailViewController = segue.destination as? VoucherDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow, let voucher = viewModel.listVoucher.value?[indexPath.row] {
                voucherDetailViewController.viewModel.voucher = voucher
                voucherDetailViewController.viewModel.vendor = viewModel.vendor
            }
        }
    }
}

extension VoucherManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listVoucher.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.voucherManagerTableViewCell.identifier, for: indexPath) as? VoucherManagerTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if displayStyle == .Vendor {
            performSegue(withIdentifier: R.segue.voucherManagerViewController.showEditVoucher, sender: self)
        } else {
            performSegue(withIdentifier: R.segue.voucherManagerViewController.showViewVoucher, sender: self)
        }
    }
}

extension VoucherManagerViewController {
    enum DisplayStyle {
        case Vendor
        case User
    }
}
