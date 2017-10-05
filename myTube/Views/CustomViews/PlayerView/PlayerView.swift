//
//  PlayerView.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import CarbonKit
import SDWebImage
import SnapKit
import VGPlayer
import SGActionView
import XCDYouTubeKit
protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func didMinimize(withChannelID: String)
}


class PlayerView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak var thubImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    var detailVC: DetailViewController!
    var commentVC: CommentViewController!
    var relatedVC: RelatedViewController!
    var direction = Direction.none
    var playerView = VGPlayer()
    var currentVideo: Video?
    var selectedQualityIndex = 0
    var currentStreamList: [[String: Any]]?
    @IBAction func miniPan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            //print(sender.translation(in: nil).y)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                //self.videoPlayer.pause()
                self.playerView.cleanPlayer()
            }
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        //self.minimizeButton.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
        self.player.transform = trasform
    }
    @IBOutlet weak var player: UIView!
    @IBOutlet weak var minimizeButton: UIButton!
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    func customization() {
        self.backgroundColor = UIColor.clear
        self.player.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.player.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayViewNoPass)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView(notification:)), name: NSNotification.Name("open"), object: nil)
    }
    
    @IBAction func minimizeButtonClick(_ sender: Any) {
        self.state = .minimized
        self.delegate?.didMinimize()
        animate()
    }
    
    @objc func tapPlayViewNoPass()  {
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
    }
    
    func loadVideoStream(videoID: String) {
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { (video, error) in
            if video != nil {
                //self.currentStreamList = lists
                if let url = video!.streamURLs[22] {
                    self.selectedQualityIndex = 0
                    let dataToPass = ["url": url.absoluteString, "title": self.currentVideo!.snippet!.title!, "channelTitle": self.currentVideo!.snippet!.channelTitle!, "image": self.currentVideo!.snippet!.thumbnails!.medium!.url!]
                    //self.playerView.replaceVideo(url)
                    DispatchQueue.main.async {
                        self.playerView.replaceVideoData(dataToPass)
                        VGPlayerCacheManager.shared.cleanAllCache()
                        self.playerView.play()
                    }
                }
                
            } else {
                
            }
        }
        
//        YoutubeParser.shared.h264videos(videoId: videoID) { (lists) in
//            self.currentStreamList = lists
//            self.selectedQualityIndex = 0
//            let dataToPass = ["url": lists[0]["url"]!, "title": self.currentVideo!.snippet!.title!, "channelTitle": self.currentVideo!.snippet!.channelTitle!, "image": self.currentVideo!.snippet!.thumbnails!.medium!.url!]
//            //self.playerView.replaceVideo(url)
//            self.playerView.replaceVideoData(dataToPass as! [String : String])
//            VGPlayerCacheManager.shared.cleanAllCache()
//            self.playerView.play()
//        }
    }
    
    @objc func tapPlayView(notification: NSNotification?)  {
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
        if let noti = notification {
            if let video = noti.userInfo?["video"] as? Video {
                detailVC.setVideo(videoData: video)
                commentVC.setVideo(videoData: video)
                relatedVC.setVideo(videoData: video)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoChange"), object: nil, userInfo: noti.userInfo)
                self.currentVideo = video
                self.playerView.displayView.titleLabel.text = video.snippet!.title!
                self.playerView.displayView.channelLabel.text = video.snippet!.channelTitle!
                loadVideoStream(videoID: video.id)
                //self.thubImageView.sd_setImage(with: URL(string: video.snippet!.thumbnails!.medium!.url!)!, placeholderImage: UIImage(named: "maxresdefault"), completed: nil)
            }
        }
        if infoView.subviews.count == 0 {
            addCarbonKit()
        }
    }
    
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.displayView.bottomView.alpha = 1
                self.playerView.displayView.topView.alpha = 1
                self.playerView.displayView.doubleTapGesture.isEnabled = true
                self.playerView.displayView.singleTapGesture.isEnabled = true
                self.player.transform = CGAffineTransform.identity
                UIApplication.shared.isStatusBarHidden = true
                self.playerView.displayView.panGesture.isEnabled = self.playerView.displayView.isDisplayControl
            })
            self.detailVC.configUI()
            //
            
            
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = false
                self.playerView.displayView.bottomView.alpha = 0
                self.playerView.displayView.topView.alpha = 0
                self.playerView.displayView.doubleTapGesture.isEnabled = false
                self.playerView.displayView.singleTapGesture.isEnabled = false
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player.bounds.width/4, y: -self.player.bounds.height/4))
                self.player.transform = trasform
                self.playerView.displayView.panGesture.isEnabled = false
            })
        default: break
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
        detailVC = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        commentVC = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "commentViewController") as! CommentViewController
        relatedVC = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(withIdentifier: "relatedViewController") as! RelatedViewController
        detailVC.delegate = self
        self.player.addSubview(self.playerView.displayView)
        self.playerView.backgroundMode = .proceed
        self.playerView.delegate = self
        self.playerView.displayView.delegate = self
        self.playerView.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.player.snp.top)
            make.left.equalTo(strongSelf.player.snp.left)
            make.right.equalTo(strongSelf.player.snp.right)
            make.height.equalTo(strongSelf.player.snp.height)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addCarbonKit() {
        let items = ["Details", "Comments", "Suggested"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setNormalColor(UIColor.lightText, font: UIFont(name: "Roboto-Regular", size: 16)!)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont(name: "Roboto-Regular", size: 17)!)
        carbonTabSwipeNavigation.toolbar.isTranslucent = true
        carbonTabSwipeNavigation.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .top, barMetrics: .default)
        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.black
        carbonTabSwipeNavigation.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        carbonTabSwipeNavigation.toolbar.backgroundColor = UIColor.flatBlackColorDark()
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        carbonTabSwipeNavigation.setTabExtraWidth(0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.bounds.width / 3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.bounds.width / 3, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.bounds.width / 3, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl?.tintColor = UIColor.clear
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appdelegate.window?.rootViewController
        carbonTabSwipeNavigation.insert(intoRootViewController: viewController!, andTargetView: infoView)
    }
}

