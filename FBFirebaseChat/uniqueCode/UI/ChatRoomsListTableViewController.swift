//
//  LFBRChatRoomsListTableViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 4/13/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

public class ChatRoomsListTableViewController: GenericTableViewController<FBChatTableViewCell, Chatroom> {

    var chatController = ChatRoomListController()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        setupNavigationBar()
        chatController.delegate = self
        chatController.requestChatrooms()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        chatController.checkChatroomsSeen()
    }
    
    func setupNavigationBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.title = "Chatrooms"
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Chat", style: .plain, target: self, action: #selector(handleCreateChat))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleMoreOptions))
    }
    @objc func handleCreateChat() {
        let createChatVC = CreateChatViewController()
        navigationController?.pushViewController(createChatVC, animated: true)
    }
    @objc func handleMoreOptions() {
        
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = MessagesListViewController()
        chatVC.chatID = items[indexPath.row].key
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension ChatRoomsListTableViewController: ChatRoomDelegate{
    func chatroomsObtained(_ chatrooms: [Chatroom]?) {
        items = chatrooms!
        self.tableView.reloadData()
    }
    
    func chatroomDeleted(_ chatroom: Chatroom) {
        
    }
    
    func chatroomUpdated(_ chatroom: Chatroom) {
        self.tableView.reloadData()
    }
    
    func chatroomsUpdated(_ chatrooms: [Chatroom]) {
        items = chatrooms
        self.tableView.reloadData()
    }
}
