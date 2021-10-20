//
//  HomeViewController.swift
//  DealApp
//
//  Created by Macbook on 01/09/2021.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var pointValueLbl: BaseLabel!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    private var viewModel = HomeViewModel()
    private let titleLbl = BaseLabel()
    private let avatarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
        avatarImg.sd_setImage(with: URL(string: Helper.shared.user.avatar ?? ""))
    }
    
    func setupView() {
        // Setup tabbar
        navigationController?.tabBarController?.tabBar.tintColor = .black
        navigationController?.tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(hexString: "#374957")
        
        navigationController?.tabBarController?.tabBar.items?[0].selectedImage = R.image.ic_home_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[1].selectedImage = R.image.ic_vendor_filled()?.withRenderingMode(.alwaysOriginal)
//        navigationController?.tabBarController?.tabBar.items?[2].selectedImage = R.image.ic_point_center_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[2].selectedImage = R.image.ic_transaction_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[3].selectedImage = R.image.ic_my_wallet_filled()?.withRenderingMode(.alwaysOriginal)
        
        // Setup avatar
        avatarImg.contentMode = .scaleAspectFill
        avatarImg.layer.cornerRadius = 15
        avatarImg.layer.masksToBounds = true
        
        let avatarLeftBarButton = UIBarButtonItem(customView: avatarImg)
        
        let currWidth = avatarLeftBarButton.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = avatarLeftBarButton.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        
        // Setup title
        titleLbl.style = 3
        
        let titleLeftBarButton = UIBarButtonItem(customView: titleLbl)
        
        navigationItem.leftBarButtonItems = [avatarLeftBarButton, titleLeftBarButton]
        
        // Setup icon
        showNoticeButton()
        
        suggestionCollectionView.register(R.nib.suggestionCollectionViewCell)
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        suggestionCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        suggestionCollectionView.alwaysBounceHorizontal = true
        
        categoryCollectionView.register(R.nib.categoryCollectionViewCell)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        categoryCollectionView.alwaysBounceHorizontal = true
        
        newsCollectionView.register(R.nib.suggestionCollectionViewCell)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        suggestionCollectionView.alwaysBounceHorizontal = true
    }
    
    func setupObservable() {
        viewModel.time.bind { [weak self] string in
            guard let string = string else { return }
            if let userName = Helper.shared.user.firstName {
                self?.titleLbl.text = "\(string), \(userName)!"
                self?.titleLbl.sizeToFit()
            } else {
                self?.titleLbl.text = "\(string)"
                self?.titleLbl.sizeToFit()
            }
        }
        
        viewModel.productCategory.bind { [weak self] _ in
            self?.categoryCollectionView.reloadData()
        }
        
//        viewModel.listVendor.bind { [weak self] string in
//            self?.collectionView.reloadData()
//        }
        
        viewModel.listVoucher.bind { [weak self] string in
            self?.suggestionCollectionView.reloadData()
        }
    }
    
    func fetchData() {
        viewModel.getServerTime { }
        
        viewModel.getAllCategory { }
        
        viewModel.getListVoucher { }
        
        viewModel.getListVendor { }
    }
    
    func setupSuggestionCell(_ cell: SuggestionCollectionViewCell, indexPath: IndexPath) {
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
    
    func setupNewsCell(_ cell: SuggestionCollectionViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_demo1()
        case 1:
            cell.imgView.image = R.image.img_demo2()
        case 2:
            cell.imgView.image = R.image.img_demo3()
        case 3:
            cell.imgView.image = R.image.img_demo4()
        default:
            cell.imgView.image = R.image.img_demo5()
        }
        
        cell.imgView.contentMode = .scaleAspectFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
        
        cell.titleLbl.text = "3 Days Tour Packages To France With Airfare"
        cell.pointLbl.text = "100 points"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "120 points")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.discountLbl.attributedText = attributeString
        cell.setShadow()
    }
    
    func setupCategoryCell(_ cell: CategoryCollectionViewCell, indexPath: IndexPath) {
        let item = viewModel.productCategory.value?[indexPath.row]
        
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), completed: nil)
        cell.titleLbl.text = item?.name
        
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.homeViewController.showVoucherDetail.identifier,
           let voucherDetailViewController = segue.destination as? VoucherDetailViewController {
            if let indexPath = suggestionCollectionView.indexPathsForSelectedItems?.first, let voucher = viewModel.listVoucher.value?[indexPath.row] {
                voucherDetailViewController.viewModel.voucher = voucher
                if let vendor = viewModel.listVendor.value?.filter({$0.id == voucher.idVendor}).first {
                    voucherDetailViewController.viewModel.vendor = vendor
                }
            }
        }
    }
    
    @IBAction func seeAllBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestionCollectionView {
            return viewModel.listVoucher.value?.count ?? 0
        } else if collectionView == newsCollectionView {
            return 5
        } else {
            return viewModel.productCategory.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == suggestionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.suggestionCollectionViewCell.identifier, for: indexPath) as? SuggestionCollectionViewCell else { return UICollectionViewCell() }
            setupSuggestionCell(cell, indexPath: indexPath)
            return cell
        } else if collectionView == newsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.suggestionCollectionViewCell.identifier, for: indexPath) as? SuggestionCollectionViewCell else { return UICollectionViewCell() }
            setupNewsCell(cell, indexPath: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.categoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            setupCategoryCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionCollectionView {
            performSegue(withIdentifier: R.segue.homeViewController.showVoucherDetail, sender: self)
        } else if collectionView == newsCollectionView {
        } else {
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == suggestionCollectionView ||
            collectionView == newsCollectionView {
            return CGSize(width: 180, height: collectionView.bounds.height)
        } else {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == suggestionCollectionView ||
            collectionView == newsCollectionView {
            return 16
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == suggestionCollectionView {
            return 16
        } else if collectionView == newsCollectionView {
            return 16
        } else {
            return 10
        }
    }
}