extension PlayerView: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            return detailVC
        }
        
        if index == 1 {
            return commentVC
        }
        
        if index == 2 {
            return relatedVC
        }
        return UIViewController()
    }
}

extension PlayerView: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension PlayerView: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.state = .minimized
            self.delegate?.didMinimize()
            self.animate()
        }
        
    }
    
    func vgPlayerView(didTappedSetting playerView: VGPlayerView) {
        if self.currentStreamList != nil {
            SGActionView.shared().style = SGActionViewStyle.dark
            var listTitles: [String] = []
            for item in self.currentStreamList! {
                listTitles.append(item["quality"] as! String)
            }
            SGActionView.showSheet(withTitle: "Quality?", itemTitles: listTitles, selectedIndex: selectedQualityIndex) { (index) in
                self.selectedQualityIndex = index
                let dataToPass = ["url": self.currentStreamList![index]["url"]!, "title": self.currentVideo!.snippet!.title!, "channelTitle": self.currentVideo!.snippet!.channelTitle!, "image": self.currentVideo!.snippet!.thumbnails!.medium!.url!]
                //self.playerView.replaceVideo(url)
                self.playerView.replaceVideoData(dataToPass as! [String : String])
                VGPlayerCacheManager.shared.cleanAllCache()
                self.playerView.play()
            }
        }
    }
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
    
    func vgPlayerView(pan playerView: VGPlayerView, sender: UIPanGestureRecognizer) {
        if playerView.isFullScreen {
            //playerView.exitFullscreen()
        } else {
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            //print(sender.translation(in: nil).y)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            state = .minimized
        }
    }
}

extension PlayerView: DetailViewControllerDelegate {
    func onChannelTap(viewController: UIViewController, channelID: String) {
        self.state = .minimized
        self.delegate?.didMinimize(withChannelID: channelID)
        animate()
    }
}

enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}
enum Direction {
    case up
    case left
    case none
}

