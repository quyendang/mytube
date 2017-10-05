//
//  VGPlayerView.swift
//  VGPlayer
//
//  Created by Vein on 2017/6/5.
//  Copyright © 2017年 Vein. All rights reserved.
//

import UIKit
import MediaPlayer
import SnapKit

public protocol VGPlayerViewDelegate: class {
    
    /// Fullscreen
    ///
    /// - Parameters:
    ///   - playerView: player view
    ///   - fullscreen: Whether full screen
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen isFullscreen: Bool)
    
    /// Close play view
    ///
    /// - Parameter playerView: player view
    func vgPlayerView(didTappedClose playerView: VGPlayerView)
    
    func vgPlayerView(didTappedSetting playerView: VGPlayerView)
    
    /// Displaye control
    ///
    /// - Parameter playerView: playerView
    func vgPlayerView(didDisplayControl playerView: VGPlayerView)
    
    func vgPlayerView(pan playerView: VGPlayerView, sender: UIPanGestureRecognizer)
}

// MARK: - delegate methods optional
public extension VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool){}
    
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {}
    
    func vgPlayerView(didTappedSetting playerView: VGPlayerView){}
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {}
    func vgPlayerView(pan playerView: VGPlayerView, sender: UIPanGestureRecognizer){}
}

public enum VGPlayerViewPanGestureDirection: Int {
    case vertical
    case horizontal
}


open class VGPlayerView: UIView {
    
    weak open var vgPlayer : VGPlayer?
    open var controlViewDuration : TimeInterval = 5.0  /// default 5.0
    open fileprivate(set) var playerLayer : AVPlayerLayer?
    open fileprivate(set) var isFullScreen : Bool = false
    open fileprivate(set) var isTimeSliding : Bool = false
    open fileprivate(set) var isDisplayControl : Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                delegate?.vgPlayerView(didDisplayControl: self)
            }
        }
    }
    open weak var delegate : VGPlayerViewDelegate?
    // top view
    open var topView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4450924296)
        return view
    }()
    open var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    open var channelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
    }()
    open var closeButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var settingButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    // bottom view
    open var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    open var controlView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    open var timeSlider = QQ()
    open var loadingIndicator = VGPlayerLoadingIndicator()
    open var fullscreenButton : UIButton = UIButton(type: UIButtonType.custom)
    open var timeLabel : UILabel = UILabel()
    open var playButtion : UIButton = UIButton(type: UIButtonType.custom)
    open var volumeSlider : UISlider!
    open var replayButton : UIButton = UIButton(type: UIButtonType.custom)
    
    open fileprivate(set) var panGestureDirection : VGPlayerViewPanGestureDirection = .horizontal
    fileprivate var isVolume : Bool = false
    fileprivate var sliderSeekTimeValue : TimeInterval = .nan
    fileprivate var timer : Timer = {
        let time = Timer()
        return time
    }()
    
    fileprivate weak var parentView : UIView?
    fileprivate var viewFrame = CGRect()
    
    // GestureRecognizer
    open var singleTapGesture = UITapGestureRecognizer()
    open var doubleTapGesture = UITapGestureRecognizer()
    open var panGesture = UIPanGestureRecognizer()
    open var panGesture2 = UIPanGestureRecognizer()
    
    //MARK:- life cycle
    public override init(frame: CGRect) {
        self.playerLayer = AVPlayerLayer(player: nil)
        super.init(frame: frame)
        addDeviceOrientationNotifications()
        addGestureRecognizer()
        configurationVolumeSlider()
        configurationUI()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateDisplayerView(frame: bounds)
    }
    
    open func setvgPlayer(vgPlayer: VGPlayer) {
        self.vgPlayer = vgPlayer
    }
    
    open func reloadPlayerLayer() {
        self.playerLayer = AVPlayerLayer(player: self.vgPlayer?.player)
        self.layer.insertSublayer(self.playerLayer!, at: 0)
        self.updateDisplayerView(frame: self.bounds)
        self.timeSlider.isUserInteractionEnabled = self.vgPlayer?.mediaFormat != .m3u8
        reloadGravity()
    }
    
    
    /// play state did change
    ///
    /// - Parameter state: state
    open func playStateDidChange(_ state: VGPlayerState) {
        self.playButtion.isSelected = state == .playing
        self.replayButton.isHidden = !(state == .playFinished)
        self.replayButton.isHidden = !(state == .playFinished)
        if state == .playing || state == .playFinished {
            setupTimer()
        }
        if state == .playFinished {
            self.loadingIndicator.isHidden = true
        }
    }
    
    /// buffer state change
    ///
    /// - Parameter state: buffer state
    open func bufferStateDidChange(_ state: VGPlayerBufferstate) {
        if state == .buffering {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        var current = formatSecondsToString((self.vgPlayer?.currentDuration)!)
        if (self.vgPlayer?.totalDuration.isNaN)! {  // HLS
            current = "00:00"
        }
        if state == .readyToPlay && !isTimeSliding {
            self.timeLabel.text = "\(current + " / " +  (formatSecondsToString((self.vgPlayer?.totalDuration)!)))"
        }
    }
    
    /// buffer duration
    ///
    /// - Parameters:
    ///   - bufferedDuration: buffer duration
    ///   - totalDuration: total duratiom
    open func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        //print(self.timeSlider.progress)
        //self.timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
        
    }
    
    /// player diration
    ///
    /// - Parameters:
    ///   - currentDuration: current duration
    ///   - totalDuration: total duration
    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {  // HLS
            current = "00:00"
        }
        if !isTimeSliding {
            self.timeLabel.text = "\(current + " / " +  (formatSecondsToString(totalDuration)))"
            //self.timeSlider.value = Float(currentDuration / totalDuration)
            self.timeSlider.setProgress(Float(currentDuration / totalDuration), animated: true)
            //print((self.vgPlayer?.player?.isMuted)! ? "mute": "nomute")
            //print(self.timeSlider.progress)
            //print(Double(currentDuration / totalDuration))
        }
    }
    
}

