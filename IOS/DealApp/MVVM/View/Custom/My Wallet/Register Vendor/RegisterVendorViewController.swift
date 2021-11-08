//
//  RegisterVendorViewController.swift
//  DealApp
//
//  Created by Macbook on 08/10/2021.
//

import UIKit
import SDWebImage

class RegisterVendorViewController: BaseViewController {

    @IBOutlet weak var nameTfx: BaseTextField!
    @IBOutlet weak var idCategoryTfx: BaseTextField!
    @IBOutlet weak var paymentDiscountPercentTfx: BaseTextField!
    @IBOutlet weak var captureLicenseBtn: BaseButton!
    @IBOutlet weak var licenseLbl: BaseLabel!
    
    private let viewModel = RegisterViewModel()
    private var categorySelected: GetAllCategory?
    private var licenseBase64: String?
    
    var vendor: GetListVendorRegister?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    func setupView() {
        showBackButton()
        
        if let vendor = vendor {
            nameTfx.text = vendor.name
            
            if let payment = vendor.paymentDiscountPercent {
                paymentDiscountPercentTfx.text = "\(Int(payment))"
            }
            
            if let licenseImage = vendor.license {
                SDWebImageManager.shared.loadImage(with: URL(string: licenseImage), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    guard let image = image else { return }
                    self.licenseBase64 = image.pngData()?.base64EncodedString()
                }
            }
        }
        
        nameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.nameTfx.setwWarning(false)
            }
        }
        
        paymentDiscountPercentTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.paymentDiscountPercentTfx.setwWarning(false)
            }
        }
        
        if let imageView =  captureLicenseBtn.imageView {
            captureLicenseBtn.bringSubviewToFront(imageView)
            captureLicenseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5);
            captureLicenseBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0);
        }
    }
    
    func verifyTfx() -> Bool {
        idCategoryTfx.setwWarning((idCategoryTfx.text?.count ?? 0) <= 0)
        nameTfx.setwWarning((nameTfx.text?.count ?? 0) <= 0)
        paymentDiscountPercentTfx.setwWarning((paymentDiscountPercentTfx.text?.count ?? 0) <= 0)
        captureLicenseBtn.setwWarning(licenseBase64 == nil)
        
        guard idCategoryTfx.text != "" && idCategoryTfx.text != nil else { return false }
        guard nameTfx.text != "" && nameTfx.text != nil else { return false }
        guard paymentDiscountPercentTfx.text != "" && paymentDiscountPercentTfx.text != nil else { return false }
        guard licenseBase64 != nil else { return false }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.registerVendorViewController.showCategory.identifier,
           let nav = segue.destination as? UINavigationController, let selectCategoryViewController = nav.topViewController as? SelectCategoryViewController {
            selectCategoryViewController.listCategory = viewModel.listCategory.value ?? []
            selectCategoryViewController.categorySelected = { [weak self] item in
                self?.idCategoryTfx.setwWarning(false)
                self?.categorySelected = item
                self?.idCategoryTfx.text = item.name
            }
        }
    }
    
    func fetchData() {
        stateView = .loading
        viewModel.getCategory { [weak self] in
            self?.stateView = .ready
            if let vendorCategoryId = self?.vendor?.idCategory {
                if let category = self?.viewModel.listCategory.value?.filter({$0.id == vendorCategoryId}).first {
                    self?.idCategoryTfx.text = category.name
                    self?.categorySelected = category
                }
            }
        }
    }
    
    @IBAction func selectCategoryAction(_ sender: Any) {
        performSegue(withIdentifier: R.segue.registerVendorViewController.showCategory, sender: self)
    }
    
    @IBAction func licenseAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard verifyTfx() else { return }
        stateView = .loading
        viewModel.registerVendor(ID: vendor?.id, IDCategory: categorySelected?.id ?? "", Name: nameTfx.text ?? "", PaymentDiscountPercent: paymentDiscountPercentTfx.text ?? "0", LicenseBase64: licenseBase64 ?? "") { [weak self] result, message  in
            self?.stateView = .ready
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                if result {
                    self?.stateView = .loading
                    self?.viewModel.getUser { [weak self] in
                        self?.stateView = .ready
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension RegisterVendorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let filename = (info[.imageURL] as? NSURL)?.lastPathComponent ?? ""
        licenseLbl.text = filename
        captureLicenseBtn.setwWarning(false)
        licenseBase64 = image.pngData()?.base64EncodedString()
        dismiss(animated: true)
    }
}
