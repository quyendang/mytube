//
//  RelatedViewController.swift
//  myTube
//
//  Created by Quyen Dang on 10/3/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class RelatedViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var videoList = [Video]()
    var video: Video?
    var currentVideoResponse: VideosResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeVideo(notification:)), name: NSNotification.Name(rawValue: "videoChange"), object: nil)
    }
    
    @objc func changeVideo(notification: Notification) {
        if let video = notification.userInfo?["video"] as? Video {
            self.setVideo(videoData: video)
            getVideo()
        }
    }
    func setVideo(videoData: Video) {
        self.video = videoData
        self.currentVideoResponse = nil
    }
    func getVideo() {
        Client.shared.getRelatedVideosById(id: video!.id, nextPageToken: nil) { (response) in
            self.currentVideoResponse = response
            self.myTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentVideoResponse == nil {
            getVideo()
        }
    }
    
    func initTableView() {
        myTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "video_cell")
        let nib = UINib(nibName: "VideoHeaderView", bundle: nil)
        //myTableView.register(nib, forHeaderFooterViewReuseIdentifier: "VideoHeaderView")
        // = myTableView.dequeueReusableHeaderFooterView(withIdentifier: "VideoHeaderView") as! VideoHeaderView
        //headerCell.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RelatedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentVideoResponse == nil ? 0 : currentVideoResponse!.items == nil ? 0 : currentVideoResponse!.items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "video_cell") as! VideoTableViewCell
        let video = currentVideoResponse!.items![indexPath.row]
        cell.titleLabel.text = video.snippet?.title!
        if let views = video.statistics?.viewCount.formattedWithSeparator, let duration = video.contentDetails?.duration{
            cell.timeLabel.text = "\(views) views| \(duration)"
        }
        
        if let coverImageView =  video.snippet?.thumbnails?.medium?.url{
            cell.coverImageView.sd_setImage(with: URL(string: coverImageView)!) { (image, error, _, _) in
                
            }
        }
        
        if let channelTitle = video.snippet?.channelTitle {
            cell.channelLabel.text = channelTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentVideoResponse!.items!.count - 1 {
            if currentVideoResponse != nil{
                currentVideoResponse?.fetchNextData(videoId: video!.id, complete: {
                    self.myTableView.reloadData()
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = currentVideoResponse!.items![indexPath.row]
        let data = ["video": video]
        NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil, userInfo: data)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
