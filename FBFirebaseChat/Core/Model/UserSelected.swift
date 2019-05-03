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
    
    func setUserKey(_ userKey:String){
        self.user.key = userKey
    }
    
    func updateLastLogin(_ date:Int){
        self.user.lastLogin = date
    }

}
