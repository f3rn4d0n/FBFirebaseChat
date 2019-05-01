//
//  Structs.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 24/01/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit

public struct UserFirebase{
    public var key = ""
    public var type = ""
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
    public var active = false
    public var webPushNotificationKey = ""
}

struct Category{
    var name = ""
    var subcategory = NSArray()
}

public struct Chatroom{
    var lastMessage = ""
    var photo = ""
    var timeStamp = 0
    var title = ""
    var owner = ""
    var key = ""
    var newContent = false
    var dateSeen = 0
}

let chatrooms = [
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0),
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0),
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0),
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0),
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0),
    Chatroom(lastMessage: "Prueba 1", photo: "No hay", timeStamp: 123456, title: "Yo puedo", owner: "Yo mero", key: "dfkjsfkhsvhlkcnkv", newContent: false, dateSeen:0)

]

struct Message{
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

struct Review{
    var key = ""
    var reviewer = ""
    var ranking = 0
    var comments = ""
    var title = ""
    var timeStamp = 0
}

struct Product{
    var key = ""
    var name = ""
    var detail = ""
    var imageURL = ""
    var price = 0.0
    var storage = 0
    var active = 1
}

struct FirebaseFile{
    var name = ""
    var dir = ""
    var owner = ""
    var key = ""
}

struct Interest{
    var category1 = ""
    var brand1 = NSArray()
    var brandTemp1 = ""
    var category2 = ""
    var brand2 = NSArray()
    var brandTemp2 = ""
    var category3 = ""
    var brand3 = NSArray()
    var brandTemp3 = ""
}

struct QuotationsMembers{
    var key = ""
    var created = ""
    var received = ""
}

struct Quotations{
    var key = ""
    var userId = ""
    var senderID = ""
    var receivedID = ""
    var subTotal = 0.0
    var sendCost = 0.0
    var otherCost = 0.0
    var totalCost = 0.0
    var status = 0
    var userToShow = ""
}

struct QuotationProduct{
    var quantity = 0
    var productDescription = ""
    var price = 0.0
    var discount = 0
    var productUID = ""
    var key = ""
}

struct ForumCategory{
    var owner = ""
    var key = ""
}

struct Forum{
    var lastMessage = ""
    var timeStamp = 0
    var title = ""
    var bestResponse = ""
    var owner = ""
    var key = ""
    var image = ""
    var validado = true
    var type = true //True es pregunta, false es aporte
}

struct Refered{
    var key = ""
    var refered = ""
    var status = 3
}

struct addOn{
    var active = 0
    var addOnType = 0
    var cost = 0.0
    var detail = ""
    var limitTime = 0
    var limitUses = 0
    var name = ""
    var key = ""
    var addOnUser = addOnPerUser()
}

struct addOnPerUser{
    var validado = 0
    var numUsesLeft = 0
    var date = 0
    var addOnId = ""
    var key = ""
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

struct Action{
    var key = ""
    var name = ""
    var actionId = 0
}

struct CustomsURL{
    var urlImages = ""
    var urlapp = ""
}
