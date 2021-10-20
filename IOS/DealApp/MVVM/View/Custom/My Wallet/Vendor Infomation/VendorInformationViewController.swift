//
//  VendorInformationViewController.swift
//  DealApp
//
//  Created by Macbook on 12/10/2021.
//

import UIKit

class VendorInformationViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameTfx: BaseTextField!
    @IBOutlet weak var descriptionTfx: BaseTextField!
    
    private let imagePicker = UIImagePickerController()
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let spacing: CGFloat = 16
    private var avatarBase64: String?
    
    var viewModel = VendorInformationViewModel()
    var callBack: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservable()
    }
    
    func setupView() {
        showBackButton()
        
        title = viewModel.vendor?.name
        
        imagePicker.delegate = self
        
        avatarImg.sd_setImage(with: URL(string: viewModel.vendor?.avatar ?? ""), placeholderImage: R.image.img_store_placeholder())
        avatarImg.layer.cornerRadius = avatarImg.bounds.width/2
        avatarImg.layer.masksToBounds = true
        
        collectionView.register(R.nib.vendorImageCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.dataSource = self
                                                                
        avatarImg.sd_setImage(with: URL(string: viewModel.vendor?.avatar ?? ""), placeholderImage: R.image.img_store_placeholder())
        
        avatarImg.layer.cornerRadius = avatarImg.frame.size.height/2
        avatarImg.layer.masksToBounds = true
        
        nameTfx.text = viewModel.vendor?.name
        descriptionTfx.text = viewModel.vendor?.description
        
        nameTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.nameTfx.setwWarning(false)
                self?.viewModel.vendor?.name = string
            }
        }
        
        descriptionTfx.didChangeValue = { [weak self] string in
            if string.count > 0 {
                self?.descriptionTfx.setwWarning(false)
                self?.viewModel.vendor?.description = string
            }
        }
    }
    
    func setupObservable() {
        viewModel.listImage.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    func setupCell(_ cell: VendorImageCollectionViewCell, indexPath: IndexPath) {
        let currWidth = cell.widthAnchor.constraint(equalToConstant: collectionView.bounds.height)
        currWidth.isActive = true
        let currHeight = cell.heightAnchor.constraint(equalToConstant: collectionView.bounds.height)
        currHeight.isActive = true
        
        cell.vendorImg.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        
        if indexPath.row < (viewModel.listImage.value?.count ?? 0) {
            let image = viewModel.listImage.value?[indexPath.row]
            cell.iconBtn.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.vendorImg.image = image
            cell.vendorImg.backgroundColor = .clear
            cell.vendorImg.alpha = 0.8
            cell.deleteBtn.isHidden = false
        } else {
            cell.iconBtn.setImage(UIImage.init(systemName: "plus"), for: .normal)
            cell.vendorImg.backgroundColor = .systemGray5
            cell.vendorImg.image = nil
            cell.vendorImg.alpha = 1
            cell.deleteBtn.isHidden = true
        }
        
        cell.callBack = { [weak self] in
            self?.viewModel.isChangeListImage = true
            self?.viewModel.listImage.value?.remove(at: indexPath.row)
        }
    }
    
    func verifyTfx() -> Bool {
        nameTfx.setwWarning((nameTfx.text?.count ?? 0) <= 0)
        descriptionTfx.setwWarning((descriptionTfx.text?.count ?? 0) <= 0)
        
        if avatarBase64 == nil && viewModel.vendor?.avatar == nil {
            avatarImg.setwWarning(true)
        }
        
        if (viewModel.vendor?.imageList?.count ?? 0) == 0 && (viewModel.listImage.value?.count ?? 0) == 0 {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? VendorImageCollectionViewCell {
                cell.vendorImg.setwWarning(true)
            }
        }
        
        guard nameTfx.text != "" && nameTfx.text != nil else { return false }
        guard descriptionTfx.text != "" && descriptionTfx.text != nil else { return false }
        guard viewModel.vendor?.avatar != nil || avatarBase64 != nil else { return false }
        guard (viewModel.vendor?.imageList?.count ?? 0) > 0 || (viewModel.listImage.value?.count ?? 0) > 0 else { return false }
        
        return true
    }
    
    @IBAction func updateAction(_ sender: Any) {
        
        guard verifyTfx() else { return }
        
        let vendor = viewModel.vendor

        stateView = .loading
        viewModel.updateVendorInformation(ID: vendor?.id ?? "", Name: vendor?.name ?? "", Description: vendor?.description ?? "", AvatarBase64: avatarBase64) { [weak self] result, message in
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
        imagePicker.restorationIdentifier = ImagePicker.Avatar.rawValue
        present(imagePicker, animated: true)
    }
}

extension VendorInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.vendorImageCollectionViewCell.identifier, for: indexPath) as? VendorImageCollectionViewCell else { return UICollectionViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imagePicker.restorationIdentifier = ImagePicker.List.rawValue
        present(imagePicker, animated: true)
    }
}

extension VendorInformationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height, height: height)
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

extension VendorInformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originImg = info[.originalImage] as? UIImage else { return }
        let image = originImg.resizeImageWith(newSize: CGSize(width: 500, height: 0))
        switch picker.restorationIdentifier {
        case ImagePicker.Avatar.rawValue:
            avatarImg.image = image
            avatarImg.setwWarning(false)
            avatarBase64 = image.pngData()?.base64EncodedString()
        case ImagePicker.List.rawValue:
            
            viewModel.isChangeListImage = true
            
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? VendorImageCollectionViewCell {
                cell.vendorImg.setwWarning(false)
            }
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                if indexPath.row < (viewModel.listImage.value?.count ?? 0) {
                    viewModel.listImage.value?[indexPath.row] = image
                } else {
                    viewModel.listImage.value?.append(image)
                }
            }
        default: break
        }
        
        dismiss(animated: true)
    }
}

extension VendorInformationViewController {
    enum ImagePicker: String {
        case Avatar = "Avatar"
        case List = "List"
    }
}
