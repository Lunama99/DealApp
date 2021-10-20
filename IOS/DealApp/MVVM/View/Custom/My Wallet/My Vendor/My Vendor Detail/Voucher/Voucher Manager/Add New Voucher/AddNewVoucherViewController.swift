//
//  AddNewVoucherViewController.swift
//  DealApp
//
//  Created by Macbook on 16/10/2021.
//

import UIKit

class AddNewVoucherViewController: BaseViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var titleTfx: BaseTextField!
    @IBOutlet weak var descriptionTfx: BaseTextField!
    @IBOutlet weak var quantityTfx: BaseTextField!
    @IBOutlet weak var oldPriceTfx: BaseTextField!
    @IBOutlet weak var newPriceTfx: BaseTextField!
    @IBOutlet weak var addNewBtn: BaseButton!
    @IBOutlet weak var startDateDatePicker: UIDatePicker!
    @IBOutlet weak var endDateDatePicker: UIDatePicker!
    @IBOutlet weak var startDateTfx: BaseTextField!
    @IBOutlet weak var endDateTfx: BaseTextField!
    @IBOutlet weak var deleteBtn: BaseButton!
    
    private let imagePicker = UIImagePickerController()
    private var avatarBase64: String?
    var displayStyle: DisplayStyle = .AddNew
    var callBack: (()->Void)?
    let viewModel = AddNewVoucherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        showBackButton()
        
        if displayStyle == .AddNew {
            title = "Add New Voucher"
            addNewBtn.setTitle("Add New Voucher", for: .normal)
            deleteBtn.isHidden = true
        } else {
            title = "Edit Voucher"
            addNewBtn.setTitle("Update Voucher", for: .normal)
            deleteBtn.isHidden = false
        }
        
        let currWidth = deleteBtn.widthAnchor.constraint(equalToConstant: 70)
        currWidth.isActive = true
        let currHeight = deleteBtn.heightAnchor.constraint(equalToConstant: 30)
        currHeight.isActive = true
        
        imagePicker.delegate = self
        
        viewModel.voucher.value?.dateStart = Date().toString(format: .format7)
        viewModel.voucher.value?.dateEnd = Date().toString(format: .format7)
        
        startDateDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        endDateDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        avatarImg.sd_setImage(with: URL(string: viewModel.voucher.value?.image ?? ""), placeholderImage: R.image.img_store_placeholder())
        avatarImg.layer.cornerRadius = avatarImg.bounds.width/2
        avatarImg.layer.masksToBounds = true
                                                                
        titleTfx.text = viewModel.voucher.value?.name
        descriptionTfx.text = viewModel.voucher.value?.description
        
        if let quantityWare = viewModel.voucher.value?.quantityWare {
            quantityTfx.text = "\(quantityWare)"
        }
        
        if let oldPrice = viewModel.voucher.value?.oldPrice {
            oldPriceTfx.text = "\(oldPrice)"
        }
        
        if let newPrice = viewModel.voucher.value?.newPrice {
            newPriceTfx.text = "\(newPrice)"
        }
        
        titleTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.titleTfx.setwWarning(false)
                self?.viewModel.voucher.value?.name = string
            }
        }
        
        descriptionTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.descriptionTfx.setwWarning(false)
                self?.viewModel.voucher.value?.description = string
            }
        }
        
        quantityTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.quantityTfx.setwWarning(false)
                self?.viewModel.voucher.value?.quantityWare = Int(string)
            }
        }
        
        oldPriceTfx.didChangeValue = { [weak self] string in
            let priceConvert = string.replacingOccurrences(of: ",", with: ".")
            self?.oldPriceTfx.text = priceConvert
            
            if string.count > 0 {
                self?.oldPriceTfx.setwWarning(false)
                self?.viewModel.voucher.value?.oldPrice = Double(priceConvert)
            }
        }
        
        newPriceTfx.didChangeValue = { [weak self] string in
            let priceConvert = string.replacingOccurrences(of: ",", with: ".")
            self?.newPriceTfx.text = priceConvert
            
            if string.count > 0 {
                self?.newPriceTfx.setwWarning(false)
                self?.viewModel.voucher.value?.newPrice = Double(priceConvert)
            }
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        if sender == startDateDatePicker {
            viewModel.voucher.value?.dateStart = sender.date.toString(format: .format7)
            startDateTfx.setwWarning(false)
        } else {
            viewModel.voucher.value?.dateEnd = sender.date.toString(format: .format7)
            endDateTfx.setwWarning(false)
        }
    }
    
    func verifyTfx() -> Bool {
        titleTfx.setwWarning((titleTfx.text?.count ?? 0) <= 0)
        descriptionTfx.setwWarning((descriptionTfx.text?.count ?? 0) <= 0)
        quantityTfx.setwWarning((quantityTfx.text?.count ?? 0) <= 0)
        oldPriceTfx.setwWarning(viewModel.voucher.value?.oldPrice == nil)
        newPriceTfx.setwWarning(viewModel.voucher.value?.newPrice == nil)
        startDateTfx.setwWarning((viewModel.voucher.value?.dateStart?.count ?? 0) <= 0)
        endDateTfx.setwWarning((viewModel.voucher.value?.dateEnd?.count ?? 0) <= 0)
        
        if viewModel.voucher.value?.imageBase64 == nil && viewModel.voucher.value?.image == nil {
            avatarImg.setwWarning(true)
        }
        
        guard titleTfx.text != "" && titleTfx.text != nil else { return false }
        guard descriptionTfx.text != "" && descriptionTfx.text != nil else { return false }
        guard quantityTfx.text != "" && quantityTfx.text != nil else { return false }
        guard viewModel.voucher.value?.oldPrice != nil else { return false }
        guard viewModel.voucher.value?.newPrice != nil else { return false }
        guard (viewModel.voucher.value?.dateEnd?.count ?? 0) > 0 else { return false }
        guard (viewModel.voucher.value?.dateStart?.count ?? 0) > 0 else { return false }
        guard viewModel.voucher.value?.imageBase64 != nil || viewModel.voucher.value?.image != nil else { return false }
        
        return true
    }
    
    @IBAction func updateAction(_ sender: Any) {
        
        guard verifyTfx() else { return }
    
        stateView = .loading
        viewModel.addNewVoucher { [weak self] result, message in
            self?.stateView = .ready
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                if result {
                    self?.callBack?()
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteVoucher() {
        stateView = .loading
        viewModel.deleteVoucher { [weak self] result, message in
            self?.stateView = .ready
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                if result {
                    self?.callBack?()
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editAvatarAction(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Do you want delete this voucher?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.deleteVoucher()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddNewVoucherViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        avatarImg.image = image
        avatarImg.setwWarning(false)
        viewModel.voucher.value?.imageBase64 = image.pngData()?.base64EncodedString()
        
        dismiss(animated: true)
    }
}

extension AddNewVoucherViewController {
    enum DisplayStyle {
        case Edit
        case AddNew
    }
}
