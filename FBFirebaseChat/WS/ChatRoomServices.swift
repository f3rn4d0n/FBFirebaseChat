 //
 //  ChatRoomServices.swift
 //  FBFirebaseChat
 //
 //  Created by Luis Fernando Bustos Ramírez on 30/01/18.
 //  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
 //
 
 import UIKit
 import Firebase
 import FirebaseDatabase
 import LFBR_SwiftLib
 
 class ChatRoomServices: NSObject {
    
    var ref: DatabaseReference!
    
    //MARK: Messages
    func getMessageFrom(chatID:String, messageID:String, completion: @escaping(Message) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(Message())
            return
        }
        ref = Database.database().reference()
        ref.child("message").child(chatID).child(messageID).observe(.value, with: { (snapshot) in
            var message = Message()
            let value = snapshot.value as? NSDictionary
            message.message = value?["messageText"] as? String ?? ""
            message.imageURL = value?["imageUrl"] as? String ?? ""
            message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
            message.userName = value?["name"] as? String ?? ""
            message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
            message.userUID = value?["senderId"] as? String ?? ""
            message.deleted = value?["deleted"] as? Bool ?? false
            message.key = snapshot.key
            completion(message)
        })
        completion(Message())
    }
    
    func getFirstMessageFrom(chatID:String,completion: @escaping(Message) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(Message())
            return
        }
        ref = Database.database().reference()
        
        ref.child("message").child(chatID).queryLimited(toFirst: UInt(1)).observe(.childAdded, with: { (snapshot) in
            var message = Message()
            let value = snapshot.value as? NSDictionary
            message.message = value?["messageText"] as? String ?? ""
            message.imageURL = value?["imageUrl"] as? String ?? ""
            message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
            message.userName = value?["name"] as? String ?? ""
            message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
            message.userUID = value?["senderId"] as? String ?? ""
            message.recordingTime = Int(truncating: value?["recordingTime"] as? NSNumber ?? 0)
            message.mensajeContestadoId = value?["mensajeContestadoId"] as? String ?? ""
            message.mensajeContestadoContenido = value?["mensajeContestadoContenido"] as? String ?? ""
            message.deleted = value?["deleted"] as? Bool ?? false
            message.key = snapshot.key
            completion(message)
        })
    }
    
    func favoritesIndex(chatID:String, favMesssages:[Message] ,completion: @escaping(NSArray) -> Void) {
        
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        let listMessages = NSMutableArray()
        ref = Database.database().reference()
        
        ref.child("message").child(chatID).observe(.value, with: { (snapshot) in
            
            let messages = snapshot.value as! NSDictionary
            
            for element in messages{
                
                var message = Message()
                let value = element.value as? NSDictionary
                
                message.message = value?["messageText"] as? String ?? ""
                message.imageURL = value?["imageUrl"] as? String ?? ""
                message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
                message.userName = value?["name"] as? String ?? ""
                message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
                message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
                message.userUID = value?["senderId"] as? String ?? ""
                message.recordingTime = Int(truncating: value?["recordingTime"] as? NSNumber ?? 0)
                message.mensajeContestadoId = value?["mensajeContestadoId"] as? String ?? ""
                message.mensajeContestadoContenido = value?["mensajeContestadoContenido"] as? String ?? ""
                message.deleted = value?["deleted"] as? Bool ?? false
                message.key = snapshot.key
                listMessages.add(message)
                
            }
            
        })
    }
    
    func getMessageFromIndex(chatID:String, beginIndex: Int, startetAt: String? = nil,completion: @escaping(Message) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(Message())
            return
        }
        ref = Database.database().reference()
        let queryRef = (startetAt != nil) ? ref
            .child("message")
            .child(chatID)
            .queryOrderedByKey()
            .queryLimited(toLast: UInt(beginIndex))
            .queryEnding(atValue: startetAt!) : ref
                .child("message")
                .child(chatID)
                .queryLimited(toLast: UInt(beginIndex))
        
        queryRef.observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var message = Message()
            message.message = value?["messageText"] as? String ?? ""
            message.imageURL = value?["imageUrl"] as? String ?? ""
            message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
            message.userName = value?["name"] as? String ?? ""
            message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
            message.userUID = value?["senderId"] as? String ?? ""
            message.recordingTime = Int(truncating: value?["recordingTime"] as? NSNumber ?? 0)
            message.mensajeContestadoId = value?["mensajeContestadoId"] as? String ?? ""
            message.mensajeContestadoContenido = value?["mensajeContestadoContenido"] as? String ?? ""
            message.deleted = value?["deleted"] as? Bool ?? false
            message.key = snapshot.key
            completion(message)
        })
        
        completion(Message())
    }
    
    func getAllMessageFromIndex(chatID:String, startetAt:String, completion: @escaping(Message) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(Message())
            return
        }
        ref = Database.database().reference()
        let queryRef = ref.child("message")
            .child(chatID)
            .queryOrderedByKey()
            .queryStarting(atValue: startetAt)
        
        queryRef.observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var message = Message()
            message.message = value?["messageText"] as? String ?? ""
            message.imageURL = value?["imageUrl"] as? String ?? ""
            message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
            message.userName = value?["name"] as? String ?? ""
            message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
            message.userUID = value?["senderId"] as? String ?? ""
            message.recordingTime = Int(truncating: value?["recordingTime"] as? NSNumber ?? 0)
            message.mensajeContestadoId = value?["mensajeContestadoId"] as? String ?? ""
            message.mensajeContestadoContenido = value?["mensajeContestadoContenido"] as? String ?? ""
            message.deleted = value?["deleted"] as? Bool ?? false
            message.key = snapshot.key
            completion(message)
        })
        
        completion(Message())
    }
    
    func getCountMessagesFrom(chatID: String, completion:@escaping(Int) ->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(0)
            return
        }
        ref = Database.database().reference()
        ref.child("message").child(chatID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            completion(value?.count ?? 0)
        }) { (error) in
            print(error.localizedDescription)
            completion(0)
        }
    }
    
    func getMessageFrom(chatID:String, completion: @escaping(NSArray) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        let listMessages = NSMutableArray()
        ref = Database.database().reference()
        ref.child("message").child(chatID).observe(.childAdded, with: { (snapshot) in
            var message = Message()
            let value = snapshot.value as? NSDictionary
            message.message = value?["messageText"] as? String ?? ""
            message.imageURL = value?["imageUrl"] as? String ?? ""
            message.imageURL = message.imageURL.replacingOccurrences(of: " ", with: "%20")
            message.userName = value?["name"] as? String ?? ""
            message.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            message.messageType = Int(truncating: value?["messageType"] as? NSNumber ?? 0)
            message.userUID = value?["senderId"] as? String ?? ""
            message.recordingTime = Int(truncating: value?["recordingTime"] as? NSNumber ?? 0)
            message.mensajeContestadoId = value?["mensajeContestadoId"] as? String ?? ""
            message.mensajeContestadoContenido = value?["mensajeContestadoContenido"] as? String ?? ""
            message.deleted = value?["deleted"] as? Bool ?? false
            message.key = snapshot.key
            listMessages.add(message)
            completion(listMessages)
        })
        completion(NSArray())
    }
    
    func listenForMessageDeleted(chatID:String, completion: @escaping(String) -> Void){
        ref = Database.database().reference()
        ref.child("message").child(chatID).observe(.childChanged, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let deleted = value?["deleted"] as? Bool ?? false
            if deleted{
                completion(snapshot.key)
            }
            print(value!)
        })
    }
    
    func sendMessageTo(chatId:String, message:String, userName:String, senderId: String, time:Int64, messageType:messagePerType? = messagePerType.text, quotationID:String? = "",mensajeContestadoId:String? = nil,mensajeContestadoContenido:String? = "", deleted:Bool? = false){
        
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("message").child(chatId).childByAutoId()
        if mensajeContestadoId != nil {
            let messageInfo = [
                "messageText": message,
                "name": userName,
                "senderId": senderId,
                "timeStamp": time,
                "messageType": messageType?.rawValue ?? messagePerType.text,
                "mensajeContestadoId": mensajeContestadoId ?? "",
                "mensajeContestadoContenido": mensajeContestadoContenido ?? "",
                "deleted": deleted ?? false
                ] as [String : Any]
            messageId.setValue(messageInfo)
        }else{
            let messageInfo = [
                "messageText": message,
                "name": userName,
                "senderId": senderId,
                "timeStamp": time,
                "messageType": messageType?.rawValue ?? messagePerType.text,
                "deleted": deleted ?? false
                ] as [String : Any]
            messageId.setValue(messageInfo)
        }
        
    }
    
    func sendImageTo(chatId:String, imageDir:String, userName:String, senderId: String, time:Int64){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("message").child(chatId).childByAutoId()
        let messageInfo = [
            "imageUrl": imageDir,
            "name": userName,
            "senderId": senderId,
            "timeStamp": time,
            "messageType": messagePerType.image.rawValue,
            "deleted":false
            ] as [String : Any]
        messageId.setValue(messageInfo)
    }
    
    func sendImageTo(chatId:String, imageDir:String, userName:String, senderId: String, time:Int64, messageType: Int){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("message").child(chatId).childByAutoId()
        let messageInfo = [
            "imageUrl": imageDir,
            "name": userName,
            "senderId": senderId,
            "timeStamp": time,
            "messageType": messageType,
            "deleted":false
            ] as [String : Any]
        messageId.setValue(messageInfo)
    }
    func sendImageTo(chatId:String, imageDir:String, userName:String, senderId: String, time:Int64, messageType: Int, message:String, recordingTime:Int? = nil){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("message").child(chatId).childByAutoId()
        if recordingTime != nil{
            let messageInfo = [
                "imageUrl": imageDir,
                "name": userName,
                "senderId": senderId,
                "timeStamp": time,
                "messageType": messageType,
                "messageText": message,
                "recordingTime":recordingTime!,
                "cotizacionID": "",
                "deleted":false
                ] as [String : Any]
            messageId.setValue(messageInfo)
            
        }else{
            let messageInfo = [
                "imageUrl": imageDir,
                "name": userName,
                "senderId": senderId,
                "timeStamp": time,
                "messageType": messageType,
                "messageText": message,
                "cotizacionID": "",
                "deleted":false
                ] as [String : Any]
            messageId.setValue(messageInfo)
        }
    }
    
    func deleteMessage(chatID:String, messageID:String, completion:@escaping(Bool) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        let chatRoomId = ref.child("message").child(chatID).child(messageID)
        let newChatRoom = [
            "deleted": true
            ] as [String : Any]
        chatRoomId.updateChildValues(newChatRoom) { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func deleteChatroomMessages(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("message").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Chatroom member
    func createChatRoomBeetween(user: String, me:String, completion: @escaping(String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        if me == user{
            MessageObject.sharedInstance.showMessage("No se puede establecer un chat contigo mismo", title: "Error", okMessage: "Aceptar")
            completion("")
            return
        }
        
        let chatRef = Database.database().reference().child("chatroom_members").child("\(user)\(me)")
        chatRef.observeSingleEvent(of: .value, with: {(snapshotMeuser:DataSnapshot) in
            if !snapshotMeuser.exists(){
                let userme = Database.database().reference().child("chatroom_members").child("\(me)\(user)")
                userme.observe(.value) { (snapshotUserme:DataSnapshot) in
                    self.createChatroomP2P(user: user, me: me, nameNode: "\(me)\(user)")
                    completion("\(me)\(user)")
                }
            }else{
                self.createChatroomP2P(user: user, me: me, nameNode: "\(user)\(me)")
                completion("\(user)\(me)")
            }
        })
    }
    
    
    func createChatroomP2P(user: String, me:String, nameNode:String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let chatRoomId = ref.child("chatroom_members").child(nameNode)
        let newChatRoom = [
            user: true,
            me: true
        ]
        chatRoomId.setValue(newChatRoom)
    }
    
    func getChatRoomBeetween(me:String, contact:String, completion: @escaping(String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        if me == contact{
            MessageObject.sharedInstance.showMessage("No se puede establecer un chat contigo mismo", title: "Error", okMessage: "Aceptar")
            completion("")
            return
        }
        let chatRef = Database.database().reference().child("chatroom_members").child("\(contact)\(me)")
        chatRef.observe(.value) { (snapshotMeuser:DataSnapshot) in
            if !snapshotMeuser.exists(){
                let userme = Database.database().reference().child("chatroom_members").child("\(me)\(contact)")
                userme.observe(.value) { (snapshotUserme:DataSnapshot) in
                    if !snapshotUserme.exists(){
                        completion("")
                    }else{
                        completion("\(me)\(contact)")
                    }
                }
            }else{
                completion("\(contact)\(me)")
            }
        }
    }
    
    func createGroupStartedByMe(_ userId:String) -> String{
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return ""
        }
        ref = Database.database().reference()
        let chatRoomId = ref.child("chatroom_members").childByAutoId()
        let newChatRoom = [
            userId: true
        ]
        chatRoomId.setValue(newChatRoom)
        return chatRoomId.key ?? ""
    }
    
    
    func addMeToChat(_ chatID:String, userID:String) -> Bool{
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return false
        }
        
        ref = Database.database().reference()
        let chatRoomId = ref.child("chatroom_members").child(chatID)
        let newChatRoom = [
            userID: true
        ]
        chatRoomId.updateChildValues(newChatRoom)
        return true
    }
    
    func removeMeFromChat(_ chatID:String, userID:String) -> Bool{
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return false
        }
        ref = Database.database().reference()
        let chatRoomId = ref.child("chatroom_members").child(chatID).child(userID)
        chatRoomId.removeValue { (error, newRef) in
            if error != nil {
                print(error as Any)
            } else {
                print(newRef)
                print("Child Removed Correctly")
            }
        }
        return true
    }
    
    func searchChatsroomsFrom(userId:String,completion:@escaping ([ChatroomMember]) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray() as! [ChatroomMember])
            return
        }
        var listChats = NSMutableArray() as! [ChatroomMember]
        ref = Database.database().reference().child("chatroom_members")
        let refQuery = ref.queryOrdered(byChild: userId).queryEqual(toValue: true)
        refQuery.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            let refQuery2 = self.ref.queryOrdered(byChild: userId).queryEqual(toValue: false)
            refQuery2.observeSingleEvent(of: .value, with: {(snapshot2:DataSnapshot) in
                for item in snapshot.children {
                    let child = item as! DataSnapshot
                    var chatroom = ChatroomMember()
                    chatroom.key = child.key
                    let array:NSArray = child.children.allObjects as NSArray
                    let members = NSMutableArray()
                    for member in  array {
                        let memberData = member as! DataSnapshot
                        members.add(memberData.key)
                    }
                    chatroom.members = members
                    listChats.append(chatroom)
                }
                for item in snapshot2.children {
                    let child = item as! DataSnapshot
                    var chatroom = ChatroomMember()
                    chatroom.key = child.key
                    let array:NSArray = child.children.allObjects as NSArray
                    let members = NSMutableArray()
                    for member in  array {
                        let memberData = member as! DataSnapshot
                        members.add(memberData.key)
                    }
                    chatroom.members = members
                    listChats.append(chatroom)
                }
                completion(listChats)
            }) {(error) in
                print(error.localizedDescription)
                completion(NSArray() as! [ChatroomMember])
            }
        }) {(error) in
            print(error.localizedDescription)
            completion(NSArray() as! [ChatroomMember])
        }
    }
    func searchChatsroomsFromAdmin(completion:@escaping ([ChatroomMember]) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray() as! [ChatroomMember])
            return
        }
        let listChats = NSMutableArray()
        ref = Database.database().reference().child("chatroom_members")
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                var chatroom = ChatroomMember()
                chatroom.key = child.key
                let array:NSArray = child.children.allObjects as NSArray
                let members = NSMutableArray()
                for member in  array {
                    let memberData = member as! DataSnapshot
                    members.add(memberData.key)
                }
                chatroom.members = members
                listChats.add(chatroom)
            }
            completion(listChats as! [ChatroomMember])
        }) {(error) in
            print(error.localizedDescription)
            completion(NSArray() as! [ChatroomMember])
        }
    }
    
    func getUsersFromChatroom(_ chatroomID: String, completion: @escaping(NSArray)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        ref = Database.database().reference().child("chatroom_members").child(chatroomID)
        ref.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            let array:NSArray = snapshot.children.allObjects as NSArray
            let members = NSMutableArray()
            for member in  array {
                let memberData = member as! DataSnapshot
                members.add(memberData.key)
            }
            completion(members)
        }
    }
    
    func deleteChatroomMember(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("chatroom_members").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Chatroom
    func createChatRoomPreviewWith(chatroomID:String, mesage: String, user:String, ownerID:String ,time:Int64, senderID:String? = UserSelected.sharedInstance.getUser().key, sharedEnable:Bool? = false){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let chatRoom = ref.child("chatroom").child(chatroomID)
        let newPreview = [
            "photoLastMessage": "",
            "lastMessage": mesage,
            "timeStamp": time,
            "owner": ownerID,
            "title": user,
            "envioElMensaje": senderID!,
            "sharedEnable": sharedEnable!
            ] as [String : Any]
        chatRoom.setValue(newPreview)
    }
    
    func updateQuotationFromChatroom(_ chatID:String, quotationState:Int, message:String, time:Int64, cotizacionID:String, senderID:String? = UserSelected.sharedInstance.getUser().key){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        
        ref = Database.database().reference()
        let chatRoomId = ref.child("chatroom").child(chatID)
        let newChatRoom = [
            "statusCotizacion": quotationState,
            "cotizacionID":cotizacionID,
            "lastMessage": message,
            "timeStamp": time,
            "envioElMensaje": senderID!
            ] as [String : Any]
        chatRoomId.updateChildValues(newChatRoom)
    }
    
    func updateChatRoomPreviewWith(chatroomID: String, message:String, time:Int64, senderID:String? = UserSelected.sharedInstance.getUser().key){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let chatRoom = ref.child("chatroom").child(chatroomID)
        let newPreview = [
            "lastMessage": message,
            "timeStamp": time,
            "envioElMensaje": senderID!
            ] as [String : Any]
        chatRoom.updateChildValues(newPreview)
    }
    
    func getChatroomPreviewFrom(chatID: String, completion:@escaping(Chatroom) ->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(Chatroom())
            return
        }
        ref = Database.database().reference()
        ref.child("chatroom").child(chatID).observeSingleEvent(of: .value, with: { (snapshot) in
            var chat = Chatroom()
            let value = snapshot.value as? NSDictionary
            chat.lastMessage = value?["lastMessage"] as? String ?? ""
            chat.photo = value?["photoLastMessage"] as? String ?? ""
            chat.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            chat.title = value?["title"] as? String ?? ""
            chat.owner = value?["owner"] as? String ?? ""
            chat.sharedEnable = value?["sharedEnable"] as? Bool ?? false
            chat.sharedEnable = true
            chat.key = snapshot.key
            completion(chat)
        }) { (error) in
            print(error.localizedDescription)
            completion(Chatroom())
        }
    }
    
    func getChatroomPreviewUpdatedFrom(chatID: String, completion:@escaping(Int) ->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        ref.child("chatroom").child(chatID).observe(.childChanged, with: { (snapshot) in
            if snapshot.key == "statusCotizacion"{
                completion(snapshot.value as? Int ?? 0)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func listenerForChatRoomUpdate(completion: @escaping(Chatroom) -> Void){
        ref = Database.database().reference()
        ref.child("chatroom").observe(.childChanged, with: { (snapshot) in
            var chat = Chatroom()
            let value = snapshot.value as? NSDictionary
            chat.lastMessage = value?["lastMessage"] as? String ?? ""
            chat.photo = value?["photoLastMessage"] as? String ?? ""
            chat.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
            chat.title = value?["title"] as? String ?? ""
            chat.owner = value?["owner"] as? String ?? ""
            chat.sharedEnable = value?["sharedEnable"] as? Bool ?? false
            chat.sharedEnable = true
            chat.key = snapshot.key
            print(value!)
            completion(chat)
        })
    }
    
    func listenerForChatRoomDeleted(completion: @escaping(String) -> Void){
        ref = Database.database().reference()
        ref.child("chatroom").observe(.childRemoved, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value!)
            print(snapshot.key)
            completion(snapshot.key)
        })
    }
    
    func deleteChatroom(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("chatroom").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    
    //MARK: Chatrooms seen
    func addChatroomSeen(chatroomID:String, time:Int64? = Date().getTimeStamp(), user:String? = UserSelected.sharedInstance.getUser().key){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference().child("chatrooms_seen").child(user!)
        let invitationInfo = [
            chatroomID:time!
            ] as [String : Any]
        ref.updateChildValues(invitationInfo)
    }
    
    func getListChatroomsSeen(_ userID:String? = UserSelected.sharedInstance.getUser().key, completion: @escaping (NSMutableDictionary)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSMutableDictionary())
            return
        }
        ref = Database.database().reference().child("chatrooms_seen").child(userID!)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            let value = snapshot.value as? NSMutableDictionary ?? NSMutableDictionary()
            completion(value)
        }) {(error) in
            print(error.localizedDescription)
            completion(NSMutableDictionary())
        }
    }
    
    //MARK: Featured messages
    func saveFeaturedMessage(_ messageID:String, inChat: String) -> String{
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return ""
        }
        ref = Database.database().reference()
        let chatroomFeatured = ref.child("chatroom_featured_message").child(inChat)
        let messageInfo = [
            messageID: messageID
            ] as [String : Any]
        chatroomFeatured.updateChildValues(messageInfo)
        return inChat
    }
    
    func getFeaturedMessageFrom(chatID:String, completion: @escaping(String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        ref = Database.database().reference()
        let chatroomFeatured = ref.child("chatroom_featured_message").child(chatID)
        chatroomFeatured.observe(.childAdded, with: { (snapshot) in
            completion(snapshot.key)
        })
        completion("")
    }
    
    func deleteFeaturedMessageIn(chatID:String, messageId:String){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let quotationDB = ref.child("chatroom_featured_message").child(chatID).child(messageId)
        quotationDB.removeValue { (error, newRef) in
            if error != nil {
                print(error as Any)
            } else {
                print(newRef)
                print("Child Removed Correctly")
            }
        }
        
    }
    
    func deleteChatroomFeaturedMessages(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("chatroom_featured_message").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Invitations method
    func sendInvitation(chatID:String, userType:String, selectedCountries:NSArray? = NSArray()){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("invitations").child(userType).child(chatID)
        let messageInfo = [
            "chadId": chatID,
            "dayLeft": 3,
            "owner": UserSelected.sharedInstance.getUser().key,
            "ownerType": UserSelected.sharedInstance.getUser().typeProfile,
            "timeStamp": Date().getTimeStamp(),
            "selectedCountries": selectedCountries!
            ] as [String : Any]
        messageId.setValue(messageInfo)
    }
    
    func sendInvitation(chatID:String, categoryName:String, subcategoryName:String, selectedCountries:NSArray? = NSArray()){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("invitations").child(categoryName).child(subcategoryName).child(chatID)
        let messageInfo = [
            "chadId": chatID,
            "dayLeft": 3,
            "owner": UserSelected.sharedInstance.getUser().key,
            "ownerType": UserSelected.sharedInstance.getUser().typeProfile,
            "timeStamp": Date().getTimeStamp(),
            "selectedCountries": selectedCountries!
            ] as [String : Any]
        messageId.setValue(messageInfo)
    }
    
    func sendInvitation(chatID:String, categoryName:String, selectedCountries:NSArray? = NSArray()){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference()
        let messageId = ref.child("invitations").child(categoryName).child(chatID)
        let messageInfo = [
            "chadId": chatID,
            "dayLeft": 3,
            "owner": UserSelected.sharedInstance.getUser().key,
            "ownerType": UserSelected.sharedInstance.getUser().typeProfile,
            "timeStamp": Date().getTimeStamp(),
            "selectedCountries": selectedCountries!
            ] as [String : Any]
        messageId.setValue(messageInfo)
    }
    
    func searchInvitationsFrom(userType:String,completion:@escaping (NSArray) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        let listInvitations = NSMutableArray()
        ref = Database.database().reference().child("invitations").child(userType)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                var invitation = Invitation()
                let value = child.value as? NSDictionary
                invitation.chatId = value?["chadId"] as? String ?? ""
                invitation.owner = value?["owner"] as? String ?? ""
                invitation.ownerType = Int(truncating: value?["ownerType"] as? NSNumber ?? 0)
                invitation.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
                invitation.dayLeft = Int(truncating: value?["dayLeft"] as? NSNumber ?? 0)
                invitation.selectedCountries = value?["selectedCountries"] as? NSArray ?? NSArray()
                listInvitations.add(invitation)
            }
            completion(listInvitations)
        }) {(error) in
            print(error.localizedDescription)
            completion(NSArray())
        }
    }
    
    func searchInvitationsFrom(category:String, subcategory:String, completion:@escaping (NSArray) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        if  category == "" {
            completion(NSArray())
            return
        }
        if  subcategory == "" {
            completion(NSArray())
            return
        }
        let listInvitations = NSMutableArray()
        ref = Database.database().reference().child("invitations").child(category).child(subcategory)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let value = child.value as? NSDictionary
                var invitation = Invitation()
                invitation.chatId = value?["chadId"] as? String ?? ""
                invitation.owner = value?["owner"] as? String ?? ""
                invitation.ownerType = Int(truncating: value?["ownerType"] as? NSNumber ?? 0)
                invitation.timeStamp = Int(truncating: value?["timeStamp"] as? NSNumber ?? 0)
                invitation.dayLeft = Int(truncating: value?["dayLeft"] as? NSNumber ?? 0)
                invitation.selectedCountries = value?["selectedCountries"] as? NSArray ?? NSArray()
                listInvitations.add(invitation)
            }
            completion(listInvitations)
        }) {(error) in
            print(error.localizedDescription)
            completion(NSArray())
        }
    }
    
    func deleteInvitations(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("chats_silenciados").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Invitations processed
    func addInvitationProcesed(invitationID:String, status:Int, completion: @escaping (Bool) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("processed_invitations").child(UserSelected.sharedInstance.getUser().key)
        let invitationInfo = [
            invitationID:status
            ] as [String : Any]
        ref.updateChildValues(invitationInfo)
        completion(true)
    }
    
    func getListInvitationsProcesed(_ userID:String, completion: @escaping (NSArray)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSArray())
            return
        }
        let listInvitations = NSMutableArray()
        ref = Database.database().reference().child("processed_invitations").child(userID)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            for item in snapshot.children {
                let child = item as! DataSnapshot
                listInvitations.add(child.key)
            }
            completion(listInvitations)
        }) {(error) in
            print(error.localizedDescription)
            completion(NSArray())
        }
    }
    
    
    //MARK: Invitations seen
    func addInvitationSeen(invitationID:String, time:Int64? = Date().getTimeStamp(), user:String? = UserSelected.sharedInstance.getUser().key){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return
        }
        ref = Database.database().reference().child("invitations_seen").child(user!)
        let invitationInfo = [
            invitationID:time!
            ] as [String : Any]
        ref.updateChildValues(invitationInfo)
    }
    
    func getListInvitationsSeen(_ userID:String? = UserSelected.sharedInstance.getUser().key, completion: @escaping (NSMutableDictionary)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSMutableDictionary())
            return
        }
        ref = Database.database().reference().child("invitations_seen").child(userID!)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            let value = snapshot.value as? NSMutableDictionary ?? NSMutableDictionary()
            completion(value)
        }) {(error) in
            print(error.localizedDescription)
            completion(NSMutableDictionary())
        }
    }
    
    
