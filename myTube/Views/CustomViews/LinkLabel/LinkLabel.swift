//
//  LinkLabel.swift
//  myTube
//
//  Created by Quyen Dang on 10/3/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
public typealias LinkSelection = (URL) -> Void

public protocol LinkLabelDelegate: NSObjectProtocol {
    func linkAttributeForLinkLabel(linkLabel: LinkLabel, checkingType: NSTextCheckingResult.CheckingType) -> [String: Any]
    func linkDefaultAttributeForCustomeLink(linkLabel: LinkLabel) -> [String: Any]
    func linkLabelExecuteLink(linkLabel: LinkLabel, text: String, result: NSTextCheckingResult) -> Void
    func linkLabelCheckingLinkType() -> NSTextCheckingTypes
}

public extension LinkLabelDelegate {
    func linkLabelExecuteLink(linkLabel: LinkLabel, text: String, result: NSTextCheckingResult) -> Void {
        
        if result.resultType.contains(.link) {
            
            let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
            if NSPredicate(format: "SELF MATCHES '\(pattern)'").evaluate(with: text) {
                UIApplication.shared.open(URL(string: "mailto:" + text)!)
                return
            }
            
            let httpText = !text.hasPrefix("http://") && !text.hasPrefix("https://") ? "http://" + text : text
            
            guard let url = URL(string: httpText) else { return }
            UIApplication.shared.open(url)
            
        }
        else if result.resultType.contains(.phoneNumber) {
            let telURLString = "tel:" + text
            UIApplication.shared.open(URL(string: telURLString)!)
        }
    }
    
    func linkAttributeForLinkLabel(linkLabel: LinkLabel, checkingType: NSTextCheckingResult.CheckingType) -> [String: Any] {
        return [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.flatRedColorDark(),
            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue
        ]
    }
    
    func linkDefaultAttributeForCustomeLink(linkLabel: LinkLabel) -> [String: Any] {
        return [
            NSAttributedStringKey.foregroundColor.rawValue: linkLabel.tintColor,
            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue
        ]
    }
    
    func linkLabelCheckingLinkType() -> NSTextCheckingTypes {
        return NSTextCheckingResult.CheckingType.link.rawValue
            | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
    }
}



public class LinkLabel: UILabel {
    public weak var delegate: LinkLabelDelegate?
    
    // MARK: - Private
    
    private class DelegateObject: NSObject, LinkLabelDelegate {}
    
    private struct CustomLink {
        let url: URL
        let range: NSRange
        let linkAttribute: [String: Any]
        let selection: LinkSelection?
    }
    
    private var textStorage: NSTextStorage?
    private let layoutManager = NSLayoutManager()
    private var textView: UITextView?
    private var lastCheckingResults = [NSTextCheckingResult]()
    private var customLinks = [CustomLink]()
    private let dummyDelegate = DelegateObject()

    
    public override var text: String? {
        didSet {
            
            guard let str = text else {
                super.attributedText = nil
                self.customLinks.removeAll()
                return
            }
            let mAttributedString = NSMutableAttributedString(string: str)
            if let text = self.text {
                if text.characters.count > 0 {
                    mAttributedString.addAttribute(
                        NSAttributedStringKey.font,
                        value: self.font,
                        range: NSMakeRange(0, text.characters.count)
                    )
                }
            }
            
            super.text = nil
            self.attributedText = mAttributedString
        }
    }
    
