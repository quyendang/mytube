//
//  AccountHeaderView.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import SDWebImage

class AccountHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    var delegate: AccountHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateChannelInfo() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            if let currentUser = GIDSignIn.sharedInstance().currentUser {
                let dimension = round(100 * UIScreen.main.scale)
                if let imageUrl = currentUser.profile.imageURL(withDimension: UInt(dimension)) {
                    self.titleLabel.text = GIDSignIn.sharedInstance().currentUser.profile.name
                    self.avatarImageView.sd_setImage(with: imageUrl, completed: nil)
                }
            }
        } else {
            self.titleLabel.text = "Sign in"
            self.avatarImageView.image = UIImage(named: "account_placeholder")
        }
        
    }
    
    
    @IBAction func onMoreClick(_ sender: UIButton) {
        if (delegate != nil) {
            delegate?.onExpandClick()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
