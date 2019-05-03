//
//  ChatListViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/17/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import LFBR_SwiftLib

public class ChatListViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var chatTblView: UITableView!
    
    @IBOutlet  var mybutton: UIButton!
    private let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    var chatroomsList = NSMutableArray()
    let chatWeb = ChatRoomServices()
    var chatWebBackup = NSMutableArray()
    var usersP2P = NSMutableDictionary()
    var searching = false
    
    override public func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        prepareChatInfo()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = FBChatConfiguration().chatlistTitle
        
        let createChat = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_phone"), style: .done, target: self, action: #selector(createChatAction))
        navigationItem.rightBarButtonItems = [createChat]
        
        let silentAllChats = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_volume_off"), style: .done, target: self, action: #selector(editListOfChatrooms))
        navigationItem.leftBarButtonItems = [silentAllChats]
        
        mybutton.titleLabel?.text = "sadsdas"
        chatTblView.register(UINib(nibName: "FBChatTableViewCell", bundle: nil), forCellReuseIdentifier: "FBChatTableViewCell")
        chatTblView.delegate = self
        chatTblView.dataSource = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChats), name: NSNotification.Name(rawValue: ChatsroomsReload), object: nil)
        
        checkChatroomUpdated()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            chatTblView.refreshControl = refreshControl
        } else {
            chatTblView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(prepareChatInfo), for: .valueChanged)
    }
    
    func initialize() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Attractions"
        
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    
    /// This methods check any update in your chatroom list
    func checkChatroomUpdated(){
        chatWeb.listenerForChatRoomUpdate { (chatroomUpdated) in
            for chatroom in self.chatroomsList{
                if (chatroom as! Chatroom).key == chatroomUpdated.key{
                    self.chatroomsList.remove(chatroom)
                    self.chatroomsList.insert(chatroomUpdated, at: 0)
                    self.chatTblView.reloadData()
                    return
                }
            }
        }
        chatWeb.listenerForChatRoomDeleted{(chatroomKey) in
            for chatroom in self.chatroomsList{
                if (chatroom as! Chatroom).key == chatroomKey{
                    let updateChats = UIAlertAction(title: "Aceptar", style: .default, handler: {
                        alert -> Void in
                        self.prepareChatInfo()
                    })
                    MessageObject.sharedInstance.showMessage("Any chat was deleted, your list will be updated", title: "Deleted chat", okAction: updateChats)
                    return
                }
            }
        }
    }
    
    /// Download chat data by your user id and user type
    @objc func prepareChatInfo(){
        chatroomsList = NSMutableArray()
        chatTblView.reloadData()
        startAnimating(CGSize.init(width: 50, height: 50), message: "Please wait", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
        
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
            self.stopAnimating()
            MessageObject.sharedInstance.showMessage("You dont have any chat", title: "Chats", okMessage: "Accept")
        }
        for chat in chatrooms{
            self.chatWeb.getChatroomPreviewFrom(chatID: chat.key) { (chatroom) in
                self.chatroomsList.add(chatroom)
                if self.chatroomsList.count >= chatrooms.count{
                    var chatroomsTemp = self.chatroomsList as! [Chatroom]
                    chatroomsTemp = chatroomsTemp.sorted(by: { $0.timeStamp > $1.timeStamp })
                    let chats = NSMutableArray()
                    for chatTemp in chatroomsTemp{
                        chats.add(chatTemp)
                    }
                    self.chatroomsList = chats
                    self.chatWebBackup = chats
                    self.stopAnimating()
                    self.chatTblView.reloadData()
                }
            }
        }
    }
    
    @objc func createChatAction(sender: AnyObject) {
        if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue{
            let alertController = UIAlertController(title: "Que acción deseas realizar", message: "Selecciona la opción de tu preferencia", preferredStyle: .actionSheet)
            
            let chatroomAddHandler = { (action:UIAlertAction!) -> Void in
                self.createPrivateChatroom(false)
            }
            let deleteChatroom = {(action:UIAlertAction!) -> Void in
                self.chatTblView.setEditing(true, animated: true)
            }
            let cancelHandler = { (action:UIAlertAction!) -> Void in
                self.chatTblView.setEditing(false, animated: true)
            }
            let chatroomAddAction = UIAlertAction(title: "Create chat", style: .default, handler: chatroomAddHandler)
            let deleteChatroomAction = UIAlertAction(title: "Borrar chat", style: .destructive, handler: deleteChatroom)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: cancelHandler)
            
            alertController.addAction(chatroomAddAction)
            alertController.addAction(deleteChatroomAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.createPrivateChatroom(false)
        }
    }
    
    
    @objc func editListOfChatrooms(sender: AnyObject) {
        //TODO: terminar
        self.chatTblView.isEditing = true
    }
    
    func createPrivateChatroom(_ sharedEnable:Bool){
        self.navigationController?.pushViewController(CreateChatViewController(), animated: true)
    }
    
    @objc func reloadChats(notification: NSNotification) {
        self.chatTblView.reloadData()
    }
    
    func openChat(_ chatID: String){
        let vc = ChatRoomViewController()
        vc.chatID = chatID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatroomsList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FBChatTableViewCell") as! FBChatTableViewCell
        cell.backgroundColor = .clear
        let chatroom = chatroomsList[indexPath.row] as! Chatroom
        
//        cell.nameLbl.text = chatroom.title
//        cell.descriptionLbl.text = chatroom.lastMessage
        
        
        if chatroom.key.contains(UserSelected.sharedInstance.getUser().key){
            if usersP2P.object(forKey:chatroom.key) != nil{
                let contact =  usersP2P.object(forKey: chatroom.key) as? UserFirebase
                //cell.nameLbl.text = "\(contact?.name ?? "")"
                if contact?.photoUrl != ""{
                    let url = URL(string: (contact?.photoUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed))!)
                    //cell.userImg.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-Descargando"))
                }
            }else{
                var contactUI = chatroom.key.replacingOccurrences(of: UserSelected.sharedInstance.getUser().key, with: "")
                if contactUI.count <= 0{
                    contactUI = UserSelected.sharedInstance.getUser().key
                }
                UsersWebServices().getUserByUID(contactUI, completion: { (contact) in
                    switch (contact){
                    case .failure(let error):
                        MessageObject.sharedInstance.showMessage(error.localizedDescription, title: "Error", okMessage: "Accept")
                    case .success(let success):
                        print(success)
                        //cell.nameLbl.text = "\(contact.name)"
                        if success.photoUrl != ""{
                            let url = URL(string: (success.photoUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed))!)
                            //cell.userImg.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-Descargando"))
                        }
                        self.usersP2P.setValue(contact, forKey: chatroom.key)
                    }
                    
                    
                    
                })
            }
        }
        //Si eres el administrador
        if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue{
            //Si es un chat p2p
            if chatroom.key.contains(chatroom.owner){
                var contactUI = chatroom.key.replacingOccurrences(of: chatroom.owner, with: "")
                if contactUI.count <= 0{
                    contactUI = chatroom.owner
                }
                //Si ya sabemos quien es el owner
                if usersP2P.object(forKey: chatroom.owner) != nil{
                    //Si ya sabemos quien es el contacto
                    if (usersP2P.object(forKey: contactUI) != nil){
                        let owner =  usersP2P.object(forKey: chatroom.owner) as? UserFirebase
                        let contact =  usersP2P.object(forKey: contactUI) as? UserFirebase
                        //cell.nameLbl.text = "\(owner?.name ?? "") y \(contact?.name ?? "")"
                    }else{
                        UsersWebServices().getUserByUID(contactUI, completion: { (contact2) in
                            self.usersP2P.setValue(contact2, forKey: contactUI)
                            let owner =  self.usersP2P.object(forKey: chatroom.owner) as? UserFirebase
                            let contact =  self.usersP2P.object(forKey: contactUI) as? UserFirebase
                            //cell.nameLbl.text = "\(owner?.name ?? "") y \(contact?.name ?? "")"
                        })
                    }
                }else{
                    UsersWebServices().getUserByUID(chatroom.owner, completion: { (contact1) in
                        self.usersP2P.setValue(contact1, forKey: chatroom.owner)
                        //Si ya sabemos quien es el otro contacto
                        if (self.usersP2P.object(forKey: contactUI) != nil){
                            let owner =  self.usersP2P.object(forKey: chatroom.owner) as? UserFirebase
                            let contact =  self.usersP2P.object(forKey: contactUI) as? UserFirebase
                            //cell.nameLbl.text = "\(owner?.name ?? "") y \(contact?.name ?? "")"
                        }else{
                            UsersWebServices().getUserByUID(contactUI, completion: { (contact2) in
                                self.usersP2P.setValue(contact2, forKey: contactUI)
                                let owner =  self.usersP2P.object(forKey: chatroom.owner) as? UserFirebase
                                let contact =  self.usersP2P.object(forKey: contactUI) as? UserFirebase
                                //cell.nameLbl.text = "\(owner?.name ?? "") y \(contact?.name ?? "")"
                            })
                        }
                    })
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatroom = chatroomsList[indexPath.row] as! Chatroom
        self.openChat(chatroom.key)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatroom = chatroomsList[indexPath.row] as! Chatroom
            let seeConfiguration = UIAlertAction(title: "Borrar Chat", style: .default, handler: {
                alert -> Void in
                self.deleteAllChatroom(chatroom.key)
            })
            var message = ""
            if chatroom.key.contains(chatroom.owner){
                message = "Estas seguro de querer borrar el chat \(chatroom.title)"
            }else{
                message = "Estas seguro de querer salir del chat \(chatroom.title)"
            }
            MessageObject.sharedInstance.showMessage(message, title: "Chats", okAction: seeConfiguration, cancelMessage: "Cancelar")
        }
    }
    
    func deleteAllChatroom(_ chatroomKey:String){
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
        self.chatWeb.deleteChatroom(chatroomKey) { (deletedChatroom) in
            if deletedChatroom{
                self.chatWeb.deleteChatroomMember(chatroomKey, completion: { (deletedMembers) in
                    if deletedMembers{
                        self.chatWeb.deleteChatroomMessages(chatroomKey, completion: {(deletedMessages) in
                            if deletedMessages{
                                self.chatWeb.deleteChatroomFeaturedMessages(chatroomKey, completion: { (deletedFeaturedMessages) in
                                    if deletedFeaturedMessages{
                                        self.chatWeb.deleteChatroomPushNotifications(chatroomKey, completion: { (deletedAll) in
                                            if deletedAll{
                                                self.stopAnimating()
                                                self.chatTblView.setEditing(false, animated: true)
                                                self.removeChatFromLinst(chatroomKey)
                                                MessageObject.sharedInstance.showMessage("Chat borrado exitosamente", title: "Chats", okMessage: "Aceptar")
                                                self.chatTblView.reloadData()
                                                self.view.layoutIfNeeded()
                                            }else{
                                                self.showErrorMessage("Error al borrar los usuarios que tienen push notifications de este chat, favor de intentarlo directamente en la base de datos")
                                            }
                                        })
                                    }else{
                                        self.showErrorMessage("Error al borrar los mensajes fijos del chat, favor de intentarlo directamente en la base de datos")
                                    }
                                })
                            }else{
                                self.showErrorMessage("Error al borrar los mensajes del chat, favor de intentarlo directamente en la base de datos")
                            }
                        })
                    }else{
                        self.showErrorMessage("Error al borrar los miembros del chat, favor de intentar mas tarde")
                    }
                })
            }else{
                self.showErrorMessage("Error al borrar el chat, favor de intentar mas tarde")
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func removeChatFromLinst(_ chatroomKey:String){
        for chatroom in self.chatroomsList{
            if (chatroom as! Chatroom).key == chatroomKey{
                chatroomsList.remove(chatroom)
                return
            }
        }
        
    }
    
    func showErrorMessage(_ message:String){
        self.stopAnimating()
        self.chatTblView.setEditing(false, animated: true)
        MessageObject.sharedInstance.showMessage(message, title: "Error", okMessage: "Aceptar")
        self.view.layoutIfNeeded()
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue{
            return .delete
        }else{
            return .none
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            // it's going up
        } else {
            // it's going down
        }
    }
    
}


extension ChatListViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//        if string.isEmpty{
//            search = String(search.dropLast())
//        }
//        else{
//            search=textField.text!+string
//        }
//        let SearchData:[Chatroom] = chatWebBackup as! [Chatroom]
//        let arr = SearchData.filter(){
//            if $0.title.uppercased().contains(search.uppercased()){
//                return true
//            }
//            
//            if $0.key.contains(UserSelected.sharedInstance.getUser().key){
//                if usersP2P.object(forKey:$0.key) != nil{
//                    let contact =  usersP2P.object(forKey: $0.key) as! UserFirebase
//                    if contact.name.uppercased().contains(search.uppercased()){
//                        return true
//                    }
//                }
//            }
//            
//            return false
//        }
//        if search == ""{
//            chatroomsList = chatWebBackup
//        }else{
//            chatroomsList = NSMutableArray.init(array:(arr as Array))
//        }
//        chatTblView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let search=textField.text!
        let SearchData:[Chatroom] = chatWebBackup as! [Chatroom]
        let arr = SearchData.filter(){
            if $0.title.uppercased().contains(search.uppercased()){
                return true
            }
            
            if $0.key.contains(UserSelected.sharedInstance.getUser().key){
                if usersP2P.object(forKey:$0.key) != nil{
                    let contact =  usersP2P.object(forKey: $0.key) as! UserFirebase
                    if contact.name.uppercased().contains(search.uppercased()){
                        return true
                    }
                }
            }
            
            return false
            
        }
        if search == ""{
            chatroomsList = chatWebBackup
        }else{
            chatroomsList = NSMutableArray.init(array:(arr as Array))
        }
        chatTblView.reloadData()
    }
}


extension ChatListViewController: UISearchResultsUpdating{
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            
            let SearchData:[Chatroom] = chatWebBackup as! [Chatroom]
            let arr = SearchData.filter(){
                if $0.title.uppercased().contains(searchText.uppercased()){
                    return true
                }
                
                if $0.key.contains(UserSelected.sharedInstance.getUser().key){
                    if usersP2P.object(forKey:$0.key) != nil{
                        let contact =  usersP2P.object(forKey: $0.key) as! UserFirebase
                        if contact.name.uppercased().contains(searchText.uppercased()){
                            return true
                        }
                    }
                }
                return false
            }
            chatroomsList = NSMutableArray.init(array:(arr as Array))
            
        } else {
            chatroomsList = chatWebBackup
        }
        chatTblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        chatroomsList = chatWebBackup
        chatTblView.reloadData()
    }
}

extension ChatListViewController: UISearchBarDelegate{
    
}
