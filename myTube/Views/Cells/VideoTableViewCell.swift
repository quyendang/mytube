//
//  VideoTableViewCell.swift
//  myTube
//
//  Created by Quyen Dang on 9/26/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class VideoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView(frame: self.bounds)
        selectedView.backgroundColor = UIColor.flatBlackColorDark()
        selectedView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        //self.selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
