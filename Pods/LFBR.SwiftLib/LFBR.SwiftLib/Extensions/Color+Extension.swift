//
//  Color+Extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Color_Extension: NSObject {

}

public extension UIColor {
    
    /// UIColor by red, green and blue values in interval to 0 to 255 representation
    ///
    /// - Parameters:
    ///   - red: representation beetween 0 to 255
    ///   - green: representation beetween 0 to 255
    ///   - blue: representation beetween 0 to 255
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// UIColor by RGB formtar
    ///
    /// - Parameter rgb: RGB color with hex representation
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    /// Let create a random UIColor with custom alpha
    ///
    /// - Returns: Random UIColor
    public static func random(alphaValue:CGFloat? = 1.0) -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: alphaValue!)
    }
}
