//
//  Double+Extension.swift
//  LFBR.SwiftLib
//
//  Created by Luis Fernando Bustos Ramírez on 3/19/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Double_Extension: NSObject {

}
extension Double {
    
    /// Return string representation with custom decimals and decimal separator
    ///
    /// - Parameters:
    ///   - fractionDigits: number of digits after dot
    ///   - customDecimalSeparator: custom decimal separator, by default is dot ('.')
    /// - Returns: String representation
    func formatWithFractionDigits(_ fractionDigits: Int, customDecimalSeparator: String? = ".") -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = fractionDigits
        fmt.minimumFractionDigits = fractionDigits
        fmt.decimalSeparator = customDecimalSeparator ?? fmt.decimalSeparator
        
        return  fmt.string(from: NSNumber(value: self)) ?? ""
    }
}
