//
//  ChannelViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import MXParallaxHeader
import CarbonKit


class ChannelViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var channelView: ChannelView?
    override func viewDidLoad() {
        super.viewDidLoad()
        //configUI()
        self.configcarbonTabSwipeNavigation()
    }
    
    func configUI() {
        //channelView = Bundle.main.loadNibNamed("ChannelView", owner: self, options: nil)?.first as! ChannelView
        self.myTableView.parallaxHeader.view = channelView
        self.myTableView.parallaxHeader.height = 150
        self.myTableView.parallaxHeader.mode = .fill
        self.myTableView.parallaxHeader.minimumHeight = 100
    }
    
    func configcarbonTabSwipeNavigation() {
        let items = ["Channel", "Playlists", "Info",  "Search"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setNormalColor(UIColor.lightText, font: UIFont(name: "Roboto-Regular", size: 16)!)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont(name: "Roboto-Regular", size: 17)!)
        carbonTabSwipeNavigation.toolbar.isTranslucent = true
        carbonTabSwipeNavigation.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .top, barMetrics: .default)
        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.black
        carbonTabSwipeNavigation.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        carbonTabSwipeNavigation.toolbar.backgroundColor = UIColor.flatRedColorDark()
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        carbonTabSwipeNavigation.setTabExtraWidth(10)
        carbonTabSwipeNavigation.carbonSegmentedControl?.tintColor = UIColor.clear
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.flatRedColorDark()
        navigationController?.navigationBar.alpha = 1
    }
    
}
extension ChannelViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let vc = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "videosViewController") as! VideosViewController
            return vc
        }
        
        if index == 1 {
            let vc = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "playlistsViewController") as! PlaylistsViewController
            return vc
        }
        
        if index == 2 {
            let vc = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "infoViewController") as! InfoViewController
            return vc
        }
        
        if index == 3 {
            let vc = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "channelSearchViewController") as! ChannelSearchViewController
            return vc
        }
        
        return UIViewController()
    }
}

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
