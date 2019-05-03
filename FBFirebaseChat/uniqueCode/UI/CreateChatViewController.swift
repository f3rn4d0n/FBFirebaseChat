//
//  CreateChatViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/17/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

class CreateChatViewController: GenericTableViewController<FBUserChatTableViewCell, UserFirebase> {

    var usersController = UsersManager()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        setupNavigationBar()
        usersController.delegate = self
        usersController.requestUsers()
    }
    
    func setupNavigationBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.title = "Create Chatroom"
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    
}

extension CreateChatViewController: UsersManagerDelegate{
    func usersFetch(_ users: [UserFirebase]?) {
        if users?.count ?? 0 > 0{
            self.items = users!
            self.tableView.reloadData()
        }
    }
}
