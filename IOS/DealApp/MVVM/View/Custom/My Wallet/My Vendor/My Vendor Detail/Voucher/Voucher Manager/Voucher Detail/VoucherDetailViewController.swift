//
//  VoucherDetailViewController.swift
//  DealApp
//
//  Created by Macbook on 20/10/2021.
//

import UIKit

class VoucherDetailViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var voucherImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionTextView: BaseTextView!
    @IBOutlet weak var startDateLbl: BaseLabel!
    @IBOutlet weak var pointLbl: BaseLabel!
    @IBOutlet weak var discountLbl: BaseLabel!
    @IBOutlet weak var endDateLbl: BaseLabel!
    @IBOutlet weak var avatarVendorImg: UIImageView!
    @IBOutlet weak var addToCartBtn: BaseButton!
    
    var viewModel = VoucherDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        
        showBackButton(mode: .Light)
        showRightButtons()
        scrollView.contentInsetAdjustmentBehavior = .never
        
        avatarVendorImg.layer.cornerRadius = avatarVendorImg.bounds.size.height/2
        avatarVendorImg.contentMode = .scaleAspectFill
        avatarVendorImg.layer.masksToBounds = true
        
        voucherImg.contentMode = .scaleAspectFill
        voucherImg.layer.masksToBounds = true
        
        titleLbl.text = viewModel.voucher.name
        descriptionTextView.text = viewModel.voucher.description
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        
        voucherImg.sd_setImage(with: URL(string: viewModel.voucher.image ?? ""), placeholderImage: R.image.img_placeholder())
        avatarVendorImg.sd_setImage(with: URL(string: viewModel.vendor.avatar ?? ""), placeholderImage: R.image.img_placeholder())
        
        pointLbl.text = "\(viewModel.voucher.newPrice?.toPercent() ?? "0")"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(viewModel.voucher.oldPrice?.toPercent() ?? "0")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        discountLbl.attributedText = attributeString
        
        startDateLbl.text = viewModel.voucher.dateStart?.toDate(format: .format5)?.toString(format: .format4)
        endDateLbl.text = viewModel.voucher.dateEnd?.toDate(format: .format5)?.toString(format: .format4)
    }
    
   
    
    @IBAction func addToCardAction(_ sender: Any) {
        view.isUserInteractionEnabled = false
        stateView = .loading
        viewModel.addVoucherToCart { [weak self] status, message in
            self?.stateView = .ready
            if status == true {
                guard let strongSelf = self else { return }
                
                let imageView = UIImageView(frame: CGRect(x: strongSelf.addToCartBtn.center.x, y: strongSelf.addToCartBtn.convert(strongSelf.badgeButton.frame, to: nil).midY, width: 30, height: 30))
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 4
                imageView.layer.masksToBounds = true
                imageView.image = strongSelf.voucherImg.image
                
                strongSelf.addToCartAnimation(tempView: imageView)
            } else {
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
