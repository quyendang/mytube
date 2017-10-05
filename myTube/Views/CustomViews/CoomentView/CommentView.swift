//
//  CommentView.swift
//  myTube
//
//  Created by Quyen Dang on 10/3/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import SDWebImage

class CommentView: UIView {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var avatarImageVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //config()
    }
    
    func config() {
        GIDSignIn.sharedInstance().delegate = self
        self.backgroundColor = UIColor.flatBlackColorDark()
        self.commentTextField.attributedPlaceholder = NSAttributedString(string: "Add a public comment...", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatWhiteColorDark()])
        self.avatarImageVIew.layer.cornerRadius = self.avatarImageVIew.bounds.width / 2
        self.avatarImageVIew.clipsToBounds = true
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            self.configUI()
        } else {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    func configUI() {
        let dimension = round(100 * UIScreen.main.scale)
        if let url = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: UInt(dimension)) {
            self.avatarImageVIew.sd_setImage(with: url, completed: nil)
        } else {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CommentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension CommentView: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            configUI()
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            //configUI()
        }
    }
}
