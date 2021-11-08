//
//  NotificationViewController.swift
//  DealApp
//
//  Created by Macbook on 06/09/2021.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let noticeRepo = NotificationRepository()
    var listNotice: [GetNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    func setupView() {
        showBackButton()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.init(hexString: "#F8F8F8")
        tableView.register(R.nib.notificationTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupCell(_ cell: NotificationTableViewCell, indexPath: IndexPath) {
        let item = listNotice[indexPath.row]
        cell.nameLbl.text = item.name
        cell.descriptionLbl.text = item.description
    }
    
    func fetchData() {
        stateView = .loading
        noticeRepo.getListNotification { [weak self] result in
            self?.stateView = .ready
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetNotification].self)
                    self?.listNotice = model
                    self?.tableView.reloadData()
                } catch {
                    print("update status item failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.notificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else {
            return UITableViewCell()
        }
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
