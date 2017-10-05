//
//  AlertViewController.swift
//  myTube
//
//  Created by Quyen Dang on 10/1/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import PickerView

protocol AlertViewControllerDelegate {
    func onCategorySelectedItem(index: Int)
}


class AlertViewController: UIViewController {
    @IBOutlet weak var speView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate: AlertViewControllerDelegate?
    var listCategorysTitle = ["All"]
    enum PresentationType {
        case numbers(Int, Int), names(Int, Int) // NOTE: (Int, Int) represent the rawValue's of PickerView style enums.
    }
    
    @IBOutlet weak var myPicker: PickerView!
    var currentSelectedIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePicker()
        self.getCateGory()
    }
    
    func getCateGory() {
        if Client.shared.categoryList.count == 0 {
            Client.shared.getAllCategoriesByRegion(region: "VN", language: "en", complete: { (response) in
                self.listCategorysTitle.append(contentsOf: Client.shared.categoryList.map { (category: Categories) -> String in
                    (category.snippet?.title!)!
                })
                self.myPicker.reloadPickerView()
            })
        } else {
            self.listCategorysTitle.append(contentsOf: Client.shared.categoryList.map { (category: Categories) -> String in
                (category.snippet?.title!)!
            })
            self.myPicker.reloadPickerView()
        }
        
        
    }
    
    fileprivate func configurePicker() {
        myPicker.dataSource = self
        myPicker.delegate = self
        myPicker.scrollingStyle = .default
        myPicker.selectionStyle = .none
        myPicker.currentSelectedRow = currentSelectedIndex
    }
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AlertViewController: PickerViewDataSource{
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return listCategorysTitle.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        return listCategorysTitle[index]
    }
}

extension AlertViewController: PickerViewDelegate{
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 50.0
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        
    }
    
    func pickerView(_ pickerView: PickerView, didTapRow row: Int, index: Int) {
        self.delegate?.onCategorySelectedItem(index: index)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            if (highlighted) {
                label.font = UIFont.systemFont(ofSize: 26.0, weight: UIFont.Weight.light)
            } else {
                label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.light)
            }
        } else {
            if (highlighted) {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
            } else {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 26.0)
            }
        }
        
        if (highlighted) {
            label.textColor = UIColor.flatRedColorDark()
        } else {
            label.textColor = UIColor.flatGrayColorDark()
        }
    }
    
}