// MARK: - public
extension VGPlayerView {
    
    open func updateDisplayerView(frame: CGRect) {
        self.playerLayer?.frame = frame
    }
    
    open func reloadPlayerView() {
        self.playerLayer = AVPlayerLayer(player: nil)
        self.timeSlider.setProgress(0, animated: true)
        self.replayButton.isHidden = true
        self.isTimeSliding = false
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.timeLabel.text = "--:-- / --:--"
        reloadPlayerLayer()
    }
    
    open func reloadGravity() {
        if self.vgPlayer != nil {
            switch self.vgPlayer!.gravityMode {
            case .resize:
                self.playerLayer?.videoGravity = "AVLayerVideoGravityResize"
            case .resizeAspect:
                self.playerLayer?.videoGravity = "AVLayerVideoGravityResizeAspect"
            case .resizeAspectFill:
                self.playerLayer?.videoGravity = "AVLayerVideoGravityResizeAspectFill"
            }
        }
    }
    
    /// control view display
    ///
    /// - Parameter display: is display
    open func displayControlView(_ isDisplay:Bool) {
        if isDisplay {
            displayControlAnimation()
        } else {
            hiddenControlAnimation()
        }
    }
    open func enterFullscreen() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait{
            self.parentView = (self.superview)!
            self.viewFrame = self.frame
        }
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .landscapeRight
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    open func exitFullscreen() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .portrait
    }
    
    /// play failed
    ///
    /// - Parameter error: error
    open func playFailed(_ error: VGPlayerError) {
        // error
    }
    
    public func formatSecondsToString(_ secounds: TimeInterval) -> String {
        if secounds.isNaN{
            return "00:00"
        }
        let interval = Int(secounds)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - private
extension VGPlayerView {
    
    internal func play() {
        self.playButtion.isSelected = true
    }
    
    internal func pause() {
        self.playButtion.isSelected = false
    }
    
    internal func displayControlAnimation() {
        self.bottomView.isHidden = false
        self.topView.isHidden = false
         self.panGesture.isEnabled = true
        self.isDisplayControl = true
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
            self.topView.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    internal func hiddenControlAnimation() {
        self.timer.invalidate()
        self.isDisplayControl = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
            self.topView.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
            self.topView.isHidden = true
            self.panGesture.isEnabled = false
        }
    }
    internal func setupTimer() {
        self.timer.invalidate()
        self.timer = Timer.vgPlayer_scheduledTimerWithTimeInterval(self.controlViewDuration, block: {  [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
        }, repeats: false)
    }
    internal func addDeviceOrientationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationWillChange(_:)), name: .UIApplicationWillChangeStatusBarOrientation, object: nil)
    }
    
    internal func configurationVolumeSlider() {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            self.volumeSlider = view
        }
    }
}


// MARK: - GestureRecognizer
extension VGPlayerView {
    
