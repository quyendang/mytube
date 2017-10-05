//
//  DetailViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import SDWebImage
import ChameleonFramework
protocol DetailViewControllerDelegate: NSObjectProtocol {
    func onChannelTap(viewController: UIViewController, channelID: String)
}
class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelInfoLabel: UILabel!
    @IBOutlet weak var likeCount: UIProgressView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var storylineLabel: LinkLabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    var video: Video?
    weak var delegate: DetailViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configControlUI()
        configUI()
        
    }
    
    func configControlUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapChannelTap(sender:)))
        self.avatarImageView.addGestureRecognizer(tap)
        self.avatarImageView.isUserInteractionEnabled = true
        self.channelTitleLabel.addGestureRecognizer(tap)
        self.channelTitleLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapChannelTap(sender:UITapGestureRecognizer) {
        if video != nil {
            if let channelID = video!.snippet!.channelId {
                self.delegate?.onChannelTap(viewController: self, channelID: channelID)
            }
        }
    }
    
    func setVideo(videoData: Video) {
        self.video = videoData
    }
    
    func configUI() {
        if self.video != nil {
            DispatchQueue.main.async( execute: {
                self.titleLabel.text = self.video!.snippet!.title
                self.storylineLabel.text = self.video!.snippet!.description
                self.linkLabel.text = "https://youtu.be/\(self.video!.id!)"
                let progress = Float(Float(self.video!.statistics!.likeCount) / Float(self.video!.statistics!.dislikeCount + self.video!.statistics!.likeCount))
                self.likeCount.progress = progress
                self.likeCountLabel.text = "\(self.video!.statistics!.likeCount.formattedWithSeparator)"
                self.dislikeCountLabel.text = "\(self.video!.statistics!.dislikeCount.formattedWithSeparator)"
                self.viewsLabel.text = "\(self.video!.statistics!.viewCount.formattedWithSeparator) views"
                Client.shared.getChannelInfo(id: self.video!.snippet!.channelId!, complete: { (response) in
                    self.avatarImageView.sd_setImage(with: URL(string: response.items![0].snippet!.thumbnails!.medium!.url!)!, completed: { (image, error, type, url) in
                        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
                        self.avatarImageView.clipsToBounds = true
                    })
                    self.channelTitleLabel.text = response.items![0].snippet!.title!
                    self.channelInfoLabel.text = "\(response.items![0].statistics!.subscriberCount.formattedWithSeparator) subscribers| \(self.video!.snippet!.publishedAt!.timeAgoSinceDate(numericDates: true))"
                })
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension DetailViewController: LinkLabelDelegate {
    func linkLabelExecuteLink(linkLabel: LinkLabel, text: String, result: NSTextCheckingResult) {
        print(linkLabel)
    }
}
