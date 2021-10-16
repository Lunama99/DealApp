//
//  VendorInformationViewModel.swift
//  DealApp
//
//  Created by Macbook on 13/10/2021.
//

import Foundation
import UIKit
import SDWebImage
import Moya

class VendorInformationViewModel {
    
    private let vendorRepo = VendorRepository()
    var vendor: GetListVendorRegister? {
        didSet {
            getListImage()
        }
    }
    var listImage: Observable<[UIImage]> = Observable([])
    var isChangeListImage: Bool = false
    
    func updateVendorInformation(ID: String, Name: String, Description: String, AvatarBase64: String?, completion: @escaping((Bool, String?)->Void)) {
        
        var listImageBase64: [String]?
        
        if let listImage = listImage.value, isChangeListImage {
            listImageBase64 = listImage.map({$0.pngData()?.base64EncodedString() ?? ""})
        }
        
        vendorRepo.updateVendorInformation(ID: ID, Name: Name, Description: Description, AvatarBase64: AvatarBase64, ImageListBase64: listImageBase64, address: nil) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        print(model)
                        completion(true, model.message)
                    } else {
                        completion(false, model.message)
                    }
                } catch {
                    print("register vendor failed")
                    completion(false, nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getListImage() {
        vendor?.imageList?.forEach({ image in
            SDWebImageManager.shared.loadImage(with: URL(string: image.path ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                guard let image = image else { return }
                self.listImage.value?.append(image)
            }
        })
    }
}