    internal func addGestureRecognizer() {
        self.singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        self.singleTapGesture.numberOfTapsRequired = 1
        self.singleTapGesture.numberOfTouchesRequired = 1
        self.singleTapGesture.delegate = self
        addGestureRecognizer(self.singleTapGesture)
        
        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.doubleTapGesture.numberOfTouchesRequired = 1
        self.doubleTapGesture.delegate = self
        addGestureRecognizer(self.doubleTapGesture)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        self.panGesture.delegate = self
        
        self.panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        self.panGesture2.delegate = self
        //// edit
        addGestureRecognizer(self.panGesture)
        //self.controlView.addGestureRecognizer(self.panGesture2)
        
        self.singleTapGesture.require(toFail: doubleTapGesture)
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension VGPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view as? VGPlayerView != nil) {
            return true
        }
        return false
    }
}

// MARK: - Event
extension VGPlayerView {
    
//    internal func timeSliderValueChanged(_ sender: VGPlayerSlider) {
//        self.isTimeSliding = true
//        if let duration = self.vgPlayer?.totalDuration {
//            let currentTime = Double(sender.value) * duration
//            self.timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
//        }
//    }
//    
//    internal func timeSliderTouchDown(_ sender: VGPlayerSlider) {
//        self.isTimeSliding = true
//        self.timer.invalidate()
//    }
    
//    internal func timeSliderTouchUpInside(_ sender: VGPlayerSlider) {
//        self.isTimeSliding = true
//
//        if let duration = self.vgPlayer?.totalDuration {
//            let currentTime = Double(sender.value) * duration
//            self.vgPlayer?.seekTime(currentTime, completion: { [weak self] (finished) in
//                guard let strongSelf = self else { return }
//                if finished {
//                    strongSelf.isTimeSliding = false
//                    strongSelf.setupTimer()
//                }
//            })
//            self.timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
//        }
//    }
    
    internal func onPlayerButton(_ sender: UIButton) {
        if !sender.isSelected {
            self.vgPlayer?.play()
        } else {
            self.vgPlayer?.pause()
        }
    }
    
