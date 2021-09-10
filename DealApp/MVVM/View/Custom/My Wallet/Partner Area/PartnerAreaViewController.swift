//
//  PartnerAreaViewController.swift
//  DealApp
//
//  Created by Macbook on 08/09/2021.
//

import UIKit

class PartnerAreaViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup icon
        showNoticeButton()
        showBackButton()
        
        tableView.register(R.nib.partnerAreaTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(_ cell: PartnerAreaTableViewCell, indexPath: IndexPath) {
    }
}

extension PartnerAreaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.partnerAreaTableViewCell.identifier, for: indexPath) as? PartnerAreaTableViewCell else { return UITableViewCell() }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
