//
//  AppListViewController.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import UIKit

class AppListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var presenter = AppListPresenter(viewDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        presenter.getTopAppList(isFree: false)
        presenter.getTopAppList(isFree: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AppListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.row(for: indexPath) {
        case .header(let header):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AppListHeaderCell") as? AppListHeaderCell {
                cell.configureCell(title: header)
                cell.showAllClickedCompletion = {
                    if let showAllVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowAllViewController") as? ShowAllViewController {
                        showAllVC.appDataList = self.presenter.getFeedData(header)
                        showAllVC.titleString = header
                        self.navigationController?.pushViewController(showAllVC, animated: true)
                    }
                }
                return cell
            }
        case .result(let result, let index, let hide):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AppListCell") as? AppListCell {
                cell.configureCell(data: result, index: index, hideSeparator: hide)
                cell.updateClickedCompletion = {
                    if let url = URL(string: result.url ?? ""), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch presenter.row(for: indexPath) {
        case .header:
            break
        case .result(let result, _, _):
            if let listDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppListDetailViewController") as? AppListDetailViewController {
                listDetailVC.appInfo = result
                self.navigationController?.pushViewController(listDetailVC, animated: true)
            }
            break
        }
    }
}

extension AppListViewController: AppListDelegate {
    func finishWithError(_ error: String) {
        DispatchQueue.main.async {
            self.showAlert(message: error)
        }
    }
    
    func finishWithSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
