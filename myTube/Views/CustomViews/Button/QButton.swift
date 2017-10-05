//
//  QButton.swift
//  myTube
//
//  Created by Quyen Dang on 10/3/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit

class QButton: UIButton {
    var RippleView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.RippleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.RippleView?.backgroundColor = UIColor(hexString: "BF382A", withAlpha: 0.7)
        self.RippleView?.layer.cornerRadius = self.bounds.size.width / 2
        self.RippleView?.layer.masksToBounds = true
        self.RippleView?.alpha = 0
        self.clipsToBounds = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.RippleView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.RippleView?.alpha = 0
            self.alpha = 1
        }) { (finished) in
            self.RippleView?.removeFromSuperview()
            super.touchesEnded(touches, with: event)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.RippleView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.RippleView?.alpha = 0
            self.alpha = 1
        }) { (finished) in
            self.RippleView?.removeFromSuperview()
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let location = touch?.location(in: self)
        self.addSubview(self.RippleView!)
        self.RippleView?.center = location!
        self.RippleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.RippleView?.alpha = 1
            self.alpha = 0.1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        let location = touch?.location(in: self)
        self.addSubview(self.RippleView!)
        self.RippleView?.center = location!
        self.RippleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.RippleView?.alpha = 1
            self.alpha = 0.1
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.RippleView?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width , height: self.bounds.size.width)
    }

}
