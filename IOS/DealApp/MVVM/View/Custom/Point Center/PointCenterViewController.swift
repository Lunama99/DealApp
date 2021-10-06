//
//  PointCenterViewController.swift
//  DealApp
//
//  Created by Macbook on 04/09/2021.
//

import UIKit

class PointCenterViewController: BaseViewController {

    @IBOutlet weak var gameView: BaseView!
    @IBOutlet weak var advertiseView: BaseView!
    @IBOutlet weak var surveyView: BaseView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let contentInsetCV = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    private let numberOfColumn: CGFloat = 2
    private let spacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        
        collectionView.register(R.nib.pointCenterCollectionViewCell)
        collectionView.contentInset = contentInsetCV
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func gameAction(_ sender: Any) {
        advertiseView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        surveyView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        gameView.backgroundColor = .white
    }
    
    @IBAction func advertiseAction(_ sender: Any) {
        advertiseView.backgroundColor = .white
        surveyView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        gameView.backgroundColor = UIColor.init(hexString: "EFF3F6")
    }
    
    @IBAction func surveyAction(_ sender: Any) {
        advertiseView.backgroundColor = UIColor.init(hexString: "EFF3F6")
        surveyView.backgroundColor = .white
        gameView.backgroundColor = UIColor.init(hexString: "EFF3F6")
    }
    
    func setupCell(_ cell: PointCenterCollectionViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.imgView.image = R.image.img_game_1()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Candy Crush"
        case 1:
            cell.imgView.image = R.image.img_game_2()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Fruit Ninja"
        case 2:
            cell.imgView.image = R.image.img_game_3()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Sweet Crossing"
        default:
            cell.imgView.image = R.image.img_game_4()?.resizeImageWith(newSize: CGSize(width: cell.frame.width, height: cell.frame.width))
            cell.titleLbl.text = "Talking Tom"
        }
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
    }
}

extension PointCenterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.pointCenterCollectionViewCell.identifier, for: indexPath) as? PointCenterCollectionViewCell else { return UICollectionViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
}

extension PointCenterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (contentInsetCV.left + contentInsetCV.right + spacing))/numberOfColumn - 1
        return CGSize(width: width, height: width/2*3)
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
