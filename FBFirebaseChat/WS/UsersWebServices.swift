//
//  UsersWebServices.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/25/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import LFBR_SwiftLib
import CodableFirebase
import Foundation
import SystemConfiguration

public class UsersWebServices: NSObject {
    
    public func getUserByUID(_ userId:String, completion:@escaping(Result<UserFirebase,Error>) -> Void){
        Database.database().reference().child("development").child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(.success(self.usertFromFirebaseSnapshot(snapshot)))
        }) { (error) in
            completion(.failure(error))
        }
    }
    
    func getUsers(completion:@escaping(Result<[UserFirebase],Error>) -> Void){
        Database.database().reference().child("development").child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            var usersArr: [UserFirebase] = []
            for item in snapshot.children{
                let child = item as! DataSnapshot
                let user = self.usertFromFirebaseSnapshot(child)
                usersArr.append(user)
            }
            completion(.success(usersArr))
        }) { (error) in
            completion(.failure(error))
        }
    }
    
    func usertFromFirebaseSnapshot(_ snapshot:DataSnapshot) -> UserFirebase{
        let value = snapshot.value as? NSDictionary
        var user = UserFirebase()
        user.name = value?["nombre"] as? String ?? ""
        user.dir = value?["direccion"] as? String ?? ""
        user.mail = value?["correo"] as? String ?? ""
        user.phone = value?["telefono"] as? String ?? ""
        user.photoUrl = value?["photoUrl"] as? String ?? ""
        user.key = snapshot.key
        user.typeProfile = Int(truncating: value?["tipo_de_usuario"] as? NSNumber ?? 0)
        user.validarUsuario = Int(truncating: value?["validarUsuario"] as? NSNumber ?? 0)
        user.pushNotificationKey = value?["pushNotificationKey"] as? String ?? ""
        user.webPushNotificationKey = value?["webPushNotificationKey"] as? String ?? ""
        return user
    }
}
