//
//  TopUpViewController.swift
//  DealApp
//
//  Created by Macbook on 07/09/2021.
//

import UIKit
import SDWebImage

class TopUpViewController: BaseViewController {

    @IBOutlet weak var cryptoCollectionView: UICollectionView!
    @IBOutlet weak var bankCollectionView: UICollectionView!
    @IBOutlet weak var cryptoSearchBar: CustomSearchBar!
    @IBOutlet weak var pointValueLbl: BaseLabel!
    @IBOutlet weak var currencyLbl: BaseLabel!
    
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let cellWidth: CGFloat = 60
    private let numberOfColumn: CGFloat = 4
    
    private let viewModel = TopUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
        setupObservable()
    }
    
    func setupView() {
        showBackButton()
        showRightButtons()
        
        cryptoCollectionView.register(R.nib.topUpCollectionViewCell)
        cryptoCollectionView.contentInset = contentInsetCV
        cryptoCollectionView.delegate = self
        cryptoCollectionView.dataSource = self
        
        bankCollectionView.register(R.nib.topUpCollectionViewCell)
        bankCollectionView.contentInset = contentInsetCV
        bankCollectionView.delegate = self
        bankCollectionView.dataSource = self
        
        cryptoSearchBar.searchTfx.didChangeValue = { [weak self] string in
            self?.viewModel.searchBarText = string
            self?.cryptoCollectionView.reloadData()
        }
    }
    
    func fetchData() {
        stateView = .loading
        viewModel.getCoinDeposit { [weak self] in
            self?.cryptoCollectionView.reloadData()
            self?.stateView = .ready
        }
        
        viewModel.getBalance { }
    }
    
    func setupObservable() {
        viewModel.coinDeposit.bind { [weak self] string in
            self?.cryptoCollectionView.reloadData()
        }
        
        viewModel.walletBalance.bind { [weak self] _ in
            self?.pointValueLbl.text = "\(self?.viewModel.walletBalance.value?.available?.toPercent() ?? "0")"
            self?.currencyLbl.text = "\(self?.viewModel.walletBalance.value?.currency ?? "N/A")"
        }
    }
    
    func setupCryptoCell(_ cell: TopUpCollectionViewCell, indexPath: IndexPath) {
        let item = viewModel.filterDepositCoin()[indexPath.row]
        cell.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        
        cell.imgView.sd_setImage(with: URL(string: item.logo ?? ""), completed: nil)
        cell.imgBackground.layer.cornerRadius = cell.imgBackground.frame.size.height/2
        cell.imgBackground.layer.masksToBounds = true
        cell.titleLbl.text = item.currency
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    func setupBankCell(_ cell: TopUpCollectionViewCell, indexPath: IndexPath) {
        cell.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_visa()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Visa"
        case 1:
            cell.imgView.image = R.image.img_masterCard()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Master"
        default:
            cell.imgView.image = R.image.img_paypal()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Paypal"
        }
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.topUpViewController.showSelectAddress.identifier,
           let selectAddressViewController = segue.destination as? SelectAddressViewController {
            selectAddressViewController.viewModel.listAdress.value = viewModel.listAdress.value
            if let selectedInndex = cryptoCollectionView.indexPathsForSelectedItems?.first, let item = cryptoCollectionView.cellForItem(at: selectedInndex) as? TopUpCollectionViewCell {
                selectAddressViewController.chainImg = item.imgView.image
            }
            selectAddressViewController.addressSelected = { [weak self] value in
                guard let strongSelf = self else { return }
                Helper.shared.showQRCode(displayStyle: .wallet(wallet: value), parent: strongSelf)
            }
        }
    }
}

extension TopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == cryptoCollectionView ? (viewModel.filterDepositCoin().count) : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cryptoCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.topUpCollectionViewCell.identifier, for: indexPath) as? TopUpCollectionViewCell else { return UICollectionViewCell() }
            setupCryptoCell(cell, indexPath: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.topUpCollectionViewCell.identifier, for: indexPath) as? TopUpCollectionViewCell else { return UICollectionViewCell() }
            setupBankCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cryptoCollectionView {
            let item = viewModel.filterDepositCoin()[indexPath.row]
            stateView = .loading
            viewModel.getAddress(symbol: item.currency ?? "") { [weak self] in
                self?.stateView = .ready
                self?.performSegue(withIdentifier: R.segue.topUpViewController.showSelectAddress, sender: self)
            }
        }
    }
}

extension TopUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding = contentInsetCV.left + contentInsetCV.right
        let totalCellWidth = cellWidth*numberOfColumn
        let avalableWidth = collectionView.bounds.width - totalCellWidth - padding
        return avalableWidth/(numberOfColumn - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding = contentInsetCV.left + contentInsetCV.right
        let totalCellWidth = cellWidth*numberOfColumn
        let avalableWidth = collectionView.bounds.width - totalCellWidth - padding
        return avalableWidth/(numberOfColumn - 1)
    }
}

