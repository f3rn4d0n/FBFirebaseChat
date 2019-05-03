//
//  CreateChatController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 5/2/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

protocol UsersManagerDelegate{
    func usersFetch(_ users:[UserFirebase]?)
}

class UsersManager: NSObject {
    
    let usersWebS = UsersWebServices()
    var usersList = Array<UserFirebase>()
    var usersWebBackup = Array<UserFirebase>()
    
    var delegate: UsersManagerDelegate?
    
    /// Download chat data by your user id and user type
    @objc func requestUsers(){
        usersList = Array<UserFirebase>()
        
        usersWebS.getUsers { (users) in
            switch (users){
            case .failure(let error):
                MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
            case .success(let success):
                print(success)
                self.usersList = success
                self.usersWebBackup = success
                self.delegate?.usersFetch(success)
            }
        }
    }
}
