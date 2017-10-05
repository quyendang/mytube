//
//  BaseViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/22/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ChameleonFramework

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor.flatRedColorDark()
        view.addSubview(statusBarView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
