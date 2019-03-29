//
//  Int+Extension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Int_Extension: NSObject {

}

public extension Int{
    /// Transform current int value to time representation by offset
    ///
    /// - Returns: Date representation
    func getDateByOffset() -> Date{
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
