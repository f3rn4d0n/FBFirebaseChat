//
//  Float+extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Float_extension: NSObject {

}

public extension Float {
    
    /// Return string representation with custom decimals and decimal separator
    ///
    /// - Parameters:
    ///   - fractionDigits: number of digits after dot
    ///   - customDecimalSeparator: custom decimal separator, by default is dot ('.')
    /// - Returns: String representation
    func formatWithFractionDigits(_ fractionDigits: Int, customDecimalSeparator: String? = nil) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = fractionDigits
        fmt.minimumFractionDigits = fractionDigits
        fmt.decimalSeparator = customDecimalSeparator ?? fmt.decimalSeparator
        
        return  fmt.string(from: NSNumber(value: self)) ?? ""
    }
}

public extension CGFloat {
    /// Create random CGFloat
    ///
    /// - Returns: random value
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
