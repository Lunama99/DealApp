//
//  MyVendorViewController.swift
//  DealApp
//
//  Created by Macbook on 12/10/2021.
//

import UIKit

class MyVendorViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hotDealView: BaseView!
    @IBOutlet weak var vendorView: BaseView!
    @IBOutlet weak var customeSearchBar: CustomSearchBar!
    
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let numberOfColumn: CGFloat = 2
    private var timer: Timer = Timer()
    private let spacing: CGFloat = 16
    private let viewModel = MyVendorViewModel()
    
    var collectionDisplay: CollectionDisplay = .Verified {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupView() {
        // Setup icon
        
        showBackButton()
        collectionView.register(R.nib.vendorCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.delegate = self
        collectionView.dataSource = self
        
        customeSearchBar.searchTfx.didChangeValue = { [weak self] string in
            self?.viewModel.searchText.value = string
        }
    }
 
    func fetchData() {
        viewModel.getListVendor { }
    }
    
    func setupObservable() {
        viewModel.listVendorOrigin.bind { [weak self] string in
            self?.collectionView.reloadData()
        }
        
        viewModel.searchText.bind { [weak self] string in
            self?.collectionView.reloadData()
        }
    }
    
    func setupVendorCell(_ cell: VendorCollectionViewCell, indexPath: IndexPath) {
        
        let currWidth = cell.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        currWidth.isActive = true
        let currHeight = cell.heightAnchor.constraint(equalToConstant: cell.bounds.height)
        currHeight.isActive = true
        
        let item = collectionDisplay == .Verified ? viewModel.filterVendorVerified()[indexPath.row] : viewModel.filterVendorPending()[indexPath.row]
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.sd_setImage(with: URL(string: item.avatar ?? ""), placeholderImage: R.image.img_placeholder()?.resizeImageWith(newSize: CGSize(width: cell.bounds.width, height: cell.bounds.width)))
        cell.titleLbl.text = item.name
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.myVendorViewController.showRegisterVendor.identifier,
           let registerVendorViewController = segue.destination as? RegisterVendorViewController {
            registerVendorViewController.displayTyle = .AddNewVendor
        }
        
        if segue.identifier == R.segue.myVendorViewController.showMyVendorDetail.identifier,
           let myVendorDetailViewController = segue.destination as? MyVendorDetailViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                myVendorDetailViewController.viewModel.vendorId = collectionDisplay == .Verified ? (viewModel.filterVendorVerified()[indexPath.row].id ?? "") : (viewModel.filterVendorPending()[indexPath.row].id ?? "")
            }
        }
        
        if segue.identifier == R.segue.myVendorViewController.showVendorInformation.identifier,
           let vendorInformationViewController = segue.destination as? VendorInformationViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let vendor = collectionDisplay == .Verified ? viewModel.filterVendorVerified()[indexPath.row] : viewModel.filterVendorPending()[indexPath.row]
                vendorInformationViewController.viewModel.vendor = vendor
                
            }
        }
    }
    
    @IBAction func verifiedAction(_ sender: Any) {
        vendorView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        hotDealView.backgroundColor = .white
        collectionDisplay = .Verified
    }
    
    @IBAction func pendingAction(_ sender: Any) {
        vendorView.backgroundColor = .white
        hotDealView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        collectionDisplay = .Pending
    }
    
    @IBAction func scanVoucherAction(_ sender: Any) {
        Helper.shared.showScan(parent: self) { _ in }
    }
}

extension MyVendorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDisplay == .Verified ? viewModel.filterVendorVerified().count : viewModel.filterVendorPending().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.vendorCollectionViewCell.identifier, for: indexPath) as? VendorCollectionViewCell else { return UICollectionViewCell() }
        setupVendorCell(cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionDisplay == .Verified ? viewModel.filterVendorVerified()[indexPath.row] : viewModel.filterVendorPending()[indexPath.row]
        if item.avatar == nil {
            performSegue(withIdentifier: R.segue.myVendorViewController.showVendorInformation, sender: self)
        } else {
            performSegue(withIdentifier: R.segue.myVendorViewController.showMyVendorDetail, sender: self)
        }
    }
}

extension MyVendorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn - 1
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

extension MyVendorViewController {
    enum CollectionDisplay {
        case Verified
        case Pending
    }
}
