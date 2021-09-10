//
//  TopUpViewController.swift
//  DealApp
//
//  Created by Macbook on 07/09/2021.
//

import UIKit

class TopUpViewController: BaseViewController {

    @IBOutlet weak var cryptoCollectionView: UICollectionView!
    @IBOutlet weak var bankCollectionView: UICollectionView!
    
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let numberOfColumn: CGFloat = 3
    private let spacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        showNoticeButton()
        
        cryptoCollectionView.register(R.nib.topUpCollectionViewCell)
        cryptoCollectionView.contentInset = contentInsetCV
        cryptoCollectionView.delegate = self
        cryptoCollectionView.dataSource = self
        
        bankCollectionView.register(R.nib.topUpCollectionViewCell)
        bankCollectionView.contentInset = contentInsetCV
        bankCollectionView.delegate = self
        bankCollectionView.dataSource = self
    }
    
    func setupCryptoCell(_ cell: TopUpCollectionViewCell, indexPath: IndexPath) {
        cell.imgLeadingConstraint.constant = 10
        cell.imgTrailingConstraint.constant = 10
        cell.imgTopConstraint.constant = 10
        cell.imgBotConstraint.constant = 10
        
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_vdt()?.resizeImageWith(newSize: CGSize(width: cell.frame.width - 20, height: cell.frame.width - 20))
            cell.titleLbl.text = "VDT"
        case 1:
            cell.imgView.image = R.image.img_tron()?.resizeImageWith(newSize: CGSize(width: cell.frame.width - 20, height: cell.frame.width - 20))
            cell.titleLbl.text = "TRON"
        default:
            cell.imgView.image = R.image.img_bitcoin()?.resizeImageWith(newSize: CGSize(width: cell.frame.width - 20, height: cell.frame.width - 20))
            cell.titleLbl.text = "BITCOIN"
        }
        
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    func setupBankCell(_ cell: TopUpCollectionViewCell, indexPath: IndexPath) {
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
}

extension TopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
//        performSegue(withIdentifier: R.segue.vendorViewController.showVendorDetail, sender: self)
    }
}

extension TopUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing*(numberOfColumn-1)))/numberOfColumn - 1
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

