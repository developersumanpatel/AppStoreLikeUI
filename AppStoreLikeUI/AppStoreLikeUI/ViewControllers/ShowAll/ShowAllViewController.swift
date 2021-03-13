//
//  ShowAllViewController.swift
//  CoredataDemo
//
//  Created by Suman on 13/03/21.
//

import UIKit

class ShowAllViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var appDataList: [Results] = []
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleString ?? ""
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ShowAllViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AppListCell") as? AppListCell {
            cell.configureCell(data: appDataList[indexPath.row], index: indexPath.row + 1, hideSeparator: false)
            cell.updateClickedCompletion = {
                if let url = URL(string: self.appDataList[indexPath.row].url ?? ""), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let listDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppListDetailViewController") as? AppListDetailViewController {
            listDetailVC.appInfo = self.appDataList[indexPath.row]
            self.navigationController?.pushViewController(listDetailVC, animated: true)
        }
    }
}
