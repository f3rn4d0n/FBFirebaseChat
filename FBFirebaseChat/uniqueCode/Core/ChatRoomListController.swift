
//
//  ChatRoomListController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 4/24/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

protocol ChatRoomDelegate{
    func chatroomsObtained(_ chatrooms:[Chatroom]?)
    func chatroomUpdated(_ chatroom:Chatroom)
    func chatroomDeleted(_ chatroom:Chatroom)
}

class ChatRoomListController: NSObject {
    
    let chatWeb = ChatRoomServices()
    var chatroomsList = Array<Chatroom>()
    var chatWebBackup = Array<Chatroom>()
    var usersP2P = NSMutableDictionary()
    
    var delegate: ChatRoomDelegate?
    
    /// Download chat data by your user id and user type
    @objc func requestChatrooms(){
        chatroomsList = Array<Chatroom>()
        //If current user is an admin, then he can see all chats without restriction
        if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue{
            chatWeb.searchChatsroomsFromAdmin { (chatrooms) in
                self.prepareChatsRooms(chatrooms)
            }
        }else{
            chatWeb.searchChatsroomsFrom(userId: UserSelected.sharedInstance.getUser().key, completion:{ (chatrooms) -> Void in
                self.prepareChatsRooms(chatrooms)
            })
        }
    }
    
    /// Download detail of your chats
    ///
    /// - Parameter chatrooms: List of chats where you are in
    func prepareChatsRooms(_ chatrooms: [ChatroomMember]){
        if chatrooms.count == 0{
            self.delegate?.chatroomsObtained(nil)
        }else{
            for chat in chatrooms{
                self.chatWeb.getChatroomPreviewFrom(chatID: chat.key) { (chatroom) in
                    self.chatroomsList.append(chatroom)
                    if self.chatroomsList.count >= chatrooms.count{
                        var chatroomsTemp = self.chatroomsList
                        chatroomsTemp = chatroomsTemp.sorted(by: { $0.timeStamp > $1.timeStamp })
                        var chats = Array<Chatroom>()
                        for chatTemp in chatroomsTemp{
                            chats.append(chatTemp)
                        }
                        self.chatroomsList = chats
                        self.checkChatroomsSeen()
                    }
                }
            }
        }
    }
    
    /// Check list of all chatrooms viewed
    func checkChatroomsSeen(){
        chatWeb.getListChatroomsSeen { (chatroomSeen) in
            if self.chatroomsList.count == 0 { return }
            for i in (0 ... self.chatroomsList.count){
                var chat = self.chatroomsList[i]
                chat.dateSeen = chatroomSeen.value(forKey: chat.key) as? Int ?? 0
                chat.newContent = chat.dateSeen > self.chatroomsList[i].timeStamp
                self.chatroomsList[i] = chat
            }
            self.chatWebBackup = self.chatroomsList
            self.delegate?.chatroomsObtained(self.chatroomsList)
        }
    }
    
    /// This methods check any update in your chatroom list
    func checkChatroomUpdated(){
        chatWeb.listenerForChatRoomUpdate{(chatroomUpdated) in
            for i in (0 ... self.chatroomsList.count){
                let chatroom = self.chatroomsList[i]
                if chatroom.key == chatroomUpdated.key{
                    self.chatroomsList.remove(at: i)
                    self.chatroomsList.insert(chatroomUpdated, at: 0)
                    self.delegate?.chatroomUpdated(chatroom)
                    return
                }
            }
        }
        chatWeb.listenerForChatRoomDeleted{(chatroomKey) in
            for i in (0 ... self.chatroomsList.count){
                let chatroom = self.chatroomsList[i]
                if chatroom.key == chatroomKey{
                    self.chatroomsList.remove(at: i)
                    self.delegate?.chatroomDeleted(chatroom)
                }
            }
        }
    }
    
    /// Update chatrooms seen
    ///
    /// - Parameter chatID: Key of chat updated
    func chatWasOpen(_ chatID: String){
        chatWeb.addChatroomSeen(chatroomID: chatID)
        for i in (0 ... self.chatroomsList.count){
            var chat = self.chatroomsList[i]
            if chat.key == chatID{
                chat.dateSeen = Int(Date().getTimeStamp())
                chat.newContent = false
            }
            self.chatroomsList[i] = chat
        }
        self.chatWebBackup = self.chatroomsList
    }
}
