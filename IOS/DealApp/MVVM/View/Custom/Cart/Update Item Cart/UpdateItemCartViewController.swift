//
//  UpdateItemCartViewController.swift
//  DealApp
//
//  Created by Macbook on 22/10/2021.
//

import UIKit

class UpdateItemCartViewController: BaseViewController {
    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var priceLbl: BaseLabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var quantityTfx: BaseTextField!
    
    var viewModel = UpdateItemCartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        minusBtn.tintColor = .darkGray
        minusBtn.setImage(R.image.ic_minus_square()?.withRenderingMode(.alwaysTemplate), for: .normal)
        plusBtn.tintColor = .darkGray
        plusBtn.setImage(R.image.ic_plus_square()?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        nameLb.text = viewModel.item.name
        priceLbl.text = "\(viewModel.item.price?.toPercent() ?? "0")"
        quantityTfx.text = "\(viewModel.item.quantity ?? 0)"
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 4
        imgView.sd_setImage(with: URL(string: viewModel.item.image ?? ""), placeholderImage: R.image.img_placeholder())
        
        quantityTfx.didChangeValue = { [weak self] value in
            if let newQuantity = Int(value) {
                self?.viewModel.item.quantity = newQuantity
            }
        }
    }
    
    @IBAction func didTapOutSide(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateAction(_ sender: Any) {
        stateView = .loading
        viewModel.updateItemCart { [weak self] in
            self?.stateView = .ready
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        viewModel.item.quantity = (viewModel.item.quantity ?? 0) + 1
        quantityTfx.text = "\(viewModel.item.quantity ?? 0)"
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if (viewModel.item.quantity ?? 0) > 0 {
            viewModel.item.quantity = (viewModel.item.quantity ?? 0) - 1
            quantityTfx.text = "\(viewModel.item.quantity ?? 0)"
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Do you want delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.viewModel.item.quantity = 0
            self?.viewModel.updateItemCart { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
