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

    var chatRooms: [Chatroom] = []
    var chatController = ChatRoomListController()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        items = chatrooms
        tableView.rowHeight = 90
        setupNavigationBar()
        chatController.delegate = self
        chatController.requestChatrooms()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
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
}

extension ChatRoomsListTableViewController: ChatRoomDelegate{
    func chatroomsObtained(_ chatrooms: [Chatroom]?) {
        
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
