//
//  VendorViewController.swift
//  DealApp
//
//  Created by Macbook on 03/09/2021.
//

import UIKit

class VendorViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var voucherView: BaseView!
    @IBOutlet weak var vendorView: BaseView!
    @IBOutlet weak var customeSearchBar: CustomSearchBar!
    
    private let contentInsetCV = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    private let numberOfColumn: CGFloat = 2
    private let spacing: CGFloat = 16
    private var timer: Timer = Timer()
    var focusTextField: Bool = false
    let viewModel = VendorViewModel()
    
    var collectionDisplay: CollectionDisplay = .Voucher {
        didSet {
            guard let collectionView = collectionView else { return }
            guard let customeSearchBar = customeSearchBar else { return }
            customeSearchBar.searchTfx.text = collectionDisplay == .Vendor ? viewModel.vendorSearchText.value : viewModel.voucherSearchText.value
            viewModel.vendorPage = 1
            viewModel.voucherPage = 1
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
        
        if collectionDisplay == .Voucher {
            vendorView.backgroundColor = UIColor.init(hexString: "EFF3F6")
            voucherView.backgroundColor = .white
            collectionDisplay = .Voucher
        } else {
            vendorView.backgroundColor = .white
            voucherView.backgroundColor = UIColor.init(hexString: "EFF3F6")
            collectionDisplay = .Vendor
        }
        
        if focusTextField {
            focusTextField = false
            customeSearchBar.searchTfx.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupView() {
        // Setup icon
        showRightButtons()
        
        collectionView.register(R.nib.vendorCollectionViewCell)
        collectionView.register(R.nib.hotDealCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.delegate = self
        collectionView.dataSource = self
        
        customeSearchBar.searchTfx.didChangeValue = { [weak self] string in
            self?.timer.invalidate()
            if self?.collectionDisplay == .Vendor {
                self?.viewModel.vendorPage = 1
                self?.viewModel.vendorSearchText.value = string
            } else {
                self?.viewModel.voucherPage = 1
                self?.viewModel.voucherSearchText.value = string
            }
        }
    }
    
    func setupObservable() {
        viewModel.listVendor.bind { [weak self] string in
            self?.collectionView.reloadData()
        }
        
        viewModel.listVoucher.bind { [weak self] string in
            self?.collectionView.reloadData()
        }
        
        viewModel.vendorSearchText.bind { [weak self] string in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                if string?.trimmingCharacters(in: .whitespaces) != "" {
                    self?.viewModel.searchVendor(key: string ?? "") { }
                } else {
                    self?.viewModel.getListVendor { }
                }
            }
        }
        
        viewModel.voucherSearchText.bind { [weak self] string in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                if string?.trimmingCharacters(in: .whitespaces) != "" {
                    self?.viewModel.searchVoucher(key: string ?? "") { }
                } else {
                    self?.viewModel.getListVoucher { }
                }
            }
        }
    }
    
    func fetchData() {
        viewModel.vendorPage = 1
        viewModel.voucherPage = 1
        if collectionDisplay == .Vendor {
            if viewModel.vendorSearchText.value?.trimmingCharacters(in: .whitespaces) != "" {
                viewModel.searchVendor(key: viewModel.vendorSearchText.value ?? "") { }
            } else {
                viewModel.getListVendor { }
            }
        } else {
            if viewModel.voucherSearchText.value?.trimmingCharacters(in: .whitespaces) != "" {
                viewModel.searchVoucher(key: viewModel.voucherSearchText.value ?? "") { }
            } else {
                viewModel.getListVoucher { }
            }
        }
    }
    
    func setupVoucherCell(_ cell: HotDealCollectionViewCell, indexPath: IndexPath) {
        let item = viewModel.listVoucher.value?[indexPath.row]
        
        let currWidth = cell.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        currWidth.isActive = true
        let currHeight = cell.heightAnchor.constraint(equalToConstant: cell.bounds.height)
        currHeight.isActive = true
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: R.image.img_placeholder()?.resizeImageWith(newSize: CGSize(width: cell.bounds.width, height: cell.bounds.width)))
        
        cell.titleLbl.text = item?.name
        cell.pointLbl.text = "\(item?.newPrice?.toPercent() ?? "0")"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(item?.oldPrice?.toPercent() ?? "0")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.discountLbl.attributedText = attributeString
        cell.setShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.vendorViewController.showVendorDetail.identifier,
           let vendorDetailViewController = segue.destination as? VendorDetailViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first, let vendorId = viewModel.listVendor.value?[indexPath.row].id {
                vendorDetailViewController.viewModel.vendorId = vendorId
            }
            
        }
        
        if segue.identifier == R.segue.vendorViewController.showVoucherDetail.identifier,
           let voucherDetailViewController = segue.destination as? VoucherDetailViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first, let voucher = viewModel.listVoucher.value?[indexPath.row] {
                voucherDetailViewController.viewModel.voucher = voucher
                if let vendor = viewModel.listVendor.value?.filter({$0.id == voucher.idVendor}).first {
                    voucherDetailViewController.viewModel.vendor = vendor
                }
            }
        }
    }
    
    func setupVendorCell(_ cell: VendorCollectionViewCell, indexPath: IndexPath) {
        let item = viewModel.listVendor.value?[indexPath.row]
        
        let currWidth = cell.widthAnchor.constraint(equalToConstant: cell.bounds.width)
        currWidth.isActive = true
        let currHeight = cell.heightAnchor.constraint(equalToConstant: cell.bounds.height)
        currHeight.isActive = true
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        
        cell.imgView.sd_setImage(with: URL(string: item?.avatar ?? ""), placeholderImage: R.image.img_placeholder()?.resizeImageWith(newSize: CGSize(width: cell.bounds.width, height: cell.bounds.width)))
        cell.titleLbl.text = item?.name
    }
    
    @IBAction func voucherAction(_ sender: Any) {
        vendorView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        voucherView.backgroundColor = .white
        collectionDisplay = .Voucher
    }
    
    @IBAction func vendorAction(_ sender: Any) {
        vendorView.backgroundColor = .white
        voucherView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        collectionDisplay = .Vendor
    }
}

extension VendorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDisplay == .Voucher ? (viewModel.listVoucher.value?.count ?? 0) : (viewModel.listVendor.value?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionDisplay == .Voucher {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.hotDealCollectionViewCell.identifier, for: indexPath) as? HotDealCollectionViewCell else { return UICollectionViewCell() }
            setupVoucherCell(cell, indexPath: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.vendorCollectionViewCell.identifier, for: indexPath) as? VendorCollectionViewCell else { return UICollectionViewCell() }
            setupVendorCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionDisplay == .Voucher {
            performSegue(withIdentifier: R.segue.vendorViewController.showVoucherDetail, sender: self)
        } else {
            performSegue(withIdentifier: R.segue.vendorViewController.showVendorDetail, sender: self)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            if collectionDisplay == .Vendor {
                viewModel.getListVendor { }
            } else {
                viewModel.getListVoucher { }
            }
        }
    }
}

extension VendorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionDisplay == .Voucher {
            let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn - 1
            return CGSize(width: width, height: width/2*2.6)
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
        case Voucher
        case Vendor
    }
}
