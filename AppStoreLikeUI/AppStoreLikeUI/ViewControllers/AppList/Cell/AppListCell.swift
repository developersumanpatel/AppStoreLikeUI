//
//  AppListCell.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import UIKit
import SDWebImage

class AppListCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var inAppLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    var updateClickedCompletion: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(data: Results, index: Int, hideSeparator: Bool) {
        indexLabel.text = "\(index)"
        titleLabel.text = data.name ?? ""
        descriptionLabel.text = "\(data.artistName ?? "")\n\(data.copyright ?? "")"
        if index == 1 { // added to check different UI
            inAppLabel.isHidden = false
        } else {
            inAppLabel.isHidden = true
        }
        if let url = URL(string: data.artworkUrl100 ?? "") {
            appImageView.sd_setImage(with: url, placeholderImage: UIImage())
        }
        separatorView.isHidden = hideSeparator
    }
    
    @IBAction func updateClicked(_ sender: Any) {
        updateClickedCompletion?()
    }
}
