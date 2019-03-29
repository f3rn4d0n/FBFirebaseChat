//
//  AppConfirWebServices.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/25/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import LFBR_SwiftLib

class AppConfirWebServices: NSObject {
    //MARK: Check App Version
    func checkAppVersion(_ completion:@escaping (Int?) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            ChatRoomServices().showInternetError()
            completion(0)
        }
        var build = "1"
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            build = text
        }
        let ref = Database.database().reference()
        ref.child("app_version").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            iOSPackageVersion = Int(truncating: value?["iOS"] as? NSNumber ?? 0)
            androidPackageVersion = Int(truncating: value?["android"] as? NSNumber ?? 0)
            let myInt1 = Int(build)
            if iOSPackageVersion > myInt1!{
                completion(-1)
            }else{
                completion(1)
            }
        }) { (error) in
            print(error.localizedDescription)
            MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Ocurrio un error", okMessage: "Aceptar")
            completion(0)
        }
    }
}
