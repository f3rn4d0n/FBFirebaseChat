//
//  DrawerViewController.swift
//  FBFirebaseChatExample
//
//  Created by Luis Fernando Bustos Ramírez on 4/1/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import KWDrawerController
import FirebaseAuth
import FBFirebaseChat
import LFBR_SwiftLib

class DrawerCell: GenericCell <Option> {
    override var item: Option! {
        didSet {
            textLabel?.text = item.name
        }
    }
}

class DrawerViewController: GenericTableViewController<DrawerCell, Option> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = options
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.drawerController?.closeSide(completion: {
            if let drawerController = self.drawerController {
                switch indexPath.row {
                case 0:
                    let mainView = MainViewController()
                    mainView.view.backgroundColor = .blue
                    drawerController.setViewController(mainView, for: .none)
                case 1:
                    let chatListVC = ChatRoomsListTableViewController()
                    let navigationC = UINavigationController()
                    navigationC.viewControllers = [chatListVC]
                    drawerController.setViewController(navigationC, for: .none)
                default:
                    self.sendToLogout()
                    break
                }
            }
        })
    }
    
    func sendToLogout(){
        try! Auth.auth().signOut()
        let loginView = LoginViewController()
        if UIApplication.shared.windows.count > 1 {
            UIApplication.shared.windows[0].rootViewController = loginView
            UIApplication.shared.windows[0].makeKeyAndVisible()
        }else{
            UIApplication.shared.keyWindow?.rootViewController = loginView
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
}
