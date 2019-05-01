//
//  FBChatConfiguration.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/17/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

public class FBChatConfiguration: NSObject {
    var chatlistTitle:String = "Chats"
    
    var GrayAlpha:UIColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.7)
    let mainColor = UIColor.init(red: 246/255, green: 146/255, blue: 30/255, alpha: 1)
    let secondaryColor = UIColor.init(red: 190/255, green: 30/255, blue: 45/255, alpha: 1)
    let backGroundColor = UIColor.init(rgb: 0xEEEEEE)
    
    var animationLoadSelected: NVActivityIndicatorType = .ballRotate
    
    
    public func startConfiguration(){
        
        var options:FirebaseOptions!
        options = FirebaseOptions.init(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)
        FirebaseApp.configure(options: options)
    }
}
