//
//  AppListHeaderCell.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import UIKit

import SDWebImage
class AppListHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var showAllClickedCompletion: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func showAllClicked(_ sender: Any) {
        showAllClickedCompletion?()
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