    public override var attributedText: NSAttributedString! {
        didSet {
            self.customLinks.removeAll()
            self.reloadAttributedString()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self.dummyDelegate
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self.dummyDelegate
    }
    
    public func addLink(url: URL, range: NSRange, linkAttribute: [String: AnyObject]? = nil, selection: LinkSelection?) -> LinkLabel {
        self.customLinks.append(
            CustomLink(
                url: url,
                range: range,
                linkAttribute: linkAttribute ?? self.delegate?.linkDefaultAttributeForCustomeLink(linkLabel: self) ?? [String: Any](),
                selection: selection
            )
        )
        self.reloadAttributedString()
        return self
    }
    
    public func removeLink(url: URL, range: NSRange) -> LinkLabel {
        self.customLinks = self.customLinks.filter{!($0.url.path == url.path && $0.range.location == range.location && $0.range.length == range.length)}
        self.reloadAttributedString()
        return self
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard let textContainer = self.textView?.textContainer else { return }
        
        self.textView?.textContainer.size = self.textView!.frame.size
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        self.searchCustomeLink(index: index, inCustomeLinks: self.customLinks) { (linkOrNil) -> Void in
            
            if let link = linkOrNil {
                let mAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
                mAttributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor(white: 0.0, alpha: 0.1), range: link.range)
                super.attributedText = mAttributedString
                return
            }
            
            self.searchResult(index: index, inResults: self.lastCheckingResults) { (resultOrNil) -> Void in
                
                guard let result = resultOrNil else { return }
                
                let mAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
                mAttributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor(white: 0.0, alpha: 0.1), range: result.range)
                super.attributedText = mAttributedString
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard let textContainer = self.textView?.textContainer else { return }
        
        self.textView?.textContainer.size = self.textView!.frame.size
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        self.searchCustomeLink(index: index, inCustomeLinks: self.customLinks) { (linkOrNil) -> Void in
            if let link = linkOrNil {
                link.selection?(link.url)
                return
            }
            
            self.searchResult(index: index, inResults: self.lastCheckingResults) { (resultOrNil) -> Void in
                
                guard let result = resultOrNil else {
                    return
                }
                
                self.delegate?.linkLabelExecuteLink(
                    linkLabel: self,
                    text: (self.attributedText!.string as NSString).substring(with: result.range),
                    result: result
                )
            }
        }
        
        // NSAttributedStrings range length is NSStrings lenhgth. I can't use "Swift.String.charactors.count".
        let count = ((self.attributedText?.string ?? "") as NSString).length
        
        if count > 0 {
            let mAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
            mAttributedString.removeAttribute(NSAttributedStringKey.backgroundColor, range: NSMakeRange(0, count))
            super.attributedText = mAttributedString
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let count = self.attributedText?.string.characters.count {
            if count > 0 {
                let mAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
                mAttributedString.removeAttribute(NSAttributedStringKey.backgroundColor, range: NSMakeRange(0, count))
                super.attributedText = mAttributedString
            }
        }
    }
    
    ///
    
    private func reloadAttributedString() {
        self.lastCheckingResults = self.searchLink(string: attributedText?.string ?? "")
        
        let a = self.makeAttrbutedStringForCheckingResults(
            checkingResults: self.lastCheckingResults,
            attributedStringOrNil: self.mekeAttributeStringForCustomLink(
                customLinks: self.customLinks,
                attributedStringOrNil: self.attributedText
            )
        )
        
        super.attributedText = a
        
        self.textStorage?.removeLayoutManager(self.layoutManager)
        if let attributedString = self.attributedText {
            let ma = NSMutableAttributedString(attributedString: attributedString)
            
            ma.addAttribute(NSAttributedStringKey.font, value: self.font, range: NSMakeRange(0, (ma.string as NSString).length))
            self.textStorage = NSTextStorage(attributedString: ma)
        }
        else {
            self.textStorage = nil
        }
        self.textStorage?.addLayoutManager(self.layoutManager)
        
        self.textView = self.makeTextView()
        self.layoutManager.addTextContainer(self.textView!.textContainer)
    }
    
    private func searchLink(string: String) -> [NSTextCheckingResult] {
        
        guard let linkType = self.delegate?.linkLabelCheckingLinkType() else { return [] }
        guard let dataDetector = try? NSDataDetector(types: linkType) else { return [] }
        
        return dataDetector.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (string as NSString).length))
    }
    
    private func searchResult(index: Int, inResults: [NSTextCheckingResult], completion: (NSTextCheckingResult?) -> Void) {
        for result in inResults {
            if result.range.location <= index && result.range.location + result.range.length > index {
                completion(result)
                return
            }
        }
        completion(nil)
    }
    
    private func searchCustomeLink(index: Int, inCustomeLinks: [CustomLink], completion: (CustomLink?) -> Void) {
        for result in inCustomeLinks {
            if result.range.location <= index && result.range.location + result.range.length > index {
                completion(result)
                return
            }
        }
        completion(nil)
    }
    
    private func mekeAttributeStringForCustomLink(customLinks: [LinkLabel.CustomLink], attributedStringOrNil: NSAttributedString?) -> NSAttributedString? {
        
        return self.mekeAttributeStringA(attributedStringOrNil: attributedStringOrNil, objects: customLinks, f: {(customLink) -> ([String: Any], NSRange) in
            let data = (customLink.linkAttribute, customLink.range )
            return data
        })
    }
    
    private func makeAttrbutedStringForCheckingResults(checkingResults: [NSTextCheckingResult], attributedStringOrNil: NSAttributedString?) -> NSAttributedString? {
        
        return self.mekeAttributeStringA(attributedStringOrNil: attributedStringOrNil, objects: checkingResults, f: {(result) -> ([String: Any], NSRange) in
            return (
                self.delegate?.linkAttributeForLinkLabel(
                    linkLabel: self,
                    checkingType: result.resultType
                    ) ?? [String: Any](),
                result.range
            )
        })
    }
    
    private func mekeAttributeStringA<T>(attributedStringOrNil: NSAttributedString?, objects: [T], f: (T) -> ([String: Any], NSRange)) -> NSAttributedString? {
        
        guard let attributedString = attributedStringOrNil else { return nil }
        guard let first = objects.first else { return attributedString }
        
        let mAttributeString = NSMutableAttributedString(attributedString: attributedString)
        let t = f(first)
        mAttributeString.addAttributes([NSAttributedStringKey(t.0.keys.first as! String): t.0.values.first as Any], range: t.1)
        
        return self.mekeAttributeStringA(
            attributedStringOrNil: mAttributeString,
            objects: {() -> [T] in
                var cr = objects
                cr.removeFirst()
                return cr
        }(),
            f: f
        )
    }
    
    private func makeTextView() -> UITextView {
        let textView = self.textView ?? UITextView(frame: self.bounds, textContainer: NSTextContainer(size: self.frame.size))
        textView.isEditable = true
        textView.isSelectable = true
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textView.font = self.font
        textView.textContainer.lineBreakMode = self.lineBreakMode
        textView.textContainer.lineFragmentPadding = 0.0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isUserInteractionEnabled = false
        textView.isHidden = true
        self.addSubview(textView)
        return textView
    }
}
