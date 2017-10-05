//
//  AccountMenuTableViewCell.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class AccountMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleImage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImageView.tintColor = UIColor.flatRedColorDark()
        let view = UIView()
        view.backgroundColor = UIColor.flatBlack()
        self.selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        if selected {
//            self.selectionStyle = .none
//            self.contentView.backgroundColor = UIColor.flatBlackColorDark()
//        } else {
//            self.selectionStyle = .default
//            self.contentView.backgroundColor = UIColor.clear
//        }
    }

}
