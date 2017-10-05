//
//  VideoHeaderView.swift
//  myTube
//
//  Created by Quyen Dang on 10/2/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

protocol VideoHeaderViewDelegate {
    func onHeaderViewClick(headerView: UIView)
}

class VideoHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var sView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var RippleView: UIView?
    var delegate: VideoHeaderViewDelegate?
    @IBAction func onNextClick(_ sender: UIButton) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.RippleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.RippleView?.backgroundColor = UIColor(hexString: "BF382A", withAlpha: 0.7)
        self.RippleView?.layer.cornerRadius = self.bounds.size.width
        self.RippleView?.layer.masksToBounds = true
        self.RippleView?.alpha = 0
        self.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)) )
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(gesture)
    }
    
    
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        self.addSubview(self.RippleView!)
        self.RippleView?.center = location
        self.RippleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.RippleView?.alpha = 1
            self.sView.alpha = 1
        }
        switch gestureRecognizer.state {
        case .began:
            let location = gestureRecognizer.location(in: self)
            self.addSubview(self.RippleView!)
            self.RippleView?.center = location
            self.RippleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.4) {
                self.RippleView?.alpha = 1
                self.sView.alpha = 1
            }
        case .ended:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.RippleView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.RippleView?.alpha = 0
                self.sView.alpha = 1
            }) { (finished) in
                self.RippleView?.removeFromSuperview()
                self.delegate?.onHeaderViewClick(headerView: self)
            }
        case .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.RippleView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.RippleView?.alpha = 0
                self.sView.alpha = 1
            }) { (finished) in
                self.RippleView?.removeFromSuperview()
            }
        case .changed:
            break
        default:
            break
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.RippleView?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width * 2, height: self.bounds.size.width * 2)
    }
}