//MARK: Storage firebase, methods dont used
func uploadImage(_ img:UIImage, chatID:String, name:String) -> String{
    if !ReachabilityManager.sharedInstance.isInternetAvaliable {
        showInternetError()
        return ""
    }
    let fileDirection = "Messages/\(chatID)/\(name).jpg"
    
//        if let data:Data = UIImagePNGRepresentation(img) {
//            let storage = Storage.storage()
//            let storageRef = storage.reference()
//            let riversRef = storageRef.child(fileDirection)
//
//            // Upload the file to the path "images/rivers.jpg"
//            _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
//                guard let metadata = metadata else {
//                    print("Error al subir la imagen")
//                    return
//                }
//                print("Exito al subir la imagen \(metadata.name ?? "")")
//            }
//        }
    return fileDirection
}

func downloadImageFrom(chatID:String, name:String, completion:@escaping ((UIImage)?) -> Void){
    if !ReachabilityManager.sharedInstance.isInternetAvaliable {
        showInternetError()
        completion(nil)
        return
    }
    
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let riversRef = storageRef.child(name)
//        riversRef.downloadURL { (url, error) in
//            if (error == nil) {
//                let data = NSData(contentsOf: url!)
//                let image = UIImage(data: data! as Data)
//                completion(image)
//            }else{
//                completion(nil)
//            }
//        }
}
    
    //MARK: Chatroom code
    func addChatroomCode(chatId:String, completion: @escaping (String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        ref = Database.database().reference().child("chatroom_code").childByAutoId()
        let invitationInfo = [
            "chatId":chatId,
            "timeStamp": Date().getTimeStamp()
            ] as [String : Any]
        ref.updateChildValues(invitationInfo)
        completion(ref.key ?? "")
    }
    
    func getChatroomFrom(code:String, completion: @escaping (String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        ref = Database.database().reference()
        ref.child("chatroom_code").child(code).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let chatroomId = value?["chatId"] as? String ?? ""
            completion(chatroomId)
        }) { (error) in
            print(error.localizedDescription)
            completion("")
        }
    }
    
    func findCodeFrom(chatroom:String, completion: @escaping (String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        
        ref = Database.database().reference().child("chatroom_code")
        let refQuery = ref.queryOrdered(byChild: "chatId").queryEqual(toValue: chatroom)
        refQuery.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            var code = ""
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let value = child.value as? NSDictionary
                code = child.key
               
            }
            if code == ""{
                let ref2: DatabaseReference!
                ref2 = Database.database().reference().child("chatroom_code").childByAutoId()
                let invitationInfo = [
                    "chatId":chatroom,
                    "timeStamp": Date().getTimeStamp()
                    ] as [String : Any]
                ref2.updateChildValues(invitationInfo)
                completion(ref2.key ?? "")
            }else{
                completion(code)
            }
        }) {(error) in
            print(error.localizedDescription)
            completion("")
        }
    }
    
    //MARK: Chatroom Push Notification
    func checkStatusPushNotificationFrom(chatId:String, user:String? = UserSelected.sharedInstance.getUser().key, completion: @escaping (NSMutableArray) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(NSMutableArray())
            return
        }
        let silentUser = NSMutableArray()
        ref = Database.database().reference().child("chats_silenciados").child(chatId)
        ref.observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
            let value = snapshot.value as? NSDictionary
            if (value != nil){
                if user != ""{
                    if ((value?.object(forKey: user!)) != nil){
                        silentUser.add(user!)
                        completion(silentUser)
                    }else{
                        completion(silentUser)
                    }
                }else{
                    silentUser.addObjects(from: (value?.allKeys)!)
                    completion(silentUser)
                }
            }
            else{
                completion(silentUser)
            }
        }) {(error) in
            print(error.localizedDescription)
            completion(silentUser)
        }
    }
    
    func disablePushNotificationsIn(chatId:String, user:String? = UserSelected.sharedInstance.getUser().key, completion: @escaping (String) -> Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion("")
            return
        }
        ref = Database.database().reference().child("chats_silenciados").child(chatId)
        let invitationInfo = [
            user!:user!
            ] as [String : Any]
        ref.updateChildValues(invitationInfo)
        completion(ref.key ?? "")
    }
    
    func enablePushNotificationsFor(chatID:String, userID:String? = UserSelected.sharedInstance.getUser().key) -> Bool{
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            return false
        }
        ref = Database.database().reference()
        let chatRoomId = ref.child("chats_silenciados").child(chatID).child(userID!)
        chatRoomId.removeValue { (error, newRef) in
            if error != nil {
                print(error as Any)
            } else {
                print(newRef)
                print("Child Removed Correctly")
            }
        }
        return true
    }
    
    func deleteChatroomPushNotifications(_ chatroomID: String, completion: @escaping(Bool)->Void){
        if !ReachabilityManager.sharedInstance.isInternetAvaliable {
            showInternetError()
            completion(false)
            return
        }
        ref = Database.database().reference().child("chats_silenciados").child(chatroomID)
        ref.removeValue { (error, _) in
            if error == nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    //MARK: Clear observers
    func clearObservers(){
        ref.removeAllObservers()
        //Si nos encontramos dentro de algún chat removemos los observers correspondientes a ese chat
        if GlobalValues.sharedInstance.currentChat != ""{
            ref.child("chatroom").child(GlobalValues.sharedInstance.currentChat).removeAllObservers()
        }
    }
    
    func clearObserversFromChat(){
        ref.removeAllObservers()
        ref.child("chatroom").removeAllObservers()
    }
 }
 
 
 extension ChatRoomServices{
    func showInternetError(){
        MessageObject.sharedInstance.showMessage("Verifique su conexion a internet", title: "Error", okMessage: "Aceptar")
    }
 }
