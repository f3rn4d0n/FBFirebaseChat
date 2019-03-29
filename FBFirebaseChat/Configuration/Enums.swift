//
//  Enums.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/21/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

class Enums: NSObject {

}
enum userPerType: Int{
    case admin = 1
    case user = 0
}

enum messagePerType: Int{
    case text = 0
    case image = 1
    case audio = 2
    case file = 3
    case cotizacion = 4
    case video = 5
}

enum typeOS: Int{
    case iOS = 0
    case Android = 1
}

enum messagePushType: String{
    case message = "Mensaje"
    case invitation = "Invitacion"
    case quotation = "Cotizacion"
    case publicidad = "Publicidad"
}

enum openURLLinkType: String{
    case chat = "chatID"
    case foro = "foroID"
    case contact = "contactID"
    case chatToContact = "chatToContact"
}

enum userValidateStatus: Int{
    case rechazado = -1
    case invalidado = 0
    case validado = 1
    case banneado = 2
}

enum soundType: Int{
    case startRecord = 1113
    case stopRecord = 1112
    case endRecord = 1114
}
