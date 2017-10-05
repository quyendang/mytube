//
//  MainViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/23/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import CarbonKit
import ChameleonFramework

class MainViewController: BaseViewController {

    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatRedColorDark()
        configcarbonTabSwipeNavigation()
        nameLabel2.transform = CGAffineTransform( rotationAngle: CGFloat(( 90 * Double.pi ) / 180) )
        nameLabel2.transform = CGAffineTransform( rotationAngle: CGFloat(( 90 * Double.pi ) / 180) )
    }
    
    func configcarbonTabSwipeNavigation() {
        let items = ["WATCH THIS", "TRENDING", "SUBSCRIPTIONS",  "ACCOUNT"]
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
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
}

extension MainViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            vc.delegate = self
            //navigationController?.hidesBarsOnSwipe = true
            return vc
        }
        
        if index == 1 {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "subViewController") as! SubViewController
        }
        
//        if index == 2 {
//            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "musicViewController") as! MusicViewController
//        }
        
        if index == 2 {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountViewController") as! AccountViewController
        }
        
        return UIViewController()
    }
}

extension MainViewController: HomeViewControllerDelegate {
    func hideHomeControllerBar(viewController: UIViewController, hiden: Bool) {
        navigationController?.setNavigationBarHidden(hiden, animated: true)
    }
    
    func changeBackGround(imageUrl: String?) {
        
    }
}
