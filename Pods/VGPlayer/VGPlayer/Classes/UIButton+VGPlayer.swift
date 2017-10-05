//
//  UIButton+VGPlayer.swift
//  VGPlayer
//
//  Created by Vein on 2017/6/12.
//  Copyright © 2017年 Vein. All rights reserved.
//  https://stackoverflow.com/questions/808503/uibutton-making-the-hit-area-larger-than-the-default-hit-area/13977921

import Foundation

fileprivate let minimumHitArea = CGSize(width: 50, height: 50)

extension UIButton {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
    
}

extension UIColor{
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        //        if ((cString.characters.count) != 6) {
        //            return UIColor.gray
        //        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

open class QQ: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configProgressView()
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: self.frame.width, height: 50)
//    }
    func configProgressView() {
        self.progressViewStyle = .bar
        self.progressTintColor = UIColor(hex: "#992b23")
        self.trackTintColor = UIColor(hex: "#BF382A")
    }
}
