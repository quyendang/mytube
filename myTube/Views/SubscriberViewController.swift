//
//  SubscriberViewController.swift
//  myTube
//
//  Created by Quyen Dang on 9/27/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
class SubscriberViewController: BaseViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    var subscriberResponse: SubscriptionsResponse?
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubscribers()
        initRefrehControl()
    }
    
    func getSubscribers() {
        Client.shared.getSubscriptionsUrl(nextPageToken: nil, complete: { (response) in
            self.subscriberResponse = response
            self.myCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }, error: { (error) in
            
        })
    }
    
    func initRefrehControl() {
        refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: -50, width: self.view.bounds.width, height: 50))
        refreshControl.addTarget(self, action: #selector(completeLoading), for: .valueChanged)
        let loadingView = NVActivityIndicatorView(frame: refreshControl.bounds, type: NVActivityIndicatorType.ballBeat, color: UIColor.flatRedColorDark(), padding: 0)
        loadingView.startAnimating()
        refreshControl.tintColor = UIColor.clear
        refreshControl.addSubview(loadingView)
        myCollectionView.addSubview(refreshControl)
    }
    
    @objc func completeLoading() {
        getSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Subscribed to"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.flatRedColorDark()
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let backButton = UIBarButtonItem(image: UIImage(named: "expand"), style: .plain, target: self, action: #selector(dissmissViewController))
        backButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dissmissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SubscriberViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriberResponse == nil ? 0 : subscriberResponse!.items == nil ? 0 : subscriberResponse!.items!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriber_cell", for: indexPath) as! SubscriberCollectionViewCell
        let subscriber = subscriberResponse!.items![indexPath.item]
        cell.backgroundImageView.sd_setImage(with: URL(string: subscriber.snippet!.thumbnails!.medium!.url!)!, completed: nil)
        cell.avatarImageView.sd_setImage(with: URL(string: subscriber.snippet!.thumbnails!.medium!.url!)!, completed: nil)
        cell.titleLabel.text = subscriber.snippet?.title!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == subscriberResponse!.items!.count - 2 {
            subscriberResponse?.fetchNextData(complete: {
                self.myCollectionView.reloadData()
            })
        }
    }
}
