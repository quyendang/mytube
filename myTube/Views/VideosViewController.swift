//
//  VideosViewController.swift
//  myTube
//
//  Created by Quyen Dang on 10/5/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import MXParallaxHeader

class VideosViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var channelView: ChannelView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    func configUI() {
        channelView = Bundle.main.loadNibNamed("ChannelView", owner: self, options: nil)?.first as! ChannelView
        self.myTableView.parallaxHeader.view = channelView
        self.myTableView.parallaxHeader.height = 150
        self.myTableView.parallaxHeader.mode = .fill
        self.myTableView.parallaxHeader.minimumHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
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
