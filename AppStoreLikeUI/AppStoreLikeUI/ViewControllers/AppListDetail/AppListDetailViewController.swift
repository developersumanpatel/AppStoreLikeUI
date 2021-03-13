//
//  AppListDetailViewController.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import UIKit
import Cosmos

class AppListDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var inAppLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    var appInfo: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.isUserInteractionEnabled = false
        ratingView.settings.filledColor = UIColor.lightGray
        ratingView.settings.emptyColor = UIColor.white
        ratingView.settings.filledBorderColor = .clear
        ratingView.settings.emptyBorderColor = UIColor.lightGray
        
        titleLabel.text = appInfo?.artistName ?? ""
        descriptionLabel.text = "\(appInfo?.artistName ?? "")\n\(appInfo?.copyright ?? "")"
        genreLabel.text = appInfo?.genre ?? ""
        if let url = URL(string: appInfo?.artworkUrl100 ?? "") {
            appImageView.sd_setImage(with: url, placeholderImage: UIImage())
        }
    }
    
    @IBAction func updateClicked(_ sender: Any) {
        if let url = URL(string: appInfo?.url ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        if let link = URL(string: appInfo?.url ?? "") {
            let objectsToShare = [link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
