//
//  MainChannelViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import CarbonKit
import ChameleonFramework

class MainChannelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Channel"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.flatRedColorDark()
        navigationController?.navigationBar.alpha = 1
        let searchButton = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: self, action: nil)
        searchButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = searchButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainChannelViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            return UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "channelViewController") as! ChannelViewController
        }
        
        return UIViewController()
    }
}