    internal func onFullscreen(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isFullScreen = sender.isSelected
        if isFullScreen {
            enterFullscreen()
        } else {
            exitFullscreen()
        }
    }
    
    
    /// Single Tap Event
    ///
    /// - Parameter gesture: Single Tap Gesture
    open func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        self.isDisplayControl = !self.isDisplayControl
        displayControlView(self.isDisplayControl)
    }
    
    /// Double Tap Event
    ///
    /// - Parameter gesture: Double Tap Gesture
    open func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        guard self.vgPlayer == nil else {
            switch self.vgPlayer!.state {
            case .playFinished:
                break
            case .playing:
                self.vgPlayer?.pause()
            case .paused:
                self.vgPlayer?.play()
            case .none:
                break
            case .error:
                break
            }
            return
        }
    }
    
    /// Pan Event
    ///
    /// - Parameter gesture: Pan Gesture
    open func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        switch gesture.state {
        case .began:
            let x = fabs(translation.x)
            let y = fabs(translation.y)
            if x < y {
                self.panGestureDirection = .vertical
//                if location.x > self.bounds.width / 2 {
//                    self.isVolume = true
//                } else {
//                    self.isVolume = false
//                }
            } else if x > y{
                guard vgPlayer?.mediaFormat == .m3u8 else {
                    self.panGestureDirection = .horizontal
                    return
                }
            }
        case .changed:
            switch self.panGestureDirection {
            case .horizontal:
                if self.vgPlayer?.currentDuration == 0 { break }
                self.sliderSeekTimeValue = panGestureHorizontal(velocity.x)
            case .vertical:
                //print(location.y)
                //self.delegate?.vgPlayerView(pan: self, velocityY: location.y)
                //self.delegate?.vgPlayerView(pan: self, sender: gesture)
                //panGestureVertical(velocity.y)
                //gesture.isEnabled = false
                break
            }
        case .ended:
            gesture.isEnabled = true
            switch self.panGestureDirection{
            case .horizontal:
                if sliderSeekTimeValue.isNaN { return }
                self.vgPlayer?.seekTime(self.sliderSeekTimeValue, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    if finished {
                        
                        strongSelf.isTimeSliding = false
                        strongSelf.setupTimer()
                    }
                })
            case .vertical:
               break
                //self.isVolume = false
                
            }
            
        default:
            break
        }
    }
    
    internal func panGestureHorizontal(_ velocityX: CGFloat) -> TimeInterval {
        self.displayControlView(true)
        self.isTimeSliding = true
        self.timer.invalidate()
        let value = self.timeSlider.progress
        if let _ = self.vgPlayer?.currentDuration ,let totalDuration = self.vgPlayer?.totalDuration{
            let sliderValue = (TimeInterval(value) *  totalDuration) + TimeInterval(velocityX) / 100.0 * (TimeInterval(totalDuration) / 400)
            self.timeSlider.setProgress(Float(sliderValue/totalDuration), animated: true)
            return sliderValue
        } else {
            return TimeInterval.nan
        }
        
    }
    
    internal func panGestureVertical(_ sender: UIPanGestureRecognizer) {
        //self.isVolume ? (self.volumeSlider.value -= Float(velocityY / 10000)) : (UIScreen.main.brightness -= velocityY / 10000)
        delegate?.vgPlayerView(pan: self, sender: sender)
    }

    internal func onCloseView(_ sender: UIButton) {
        delegate?.vgPlayerView(didTappedClose: self)
    }
    
    internal func onSetting(_ sender: UIButton) {
        //delegate?.vgPlayerView(didTappedClose: self)
        delegate?.vgPlayerView(didTappedSetting: self)
    }
    
    internal func onReplay(_ sender: UIButton) {
        self.vgPlayer?.replaceVideo((self.vgPlayer?.contentURL)!)
        self.vgPlayer?.play()
    }
    
    internal func deviceOrientationWillChange(_ sender: Notification) {
        let orientation = UIDevice.current.orientation
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait{
            if self.superview != nil {
                self.parentView = (self.superview)!
                self.viewFrame = self.frame
            }
        }
        switch orientation {
        case .unknown:
            break
        case .faceDown:
            break
        case .faceUp:
            break
        case .landscapeLeft:
            onDeviceOrientation(true, orientation: .landscapeLeft)
        case .landscapeRight:
            onDeviceOrientation(true, orientation: .landscapeRight)
        case .portrait:
            onDeviceOrientation(false, orientation: .portrait)
        case .portraitUpsideDown:
            onDeviceOrientation(false, orientation: .portraitUpsideDown)
        }
    }
    internal func onDeviceOrientation(_ fullScreen: Bool, orientation: UIInterfaceOrientation) {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if orientation == statusBarOrientation {
            if orientation == .landscapeLeft || orientation == .landscapeLeft {
                let rectInWindow = self.convert(self.bounds, to: UIApplication.shared.keyWindow)
                self.removeFromSuperview()
                self.frame = rectInWindow
                UIApplication.shared.keyWindow?.addSubview(self)
                self.snp.remakeConstraints({ [weak self] (make) in
                    guard let strongSelf = self else { return }
                    make.width.equalTo(strongSelf.superview!.bounds.width)
                    make.height.equalTo(strongSelf.superview!.bounds.height)
                })
            }
        } else {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                let rectInWindow = self.convert(self.bounds, to: UIApplication.shared.keyWindow)
                self.removeFromSuperview()
                self.frame = rectInWindow
                UIApplication.shared.keyWindow?.addSubview(self)
                self.snp.remakeConstraints({ [weak self] (make) in
                    guard let strongSelf = self else { return }
                    make.width.equalTo(strongSelf.superview!.bounds.height)
                    make.height.equalTo(strongSelf.superview!.bounds.width)
                })
            } else if orientation == .portrait{
                if self.parentView == nil { return }
                self.removeFromSuperview()
                self.parentView!.addSubview(self)
                let frame = self.parentView!.convert(self.viewFrame, to: UIApplication.shared.keyWindow)
                self.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(self.viewFrame.midX)
                    make.centerY.equalTo(self.viewFrame.midY)
                    make.width.equalTo(frame.width)
                    make.height.equalTo(frame.height)
                })
                self.viewFrame = CGRect()
                self.parentView = nil
            }
        }
        self.isFullScreen = fullScreen
        self.fullscreenButton.isSelected = fullScreen
        delegate?.vgPlayerView(self, willFullscreen: self.isFullScreen)
    }
}

//MARK: - UI autoLayout
extension VGPlayerView {
    
