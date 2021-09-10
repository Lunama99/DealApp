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
    
    var collectionDisplay: CollectionDisplay = .HotDeal {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        
        collectionView.register(R.nib.vendorCollectionViewCell)
        collectionView.register(R.nib.hotDealCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.setNavigationBarHidden(false, animated: false)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupHotDealCell(_ cell: HotDealCollectionViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_demo1()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: 0))
        case 1:
            cell.imgView.image = R.image.img_demo2()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: 0))
        case 2:
            cell.imgView.image = R.image.img_demo3()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: 0))
        case 3:
            cell.imgView.image = R.image.img_demo4()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: 0))
        default:
            cell.imgView.image = R.image.img_demo5()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: 0))
        }
        
        cell.imgView.contentMode = .scaleToFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
        
        cell.titleLbl.text = "3 Days Tour Packages To France With Airfare"
        cell.pointLbl.text = "100 points"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "120 points")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.discountLbl.attributedText = attributeString
        cell.setShadow()
    }
    
    func setupVendorCell(_ cell: VendorCollectionViewCell, indexPath: IndexPath) {
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
        vendorView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        hotDealView.backgroundColor = .white
        collectionDisplay = .HotDeal
    }
    
    @IBAction func vendorAction(_ sender: Any) {
        vendorView.backgroundColor = .white
        hotDealView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        collectionDisplay = .Vendor
    }
}

extension VendorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionDisplay == .HotDeal {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.hotDealCollectionViewCell.identifier, for: indexPath) as? HotDealCollectionViewCell else { return UICollectionViewCell() }
            setupHotDealCell(cell, indexPath: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.vendorCollectionViewCell.identifier, for: indexPath) as? VendorCollectionViewCell else { return UICollectionViewCell() }
            setupVendorCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.vendorViewController.showVendorDetail, sender: self)
    }
}

extension VendorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionDisplay == .HotDeal {
            let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn - 1
            return CGSize(width: width, height: width/2*2.7)
        } else {
            let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn - 1
            return CGSize(width: width, height: width/2*2.7)
        }
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

extension VendorViewController {
    enum CollectionDisplay {
        case HotDeal
        case Vendor
    }
}
