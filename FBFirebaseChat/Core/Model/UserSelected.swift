//
//  UserEntity.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 22/01/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit

class UserSelected: NSObject {

    static let sharedInstance = UserSelected()
    
    private override init() {super.init()}
    
    private var user = UserFirebase()
    
    func setUser(_ user:UserFirebase){
        self.user = user
    }
    
    func getUser() -> UserFirebase{
        return self.user
    }
    
    func updateLastLogin(_ date:Int){
        self.user.lastLogin = date
    }

    func setImageAreaTrabajo(_ image:String){
        self.user.areaTrabajo = image
    }
    
    func setImageIfeFront(_ image:String){
        self.user.ife1 = image
    }
    
    func setImageIfeBack(_ image:String){
        self.user.ife2 = image
    }
    
    func setImageComprobante(_ image:String){
        self.user.comprobanteImg = image
    }
    
    func setImageFachada(_ image:String){
        self.user.fachada = image
    }
    
    func setHaveReposCoti(_ repoActive:Bool){
        self.user.haveReposCoti = repoActive
    }
}
