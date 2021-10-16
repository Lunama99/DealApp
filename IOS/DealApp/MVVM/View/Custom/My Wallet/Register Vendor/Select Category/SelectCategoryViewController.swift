//
//  SelectCategoryViewController.swift
//  DealApp
//
//  Created by Macbook on 09/10/2021.
//

import UIKit
import SDWebImage

class SelectCategoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listCategory: [GetAllCategory] = []
    var categorySelected: ((GetAllCategory)->Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        tableView.register(R.nib.selectCategoryTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(_ cell: SelectCategoryTableViewCell, indexPath: IndexPath) {
        let item = listCategory[indexPath.row]
        cell.imgView.sd_setImage(with: URL(string: item.image ?? ""), completed: nil)
        cell.titleLbl.text = item.name
        
        cell.mainView.setBorder()
    }
}

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.selectCategoryTableViewCell.identifier, for: indexPath) as? SelectCategoryTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            if let item = self?.listCategory[indexPath.row] {
                self?.categorySelected?(item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
