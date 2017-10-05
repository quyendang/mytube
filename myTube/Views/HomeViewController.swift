//
//  HomeViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/23/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import CMTabbarView
import SDWebImage
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    var videoList = [Video]()
    var currentVideoResponse: VideosResponse?
    var refreshControl: UIRefreshControl!
    var categorySelectedIndex = 0
    var headerCell: VideoHeaderView!
    weak var delegate: HomeViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefrehControl()
        self.initTableView()
        Client.shared.getMostPopularBycategory(category: "0", params: nil, nextPageToken: nil, complete: { (response) in
            self.currentVideoResponse = response
            self.myTableView.reloadData()
        })
    }
    
    func initTableView() {
        myTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "video_cell")
        let nib = UINib(nibName: "VideoHeaderView", bundle: nil)
        myTableView.register(nib, forHeaderFooterViewReuseIdentifier: "VideoHeaderView")
        headerCell = myTableView.dequeueReusableHeaderFooterView(withIdentifier: "VideoHeaderView") as! VideoHeaderView
        headerCell.delegate = self
    }
    
    func initRefrehControl() {
        refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: -50, width: self.view.bounds.width, height: 50))
        refreshControl.addTarget(self, action: #selector(completeLoading), for: .valueChanged)
        let loadingView = NVActivityIndicatorView(frame: refreshControl.bounds, type: NVActivityIndicatorType.ballBeat, color: UIColor.flatRedColorDark(), padding: 0)
        loadingView.startAnimating()
        refreshControl.tintColor = UIColor.clear
        refreshControl.addSubview(loadingView)
        myTableView.addSubview(refreshControl)
    }
    
    
    @IBAction func onCateGorySelected(_ sender: UIButton) {
    }
    @objc func completeLoading() {
        let category = categorySelectedIndex == 0 ? "0": Client.shared.categoryList[categorySelectedIndex-1].id
        Client.shared.getMostPopularBycategory(category: category!, params: nil, nextPageToken: nil, complete: { (response) in
            self.currentVideoResponse = response
            self.myTableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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
                let category = categorySelectedIndex == 0 ? "0": Client.shared.categoryList[categorySelectedIndex-1].id
                currentVideoResponse!.fetchNextData(withCategory: category!, complete: {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
}

extension HomeViewController: VideoHeaderViewDelegate{
    func onHeaderViewClick(headerView: UIView) {
        let vc = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "alertViewController") as! AlertViewController
        vc.currentSelectedIndex = categorySelectedIndex
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: AlertViewControllerDelegate{
    func onCategorySelectedItem(index: Int) {
        if self.categorySelectedIndex != index {
            var genres = "0"
            if index == 0 {
                headerCell.titleLabel.text = "All"
            } else {
                headerCell.titleLabel.text = Client.shared.categoryList[index-1].snippet!.title!
                genres = Client.shared.categoryList[index-1].id
            }
            
            categorySelectedIndex = index
            Client.shared.getMostPopularBycategory(category: genres, params: nil, nextPageToken: nil, complete: { (response) in
                self.currentVideoResponse = response
                self.myTableView.reloadData()
            })
        }
    }
}

extension HomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 100){
            delegate?.hideHomeControllerBar(viewController: self, hiden: false)
        } else {
            delegate?.hideHomeControllerBar(viewController: self, hiden: true)
        }
    }
}

protocol HomeViewControllerDelegate: NSObjectProtocol {
    func hideHomeControllerBar(viewController: UIViewController, hiden: Bool)
    func changeBackGround(imageUrl: String?)
}

