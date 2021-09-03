//
//  HomeViewController.swift
//  DealApp
//
//  Created by Macbook on 01/09/2021.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var pointValueLbl: BaseLabel!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup tabbar
        navigationController?.tabBarController?.tabBar.tintColor = .black
        navigationController?.tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(hexString: "#374957")
        
        navigationController?.tabBarController?.tabBar.items?[0].selectedImage = R.image.ic_home_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[1].selectedImage = R.image.ic_vendor_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[2].selectedImage = R.image.ic_point_center_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[3].selectedImage = R.image.ic_transaction_filled()?.withRenderingMode(.alwaysOriginal)
        navigationController?.tabBarController?.tabBar.items?[4].selectedImage = R.image.ic_my_wallet_filled()?.withRenderingMode(.alwaysOriginal)
        
        // Setup avatar
        let avatarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        avatarImg.image = R.image.img_avatar()?.resizeImageWith(newSize: CGSize(width: 30, height: 30))
        avatarImg.contentMode = .scaleAspectFit
        avatarImg.layer.cornerRadius = 15
        avatarImg.layer.masksToBounds = true
        let avatarLeftBarButton = UIBarButtonItem(customView: avatarImg)
        
        // Setup title
        let titleLbl = BaseLabel()
        titleLbl.style = 3
        titleLbl.text = "Good Everning, Tam!"
        let titleLeftBarButton = UIBarButtonItem(customView: titleLbl)
        
        navigationItem.leftBarButtonItems = [avatarLeftBarButton, titleLeftBarButton]
        
        // Setup icon
        let noticeView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let noticeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        noticeImg.center = noticeView.center
        noticeImg.image = R.image.ic_notification()
        noticeImg.contentMode = .scaleAspectFit
        noticeView.layer.cornerRadius = 4
        noticeView.backgroundColor = .systemGray6
        noticeView.addSubview(noticeImg)
        let noticeRightBarButton = UIBarButtonItem(customView: noticeView)
        
        navigationItem.rightBarButtonItem = noticeRightBarButton
        
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
    
    func setupSuggestionCell(_ cell: SuggestionCollectionViewCell, indexPath: IndexPath) {
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
        
        cell.imgView.contentMode = .scaleToFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
        
        cell.titleLbl.text = "3 Days Tour Packages To France With Airfare"
        cell.pointLbl.text = "100 points"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "120 points")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.discountLbl.attributedText = attributeString
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
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
        
        cell.imgView.contentMode = .scaleToFill
        cell.imgView.layer.cornerRadius = 4
        cell.imgView.layer.masksToBounds = true
        
        cell.titleLbl.text = "3 Days Tour Packages To France With Airfare"
        cell.pointLbl.text = "100 points"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "120 points")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        cell.discountLbl.attributedText = attributeString
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
    
    func setupCategoryCell(_ cell: CategoryCollectionViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.ic_travel()
            cell.titleLbl.text = "Travel"
        case 1:
            cell.imgView.image = R.image.ic_shopping()
            cell.titleLbl.text = "Travel"
        case 2:
            cell.imgView.image = R.image.ic_food()
            cell.titleLbl.text = "Food"
        case 3:
            cell.imgView.image = R.image.ic_education()
            cell.titleLbl.text = "Education"
        case 4:
            cell.imgView.image = R.image.ic_spa()
            cell.titleLbl.text = "Spa"
        default:
            cell.imgView.image = R.image.ic_event()
            cell.titleLbl.text = "Event"
        }
        
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestionCollectionView {
            return 5
        } else if collectionView == newsCollectionView {
            return 5
        } else {
            return 6
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
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == suggestionCollectionView ||
            collectionView == newsCollectionView {
            return CGSize(width: 200, height: collectionView.bounds.height)
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