    open func configurationUI() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        configurationTopView()
        configurationBottomView()
        configurationReplayButton()
        setupViewAutoLayout()
    }
    
    internal func configurationReplayButton() {
        addSubview(self.replayButton)
        let replayImage = VGPlayerUtils.imageResource("player_reload")
        self.replayButton.setImage(VGPlayerUtils.imageSize(image: replayImage!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        self.replayButton.addTarget(self, action: #selector(onReplay(_:)), for: .touchUpInside)
        self.replayButton.isHidden = true
    }
    
    internal func configurationTopView() {
        addSubview(self.topView)
        self.titleLabel.text = "this is a title."
        self.channelLabel.text = "this is channel name"
        self.topView.addSubview(self.titleLabel)
        self.topView.addSubview(self.channelLabel)
        let closeImage = VGPlayerUtils.imageResource("player_expand")
        self.closeButton.setImage(VGPlayerUtils.imageSize(image: closeImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        self.closeButton.tintColor = UIColor(hex: "#BF382A")
        self.closeButton.addTarget(self, action: #selector(onCloseView(_:)), for: .touchUpInside)
        let settingImage = VGPlayerUtils.imageResource("player_setting")
        self.settingButton.setImage(VGPlayerUtils.imageSize(image: settingImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        self.settingButton.tintColor = UIColor(hex: "#BF382A")
        self.settingButton.addTarget(self, action: #selector(onSetting(_:)), for: .touchUpInside)
        self.topView.addSubview(self.closeButton)
        self.topView.addSubview(self.settingButton)
    }
    
    internal func configurationBottomView() {
        addSubview(self.bottomView)
        //self.timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)),
                            // for: .valueChanged)
        //self.timeSlider.addTarget(self, action: #selector(timeSliderTouchUpInside(_:)), for: .touchUpInside)
        //self.timeSlider.addTarget(self, action: #selector(timeSliderTouchDown(_:)), for: .touchDown)
        self.loadingIndicator.lineWidth = 1.0
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        addSubview(self.loadingIndicator)
        
        self.bottomView.addSubview(controlView)
        self.controlView.addSubview(self.timeSlider)
        
        let playImage = VGPlayerUtils.imageResource("player_play")
        let pauseImage = VGPlayerUtils.imageResource("player_pause")
        self.playButtion.setImage(VGPlayerUtils.imageSize(image: playImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        self.playButtion.setImage(VGPlayerUtils.imageSize(image: pauseImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        self.playButtion.tintColor = UIColor.white
        self.playButtion.addTarget(self, action: #selector(onPlayerButton(_:)), for: .touchUpInside)
        self.controlView.addSubview(self.playButtion)
        
        self.timeLabel.textAlignment = .center
        self.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.timeLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.timeLabel.text = "--:-- / --:--"
        self.controlView.addSubview(self.timeLabel)
        
        let enlargeImage = VGPlayerUtils.imageResource("player_full")
        let narrowImage = VGPlayerUtils.imageResource("player_close")
        self.fullscreenButton.setImage(VGPlayerUtils.imageSize(image: enlargeImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        self.fullscreenButton.setImage(VGPlayerUtils.imageSize(image: narrowImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        self.fullscreenButton.addTarget(self, action: #selector(onFullscreen(_:)), for: .touchUpInside)
        self.fullscreenButton.tintColor = UIColor.white
        self.controlView.addSubview(self.fullscreenButton)
        
    }
    
    internal func setupViewAutoLayout() {
        
        
        replayButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        // top view layout
        topView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.top.equalTo(strongSelf)
            make.height.equalTo(64)
        }
        closeButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.topView).offset(10)
            make.top.equalTo(strongSelf.topView).offset(28)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        settingButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.right.equalTo(strongSelf.topView).offset(-10)
            make.top.equalTo(strongSelf.topView).offset(28)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
//            make.left.equalTo(strongSelf.closeButton.snp.right).offset(20)
//            make.centerY.equalTo(strongSelf.closeButton.snp.centerY)
            make.top.equalTo(strongSelf.topView).offset(25)
            make.left.equalTo(strongSelf.closeButton.snp.right).offset(20)
            make.right.equalTo(strongSelf.settingButton.snp.left).offset(-20)
        }
        
        channelLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.closeButton.snp.right).offset(20)
            make.top.equalTo(strongSelf.titleLabel.snp.bottom).offset(0)
            make.right.equalTo(strongSelf.settingButton.snp.left).offset(-20)
        }
        
        // bottom view layout
        bottomView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.bottom.equalTo(strongSelf)
            make.height.equalTo(70)
        }
        
        controlView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.bottomView).offset(50)
            make.right.equalTo(strongSelf.bottomView).offset(-50)
            make.height.equalTo(45)
            make.centerY.equalTo(strongSelf.bottomView)
        }
        
        timeSlider.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.bottom.equalTo(strongSelf.controlView)
            make.right.equalTo(strongSelf.controlView)
            make.left.equalTo(strongSelf.controlView)
            make.top.equalTo(strongSelf.controlView)
        }
        
        
        
        playButtion.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.controlView)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerY.equalTo(strongSelf.controlView)
        }
        
        timeLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.playButtion)
            make.height.equalTo(30)
            make.centerX.equalTo(strongSelf.controlView)
        }
        
        
        fullscreenButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.controlView)
            make.right.equalTo(strongSelf.controlView)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
}
