//
//  CommonExtension.swift
//  IsApp
//
//  Created by BrightRootsMohini on 3/17/20.
//  Copyright © 2020 BrightRootsMohini. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
}

extension UIButton{
    func adjustFont(){
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

extension UILabel {
    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }
        let textSize: CGSize = self.frame.size
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: gradientImage)
        return true
    }
    
    func setGradient() {
        if self.applyGradientWith(startColor: .yellow, endColor: .lightGray) {
            print("Gradient applied!")
        }
        else {
            print("Could not apply gradient")
            self.textColor = .yellow
        }
    }
}


extension UIViewController{
    func showAlert(_ withMessage : String,_ withTitle : String)  {
        let aC = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "OK", style: .default) { (clicked) in
            aC.dismiss(animated: true, completion: nil)
        }
        aC.addAction(cancelBtn)
        self.present(aC, animated: true, completion: nil)
    }
    
    func showCustomAlert(_ withTitle : String,_ withTitleButton : String,_ buttonStyle : UIAlertAction.Style,_ action : @escaping() -> Void)  {
        let aC = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "Cancel", style: .default) { (clicked) in
            aC.dismiss(animated: true, completion: nil)
        }
        let actionButton = UIAlertAction(title: withTitleButton, style: buttonStyle) { (clicked) in
            action()
        }
        aC.addAction(cancelBtn)
        aC.addAction(actionButton)
        self.present(aC, animated: true, completion: nil)
    }
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    func getLocationFromPostalCode(postalCode : String,completion : @escaping(_ : CLLocationCoordinate2D?, _ : String?) -> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(postalCode) {
            (placemarks, error) -> Void in
            if let placemark = placemarks?[0] {
                if placemark.postalCode == postalCode{
                    //    print("\(placemark.location?.coordinate)")
                    let addressString  = [placemark.locality,
                                          placemark.subLocality,
                                          placemark.thoroughfare,
                                          placemark.postalCode,
                                          placemark.subThoroughfare,
                                          placemark.country].compactMap{$0}.joined(separator: ", ")
                    
                    completion(placemark.location?.coordinate, addressString)
                }
                else{
                    print("Please enter valid zipcode")
                    completion(nil,nil)
                }
            }else{
                completion(nil,nil)
            }
        }
    }
    
    
}
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: false)
        }
    }
}

extension UITextField{
    func setRightViewButton() {
        self.isSecureTextEntry = true
        let button = UIButton(frame: CGRect(x: self.frame.size.width - 35, y: 0, width: 25, height: self.frame.size.height))
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: -10, bottom: 15, right: 15)
        button.setImage(UIImage(named: "eyeclose"), for: .normal)
        button.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @objc func btnAction(sender : UIButton){
        self.isSecureTextEntry =  !self.isSecureTextEntry
        sender.setImage(self.isSecureTextEntry ? UIImage(named: "eyeclose") : UIImage(named: "eye"), for: .normal)
    }
    func removeRightView() {
        self.isSecureTextEntry = false
        self.rightView = nil
        self.rightViewMode = .never
    }
    func removeLeftView() {
        self.leftView = nil
        self.leftViewMode = .never
    }
}



extension UIImageView{
    func makeBlurImage(_ targetImageView:UIImageView?){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
}



extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
    
    
}

extension Sequence where Iterator.Element: Hashable {
    func getUnique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
    
    
    
    func toGermanString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "de_DE")
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: self)
    }
    func toServerString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    func toTimeServerString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "de_DE")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
                       }, completion: nil)
        self.isHidden = false
    }
    
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
                       },  completion: {(_ completed: Bool) -> Void in
                        self.isHidden = true
                       })
    }
}




extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d",hours,minutes)
        
    }
}
extension String{
    func dateFormatter() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = UserStoreSingleton.shared.is24HourFormat ?? true ? "dd MMM yyyy,EEEE | HH:mm" : "dd MMM yyyy,EEEE | h:mm a"
        dateFormatter.timeZone = TimeZone.current
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let _date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = UserStoreSingleton.shared.is24HourFormat ?? true ? "dd MMM yyyy,EEEE | HH:mm" : "dd MMM yyyy,EEEE | h:mm a"
            return dateFormatter.string(from: _date!)
        }else{
            let timeStamp = dateFormatter.string(from: date!)
            print(timeStamp)
            return timeStamp
        }
    }
    
    func changeFormatforJobdate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UserStoreSingleton.shared.is24HourFormat ?? true ? "yyyy-MM-dd HH:mm" : "yyyy-MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}
extension Numeric where Self: LosslessStringConvertible {
    var digits: [Int] { string.digits }
}
extension String{
    func convertToDate(_ withSecond : Bool) -> Date {
        let dF = DateFormatter()
        if UserStoreSingleton.shared.is24HourFormat ?? true{
            dF.dateFormat = withSecond ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm"
        }else{
            dF.dateFormat = withSecond ? "yyyy-MM-dd h:mm:ss a" : "yyyy-MM-dd h:mm a"
        }
        dF.timeZone = .current
        return dF.date(from: self) ?? Date()
    }
}

extension Dictionary where Value : Equatable {
    func allKeysForValue(val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}


extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector,withmode : UIDatePicker.Mode) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = withmode
        if withmode == .date{
            datePicker.minimumDate = Date()
        }
        self.inputView = datePicker //3
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
