//
//  CommentViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import SDWebImage

class CommentViewController: UIViewController {
    var video: Video?
    var currentCommentResponse: CommentResponse?
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeVideo(notification:)), name: NSNotification.Name(rawValue: "videoChange"), object: nil)
    }
    
    @objc func changeVideo(notification: Notification) {
        if let video = notification.userInfo?["video"] as? Video {
            self.setVideo(videoData: video)
            getComment()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentCommentResponse == nil {
            getComment()
        }
    }
    
    func setVideo(videoData: Video) {
        self.video = videoData
        self.currentCommentResponse = nil
    }
    
    
    
    func getComment() {
        Client.shared.getCommentListByVideoId(id: video!.id, nextPageToken: nil) { (response) in
            self.currentCommentResponse = response
            self.myTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCommentResponse == nil ? 0 : currentCommentResponse!.items == nil ? 0 : currentCommentResponse!.items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell") as! CommentTableViewCell
        let comment = currentCommentResponse!.items![indexPath.row]
        cell.nameLabel.text = comment.snippet!.topLevelComment!.snippet!.authorDisplayName!
        cell.avatarImageView.sd_setImage(with: URL(string: comment.snippet!.topLevelComment!.snippet!.authorProfileImageUrl!), completed: nil)
        cell.commentText.text = comment.snippet!.topLevelComment!.snippet!.textOriginal!
        cell.likeCountLabel.text = "\(comment.snippet!.topLevelComment!.snippet!.likeCount!)"
        cell.timeLabel.text = "\(comment.snippet!.topLevelComment!.snippet!.publishedAt!.timeAgoSinceDate(numericDates: true)) |"
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentCommentResponse!.items!.count - 1 {
            if currentCommentResponse != nil{
                currentCommentResponse!.fetchNextData(videoId: video!.id, complete: {
                    self.myTableView.reloadData()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = CommentView.instanceFromNib() as! CommentView
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        let cmView = CommentView.instanceFromNib() as! CommentView
        cmView.frame = CGRect(x: 0, y: 0, width: cmView.bounds.width, height: 50)
        let barItem = UIBarButtonItem(customView: cmView)
        toolBar.setItems([barItem], animated: true)
        toolBar.sizeToFit()
        view.commentTextField.inputAccessoryView = toolBar
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
