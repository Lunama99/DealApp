//
//  VendorAddressViewController.swift
//  DealApp
//
//  Created by Macbook on 15/10/2021.
//

import UIKit

class VendorAddressViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: BaseButton!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    
    private let vendorRepo = VendorRepository()
    var vendor = GetListVendorRegister()
    var callBack: (()->Void)?
    var isChangeAddress: Bool = false
    var displayStyle: DisplayStyle = .Vendor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showBackButton()
        saveBtn.isEnabled = false
        tableView.register(R.nib.vendorAddressTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        if displayStyle == .Vendor {
            saveView.isHidden = false
            addBtn.isHidden = false
        } else {
            saveView.isHidden = true
            addBtn.isHidden = true

        }
    }
    
    func setupCell(_ cell: VendorAddressTableViewCell, indexPath: IndexPath) {
        let item = vendor.address?[indexPath.row]
        cell.streetLbl.text = item?.street
        cell.otherLbl.text = "Ward \(item?.ward ?? "N/A"), District \(item?.district ?? "N/A"), \(item?.city ?? "N/A") City"
        cell.stateCountryLbl.text = "State \(item?.state ?? "N/A"), \(item?.country ?? "N/A")"
        cell.phoneNumberLbl.text = "Phone number: \(item?.phoneNumber ?? "N/A")"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.vendorAddressViewController.showEditAddress.identifier,
           let addNewAddressViewController = segue.destination as? AddNewAddressViewController {
            addNewAddressViewController.displayStyle = .Update
            if let indexPath = tableView.indexPathForSelectedRow, let address = vendor.address?[indexPath.row] {
                addNewAddressViewController.address = address
            }
            
            addNewAddressViewController.callBack = { [weak self] address in
                self?.saveBtn.isEnabled = true
                if let indexPath = self?.tableView.indexPathForSelectedRow {
                    self?.vendor.address?[indexPath.row] = address
                    self?.tableView.reloadData()
                }
            }
        }
        
        if segue.identifier == R.segue.vendorAddressViewController.showAddNewAddress.identifier,
           let addNewAddressViewController = segue.destination as? AddNewAddressViewController {
            addNewAddressViewController.displayStyle = .AddNew
            addNewAddressViewController.callBack = { [weak self] address in
                self?.saveBtn.isEnabled = true
                
                if self?.vendor.address == nil {
                    self?.vendor.address = []
                }
                
                self?.vendor.address?.append(address)
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        stateView = .loading
        vendorRepo.updateVendorInformation(ID: vendor.id ?? "", Name: vendor.name ?? "", Description: vendor.description ?? "", AvatarBase64: nil, ImageListBase64: nil, address: vendor.address) { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        self?.callBack?()
                        self?.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print("create address failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension VendorAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendor.address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.vendorAddressTableViewCell.identifier, for: indexPath) as? VendorAddressTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if displayStyle == .Vendor {
            performSegue(withIdentifier: R.segue.vendorAddressViewController.showEditAddress, sender: self)
        }
    }
}

extension VendorAddressViewController {
    enum DisplayStyle {
        case Vendor
        case User
    }
}
