//
//  String+Extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class String_Extension: NSObject {

}

let __numberRegex = "^[0-9]\\d*(\\.\\d+)?$"
let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
public let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
public let __numberPredicate = NSPredicate(format: "SELF MATCHES %@", __numberRegex)

public extension String {
    
    /// String representation by urlQueryAllowed
    ///
    /// - Returns: string representation validated to url encode
    func encodeUrl() -> String?{
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    /// Decode url to get friendly string
    ///
    /// - Returns: string decoded
    func decodeUrl() -> String?{
        return self.removingPercentEncoding
    }
    
    /// Check if your current string can be used like URL
    ///
    /// - Returns: Validate if current string is URL
    func isURL () -> Bool {
        if let url = NSURL(string: self) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    /// Check if your current string can be used like email
    ///
    /// - Returns: Validate if your string is an email
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
    
    /// Check if your current string can be used like number
    ///
    /// - Returns: Validate if your string is a number
    func isNumber() -> Bool{
        return __numberPredicate.evaluate(with: self)
    }
    
    /// Transform your current string to Float with 2 decimals, if your string doesn't have valid format then your response will be 0
    ///
    /// - Returns: Float representation
    func toFloat(_ localeIdentifier: String? = nil) -> Float {
        let locale = localeIdentifier != nil ?  Locale(identifier: localeIdentifier!) : Locale.current
        
        let fmt = NumberFormatter()
        fmt.locale = locale
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = 2
        fmt.roundingMode = .down
        
        return fmt.number(from: self)?.floatValue ?? 0
    }
    
    /// Integer reprentation of your current string, if your string doesn't have valid format then your response will be 0
    var int : Int {
        if self.isNumber() {
            return Int(self.split(separator: ".")[0]) ?? 0
        } else {
            return 0
        }
    }
    
    
    /// Transform your current string to NSAttributedString, changing numbers to NumberFormatter
    ///
    /// - Returns: NSAttributedString with number formatter
    func sliderAttributeString() -> NSAttributedString {
        guard self != "" else { return NSAttributedString(string: "") }
        
        let locale = Locale.current
        let fmt = NumberFormatter()
        fmt.locale = locale
        
        let numberComponents = components(separatedBy: fmt.decimalSeparator)
        
        let attributeString = NSMutableAttributedString()
        var integerStr = numberComponents[0]
        
        var decimalStr = ""
        if numberComponents.count > 1 {
            integerStr += fmt.decimalSeparator
            decimalStr =  numberComponents[1]
        }
        
        let integer = NSMutableAttributedString(string: integerStr)
        let decimal = NSMutableAttributedString(string: decimalStr)
        
        
        attributeString.append(integer)
        attributeString.append(decimal)
        
        return attributeString
    }
    
    
}

public extension NSString{
    /// Transform your current string to NSAttributedString, changing fonts from your seleted array of strings
    ///
    /// - Parameters:
    ///   - boldPartsOfString: Array to strings to need his font changed
    ///   - font: Font for all your string
    ///   - boldFont: Font for your strings selected
    /// - Returns: NSAttributedString with string font changed
    func getdBoldedText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: self.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}
