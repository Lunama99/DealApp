//
//  VendorViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class VendorViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hotDealView: BaseView!
    @IBOutlet weak var vendorView: BaseView!
    
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let numberOfColumn: CGFloat = 2
    private let spacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        collectionView.register(R.nib.vendorCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCell(_ cell: VendorCollectionViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_the_coffee_house()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "The Coffee House"
        case 1:
            cell.imgView.image = R.image.img_starbucks_coffee()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "StarBucks Coffee"
        case 2:
            cell.imgView.image = R.image.img_texas()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Texas Chircken"
        default:
            cell.imgView.image = R.image.img_macdonald()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "MacDonald"
        }
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    @IBAction func hotDealAction(_ sender: Any) {
        hotDealView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        vendorView.backgroundColor = .white
    }
    
    @IBAction func vendorAction(_ sender: Any) {
        hotDealView.backgroundColor = .white
        vendorView.backgroundColor = UIColor.init(hexString: "EFF3F6")
    }
}

extension VendorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.vendorCollectionViewCell.identifier, for: indexPath) as? VendorCollectionViewCell else { return UICollectionViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    
}

extension VendorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn
        return CGSize(width: width, height: width/2*2.7)
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
