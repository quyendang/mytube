//
//  CommentTableViewCell.swift
//  myTube
//
//  Created by Quyen Dang on 10/1/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
        self.avatarImageView.clipsToBounds = true
        self.likeImage.image = self.likeImage.image?.withRenderingMode(.alwaysTemplate)
        self.likeImage.tintColor = UIColor.flatWhiteColorDark()
    }

    @IBAction func onReplyClick(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
