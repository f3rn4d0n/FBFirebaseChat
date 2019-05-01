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

public class UsersWebServices: NSObject {
    
    
    //MARK: Search user
    public func getUserByUID(_ userId:String, completion:@escaping (UserFirebase) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            ChatRoomServices().showInternetError()
            completion(UserFirebase())
            return
        }
        if userId == ""{
            completion(UserFirebase())
            return
        }
        let ref = Database.database().reference()
        ref.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            var user = UserFirebase()
            user.name = value?["nombre"] as? String ?? ""
            user.dir = value?["direccion"] as? String ?? ""
            user.mail = value?["correo"] as? String ?? ""
            user.phone = value?["telefono"] as? String ?? ""
            user.photoUrl = value?["photoUrl"] as? String ?? ""
            user.key = userId
            user.typeProfile = Int(truncating: value?["tipo_de_usuario"] as? NSNumber ?? 0)
            user.validarUsuario = Int(truncating: value?["validarUsuario"] as? NSNumber ?? 0)
            user.pushNotificationKey = value?["pushNotificationKey"] as? String ?? ""
            user.webPushNotificationKey = value?["webPushNotificationKey"] as? String ?? ""
            completion(user)
        }) { (error) in
            print(error.localizedDescription)
            completion(UserFirebase())
        }
    }
    
    //MARK: Close session for only one account
    public func userSessionChangedFor(userID: String, completionSession:@escaping(Bool) ->Void, completionState:@escaping(NSNumber) ->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            ChatRoomServices().showInternetError()
            return
        }
        
        var userRef: DatabaseReference! = Database.database().reference().child("Users").child(userID)
        userRef.observe(.childChanged, with: { (snapshot) in
            if snapshot.key == "active"{
                completionSession(snapshot.value as? Bool ?? false)
            }
            if snapshot.key == "validarUsuario"{
                completionState(snapshot.value as? NSNumber ?? 0)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
