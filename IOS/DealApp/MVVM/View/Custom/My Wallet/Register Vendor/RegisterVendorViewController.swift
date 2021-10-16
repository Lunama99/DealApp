//
//  RegisterVendorViewController.swift
//  DealApp
//
//  Created by Macbook on 08/10/2021.
//

import UIKit

class RegisterVendorViewController: BaseViewController {

    @IBOutlet weak var nameTfx: BaseTextField!
    @IBOutlet weak var idCategoryTfx: BaseTextField!
    @IBOutlet weak var paymentDiscountPercentTfx: BaseTextField!
    @IBOutlet weak var captureLicenseBtn: BaseButton!
    @IBOutlet weak var licenseLbl: BaseLabel!
    
    private let viewModel = RegisterViewModel()
    private var categorySelected: GetAllCategory?
    private var licenseBase64: String?
    
    var displayTyle: VendorDisplayTyle = .RegisterVendor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        showBackButton()
        
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
    
    @IBAction func selectCategoryAction(_ sender: Any) {
        if (viewModel.listCategory.value?.count ?? 0) > 0 {
            performSegue(withIdentifier: R.segue.registerVendorViewController.showCategory, sender: self)
        } else {
            stateView = .loading
            viewModel.getCategory { [weak self] in
                self?.stateView = .ready
                self?.performSegue(withIdentifier: R.segue.registerVendorViewController.showCategory, sender: self)
            }
        }
    }
    
    @IBAction func licenseAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard verifyTfx() else { return }
        stateView = .loading
        viewModel.registerVendor(IDCategory: categorySelected?.id ?? "", Name: nameTfx.text ?? "", PaymentDiscountPercent: paymentDiscountPercentTfx.text ?? "0", LicenseBase64: licenseBase64 ?? "") { [weak self] result, message  in
            self?.stateView = .ready
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                if result {
                    if self?.displayTyle == .RegisterVendor {
                        self?.stateView = .loading
                        self?.viewModel.getUser { [weak self] in
                            self?.stateView = .ready
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
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

extension RegisterVendorViewController {
    enum VendorDisplayTyle{
        case RegisterVendor
        case AddNewVendor
    }
}
