//
//  CartViewController.swift
//  DealApp
//
//  Created by Macbook on 22/10/2021.
//

import UIKit

class CartViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLbl: BaseLabel!
    @IBOutlet weak var allCheckBoxBtn: BaseButton!
    @IBOutlet weak var buyBtn: BaseButton!
    
    private let viewModel = CartViewModel()
    private var isSelectedAll: Bool = false {
        didSet {
            if isSelectedAll {
                allCheckBoxBtn.setImage(R.image.ic_checkbox_red(), for: .normal)
                allCheckBoxBtn.layer.borderWidth = 0
            } else {
                allCheckBoxBtn.setImage(nil, for: .normal)
                allCheckBoxBtn.layer.borderWidth = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(R.nib.cartTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        updateCart()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart), name: NotificationName.updateCart, object: nil)
    }
    
    override func updateCart() {
        totalLbl.text = Helper.shared.cart?.result?.total?.toPercent()
        isSelectedAll = (Helper.shared.cart?.result?.listCartItem?.count ?? 0) == 0 ? false : !((Helper.shared.cart?.result?.listCartItem?.filter({$0.status == false}).count) ?? 0 > 0)
        buyBtn.isEnabled = (Helper.shared.cart?.result?.listCartItem?.count ?? 0) > 0
        tableView.reloadData()
    }
    
    func setupCell(_ cell: CartTableViewCell, indexPath: IndexPath) {
        let item = Helper.shared.cart?.result?.listCartItem?[indexPath.row]
        
        cell.titleLbl.text = item?.name
        cell.pointLbl.text = "\(item?.subTotal?.toPercent() ?? "0")"
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: R.image.img_placeholder())
        cell.quantityLbl.text = "x\(item?.quantity ?? 0)"
        
        if item?.status == true {
            cell.checkBoxBtn.setImage(R.image.ic_checkbox_red(), for: .normal)
            cell.checkBoxBtn.layer.borderWidth = 0
        } else {
            cell.checkBoxBtn.setImage(nil, for: .normal)
            cell.checkBoxBtn.layer.borderWidth = 1
        }
        
        cell.callBack = { [weak self] in
            self?.stateView = .loading
            self?.viewModel.updateStatusItemCart(Id: [item?.id ?? ""], Status: !(item?.status ?? false)) {
                self?.stateView = .ready
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.cartViewController.showUpdateItemCart.identifier,
           let updateItemCartViewController = segue.destination as? UpdateItemCartViewController {
            if let indexPath = tableView.indexPathForSelectedRow, let item = Helper.shared.cart?.result?.listCartItem?[indexPath.row] {
                updateItemCartViewController.viewModel.item = item
            }
        }
    }
    
    @IBAction func allAction(_ sender: Any) {
        guard (Helper.shared.cart?.result?.listCartItem?.count ?? 0) > 0 else { return }
        
        let ids: [String] = Helper.shared.cart?.result?.listCartItem?.map({ item -> String in
            return item.id ?? ""
        }) ?? []
        
        stateView = .loading
        viewModel.updateStatusItemCart(Id: ids, Status: !isSelectedAll) { [weak self] in
            self?.stateView = .ready
        }
    }
    
    @IBAction func buyAction(_ sender: Any) {
        stateView = .loading
        viewModel.addInvoiceVoucher { [weak self] result, message in
            self?.stateView = .ready
            self?.viewModel.getCart { [weak self] in
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                    if result {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Helper.shared.cart?.result?.listCartItem?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.cartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.cartViewController.showUpdateItemCart, sender: self)
    }
}
