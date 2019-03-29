//
//  GlobalValues.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/21/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

var ChatsroomsReload = "ChatroomReload"

var androidPackageVersion = 0
var iOSPackageVersion = 0

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
