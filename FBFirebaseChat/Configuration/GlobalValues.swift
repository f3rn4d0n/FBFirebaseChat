//
//  GlobalValues.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/21/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

var ChatsroomsReload = "ChatroomReload"

final class GlobalValues: NSObject {
    static let sharedInstance = GlobalValues()
    var chatToContactID = ""
    var chatToContactIDPush = ""
    var invitationReceivedID = ""
    var quotationReceivedID = ""
    var forumReceivedID = ""
    var linkReceived = ""
    var currentChat = ""
    var currentForum = ""
    let compressionQuoality = CGFloat(0.3)
    
    var chatFromURL = ""
    var foroFromURL = ""
    var contactFromURL = ""
    var customURLS = CustomsURL()
    
    
    
    private override init() {super.init()}
}

struct WrappedBundleImage: _ExpressibleByImageLiteral {
    var image: UIImage?
    
    init(imageLiteralResourceName name: String) {
        image = UIImage(named: name, in: Bundle.main, compatibleWith: nil)
        if image == nil{
            print("Image not found \(name)")
//            self.image = UIImage(named: name, in: Bundle.main, compatibleWith: nil)
            
            let bundle = Bundle.init(identifier: "com.gastandoTenis.FBFirebaseChat")
            self.image = UIImage(named: name, in: bundle, compatibleWith: nil)
        }
    }
}

extension UIImage {
    static func fromWrappedBundleImage(_ wrappedImage: WrappedBundleImage) -> UIImage? {
        return wrappedImage.image
    }
}
