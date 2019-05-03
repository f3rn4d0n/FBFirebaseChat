//
//  Structs.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 24/01/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit
import CodableFirebase

public struct UserFirebase: Codable{
    public var key = ""
    public var display_title = ""
    public var name = ""
    public var dir = ""
    public var mail = ""
    public var phone = ""
    public var typeProfile = 0
    public var validarUsuario = 0
    public var pushNotificationKey = ""
    public var photoUrl = ""
    public var lastLogin = 0
    public var webPushNotificationKey = ""
}

public struct Chatroom: Codable{
    var lastMessage = ""
    var photo = ""
    var timeStamp = 0
    var title = ""
    var owner = ""
    var key = ""
    var newContent = false
    var dateSeen = 0
}

struct Message: Codable{
    var message = ""
    var imageURL = ""
    var userName = ""
    var userUID = ""
    var timeStamp = 0
    var key = ""
    var messageType = 0
    var quotationID = ""
    var recordingTime = 0
    var mensajeContestadoContenido = ""
    var mensajeContestadoId = ""
    var deleted = false
}

struct ChatroomMember{
    var key = ""
    var members = NSArray()
}

struct Review: Codable{
    var key = ""
    var reviewer = ""
    var ranking = 0
    var comments = ""
    var title = ""
    var timeStamp = 0
}

struct Product: Codable{
    var key = ""
    var name = ""
    var detail = ""
    var imageURL = ""
    var price = 0.0
    var storage = 0
    var active = 1
}

struct FirebaseFile: Codable{
    var name = ""
    var dir = ""
    var owner = ""
    var key = ""
}

struct QuotationsMembers: Codable{
    var key = ""
    var created = ""
    var received = ""
}

struct Refered: Codable{
    var key = ""
    var refered = ""
    var status = 3
}

struct Invitation{
    var chatId = ""
    var dayLeft = 0
    var ownerType = 0
    var timeStamp = 0
    var owner = ""
    var selectedCountries = NSArray()
    var title = "" //Valor util para la busqueda del chat
}

struct Action: Codable{
    var key = ""
    var name = ""
    var actionId = 0
}

struct CustomsURL: Codable{
    var urlImages = ""
    var urlapp = ""
}
