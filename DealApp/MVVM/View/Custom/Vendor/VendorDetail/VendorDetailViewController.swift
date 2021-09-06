//
//  VendorDetailViewController.swift
//  DealApp
//
//  Created by Macbook on 06/09/2021.
//

import UIKit

class VendorDetailViewController: BaseViewController {

    @IBOutlet weak var backBtn: BaseButton!
    @IBOutlet weak var indicatorBtn: BaseLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgScrollView: UIScrollView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var shareBtn: BaseButton!
    @IBOutlet weak var likeBtn: BaseButton!
    @IBOutlet weak var descriptionLbl: BaseLabel!
    
    private var imgFrame = CGRect.zero
    private var numberImg = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "120 points")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        discountLbl.attributedText = attributeString
        
        shareBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        shareBtn.sizeToFit()
        
        likeBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        likeBtn.sizeToFit()

        imgScrollView.isPagingEnabled = true
        imgScrollView.delegate = self
        imgScrollView.bounces = false

        for index in 0...numberImg {
            imgFrame.origin.x = imgScrollView.frame.size.width * CGFloat(index)
            imgFrame.size = imgScrollView.frame.size
            
            let imgView = VendorDetailImageView(frame: imgFrame)
            imgView.layer.masksToBounds = true
            
            switch index {
            case 0:
                imgView.imgView.image = R.image.img_transaction_demo_2()
            case 1:
                imgView.imgView.image = R.image.img_transaction_demo_5()
            default:
                imgView.imgView.image = R.image.img_transaction_demo_3()
            }
            
            imgScrollView.addSubview(imgView)
        }
        
        imgScrollView.contentSize = CGSize(width: (imgScrollView.frame.size.width * CGFloat(numberImg)), height: imgScrollView.frame.size.height)
//        imgScrollView.contentOffset.x = imgScrollView.frame.width * CGFloat(0)
        
        backBtn.backgroundColor = .black.withAlphaComponent(0.2)
        backBtn.bringSubviewToFront(imgScrollView)
        indicatorBtn.backgroundColor = .black.withAlphaComponent(0.2)
        indicatorBtn.bringSubviewToFront(imgScrollView)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension VendorDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        indicatorBtn.text = "\(Int(pageNumber + 1))/\(numberImg)"
    }
}
