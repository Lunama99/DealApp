//
//  VendorDetailViewController.swift
//  DealApp
//
//  Created by Macbook on 06/09/2021.
//

import UIKit

class VendorDetailViewController: BaseViewController {

    @IBOutlet weak var indicatorBtn: BaseLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgScrollView: UIScrollView!
    @IBOutlet weak var shareBtn: BaseButton!
    @IBOutlet weak var likeBtn: BaseButton!
    @IBOutlet weak var descriptionTextView: BaseTextView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var moreAddressBtn: UIButton!
    
    var viewModel = MyVendorDetailViewModel()
    private var imgFrame = CGRect.zero
    private var currentIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }

    func setupView() {
        
        showBackButton(mode: .Light)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        imgScrollView.isPagingEnabled = true
        imgScrollView.delegate = self
        imgScrollView.bounces = false
    
        indicatorBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        indicatorBtn.bringSubviewToFront(imgScrollView)
        
        avatarImg.layer.cornerRadius = avatarImg.bounds.size.height/2
        avatarImg.contentMode = .scaleAspectFill
        avatarImg.layer.masksToBounds = true
    }
    
    func setupObservable() {
        viewModel.vendor.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.currentIndex = 1
            strongSelf.titleLbl.text = strongSelf.viewModel.vendor.value?.name
            strongSelf.avatarImg.sd_setImage(with: URL(string: strongSelf.viewModel.vendor.value?.avatar ?? ""), placeholderImage: R.image.img_store_placeholder())
            
            strongSelf.imgScrollView.subviews.forEach { image in
                if image.isKind(of: VendorDetailImageView.self) {
                    image.removeFromSuperview()
                }
            }
            
            if (strongSelf.viewModel.vendor.value?.imageList?.count ?? 0) > 0 {
                strongSelf.indicatorBtn.text = "\(strongSelf.currentIndex)/\(strongSelf.viewModel.vendor.value?.imageList?.count ?? 0)"
            } else {
                strongSelf.indicatorBtn.text = "0/\(strongSelf.viewModel.vendor.value?.imageList?.count ?? 0)"
            }
            
            if (strongSelf.viewModel.vendor.value?.address?.count ?? 0) > 0 {
                if let address = strongSelf.viewModel.vendor.value?.address?.first {
                    strongSelf.addressLbl.text = "\(address.street ?? "N/A"), Ward \(address.ward ?? "N/A"), District \(address.district ?? "N/A"), \(address.city ?? "N/A"), State \(address.state ?? "N/A"), \(address.country ?? "N/A")"
                }
                strongSelf.moreAddressBtn.isHidden = false
            } else {
                strongSelf.moreAddressBtn.isHidden = true
            }
            
            strongSelf.imgFrame = CGRect.zero
            
            for index in 0..<(strongSelf.viewModel.vendor.value?.imageList?.count ?? 0) {
                strongSelf.imgFrame.origin.x = strongSelf.imgScrollView.frame.size.width * CGFloat(index)
                strongSelf.imgFrame.size = strongSelf.imgScrollView.frame.size
                
                let imgView = VendorDetailImageView(frame: strongSelf.imgFrame)
                imgView.layer.masksToBounds = true
                
                if let url = strongSelf.viewModel.vendor.value?.imageList?[index].path {
                    imgView.imgView.sd_setImage(with: URL(string: url), placeholderImage: R.image.img_placeholder())
                }
                
                strongSelf.imgScrollView.addSubview(imgView)
            }
            
            strongSelf.imgScrollView.contentSize = CGSize(width: (strongSelf.imgScrollView.frame.size.width * CGFloat(strongSelf.viewModel.vendor.value?.imageList?.count ?? 0)), height: strongSelf.imgScrollView.frame.size.height)
        }
    }
    
    func fetchData() {
        viewModel.getVendorById { [weak self] in
            self?.stateView = .ready
            self?.descriptionTextView.text = self?.viewModel.vendor.value?.description
            self?.descriptionTextView.translatesAutoresizingMaskIntoConstraints = true
            self?.descriptionTextView.sizeToFit()
            self?.descriptionTextView.isScrollEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.vendorDetailViewController.showVendorAddress.identifier,
           let vendorAddressViewController = segue.destination as? VendorAddressViewController {
            vendorAddressViewController.displayStyle = .User
            if let vendor = viewModel.vendor.value {
                vendorAddressViewController.vendor = vendor
            }
        }
        
        if segue.identifier == R.segue.vendorDetailViewController.showVoucherManager.identifier,
           let voucherManagerViewController = segue.destination as? VoucherManagerViewController {
            voucherManagerViewController.viewModel.idVendor = viewModel.vendorId
            voucherManagerViewController.displayStyle = .User
            if let vendor = viewModel.vendor.value {
                voucherManagerViewController.viewModel.vendor = vendor
            }
        }
    }
    
    @IBAction func voucherAction(_ sender: Any) {
    }
}

extension VendorDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        indicatorBtn.text = "\(Int(pageNumber + 1))/\(viewModel.vendor.value?.imageList?.count ?? 0)"
        currentIndex = Int(pageNumber + 1)
    }
}
