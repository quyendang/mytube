//
//  AccountViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/23/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var headerView: AccountHeaderView!
    var menuList = [Menu]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AccountHeaderView", bundle: nil)
        myTableView.register(nib, forHeaderFooterViewReuseIdentifier: "AccountHeaderView")
        headerView = myTableView.dequeueReusableHeaderFooterView(withIdentifier: "AccountHeaderView") as! AccountHeaderView
        headerView.delegate = self
        createMenuItems()
        updateAccountUI()
    }
    
    func createMenuItems() {
        menuList.append(Menu(title: "Favorites", icon: "favorite"))
        menuList.append(Menu(title: "Liked", icon: "like"))
        menuList.append(Menu(title: "Watch later", icon: "watch"))
        menuList.append(Menu(title: "Playlists", icon: "menu"))
        menuList.append(Menu(title: "History", icon: "history"))
        menuList.append(Menu(title: "Saved", icon: "saved"))
        menuList.append(Menu(title: "Subscribed to", icon: "subscription"))
    }
    
    func updateAccountUI() {
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.updateChannelInfo()
    }
}

extension AccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountMenuCell") as! AccountMenuTableViewCell
        let menuItem = menuList[indexPath.row]
        cell.iconImageView.image = UIImage(named: menuItem.icon!)
        cell.titleImage.text = menuItem.title!
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            switch indexPath.row {
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 4:
                break
            case 5:
                break
            case 6:
                let subViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "subscriberNavigation") as! UINavigationController
                self.present(subViewController, animated: true, completion: nil)
            default :
                print("Over")
            }
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
}

extension AccountViewController: AccountHeaderViewDelegate {
    func onExpandClick() {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Login", "Logout")
        actionSheet.show(in: self.view)
    }
}

extension AccountViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch (buttonIndex){
        case 0:
            GIDSignIn.sharedInstance().signIn()
        case 1:
            GIDSignIn.sharedInstance().signOut()
        case 2:
            GIDSignIn.sharedInstance().signOut()
        default:
            print("hihi")
    }
        
    }
}

extension AccountViewController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        //print(signIn.currentUser.authentication.accessToken)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
}
