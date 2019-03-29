//
//  SizesExtension.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 3/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import Foundation

public enum iPhoneDevices {
    case IPHONE_4
    case IPHONE_5
    case IPHONE_6
    case IPHONE_6_PLUS
    case IPHONE_X
    case IPHONE_UNKNOWN
}

public var IPHONE_DEVICE: iPhoneDevices {
    let mainScreenBounds = UIScreen.main.bounds
    if mainScreenBounds.size.height == 480.0 || mainScreenBounds.size.width == 480.0 {
        return .IPHONE_4
    } else if mainScreenBounds.size.height == 568.0 || mainScreenBounds.size.width == 568.0 {
        return .IPHONE_5
    } else if mainScreenBounds.size.height == 667.0 || mainScreenBounds.size.width == 667.0 {
        return .IPHONE_6
    } else if mainScreenBounds.size.height == 736.0 || mainScreenBounds.size.width == 736.0 {
        return .IPHONE_6_PLUS
    } else if mainScreenBounds.size.height == 812.0 || mainScreenBounds.size.width == 812.0 {
        return .IPHONE_X
    }
    return .IPHONE_UNKNOWN
}

//Created to support the sizes validations.
@objc class SizesExtension: NSObject {
    
}

