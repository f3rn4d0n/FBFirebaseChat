//
//  ChatRoomViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/17/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import MobileCoreServices
import MediaPlayer
import MobileCoreServices
import AudioToolbox
import AVKit
import Photos
import Alamofire
import LFBR_SwiftLib

class ChatRoomViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var userReplyLbl: UILabel!
    @IBOutlet weak var messageReplyLbl: UILabel!
    @IBOutlet weak var wDetailBtnsConstraint: NSLayoutConstraint!
    @IBOutlet weak var hMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var sendStaticMessagesBtn: UIButton!
    @IBOutlet weak var chatTblView: UITableView!
    @IBOutlet weak var messageTxtField: UITextView!
    @IBOutlet weak var hTopicsConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatIconImg: UIImageView!
    @IBOutlet weak var chatNameLbl: UILabel!
    @IBOutlet weak var chatMoreBtn: UIButton!
    @IBOutlet weak var wChatMoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var bTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var pinSelectionBtn: UIButton!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var uploadingFilesConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewUploadImg: UIImageView!
    
    @IBOutlet weak var uploadingLbl: UILabel!
    var TAM_LAZY_LOAD_PAQUETE = 50
    var isLoadingData = false
    var videoPlayer : AVPlayer!
    var audioPayer: AVAudioPlayer!
    var soundsPlayer: AVAudioPlayer!
    var sliderReference : UISlider!
    var remainingSeconds = 0.0
    var timerSlider : Timer!
    var refAudioButton : UIButton!
    var colorDic = NSMutableDictionary()
    var colorOptions = [UIColor]()
    let imagePicker = UIImagePickerController()
    let chatWeb = ChatRoomServices()
    var messageList = NSMutableArray()
    var featuredMessages = NSMutableArray()
    var contactChat = UserFirebase()
    var currentChatroom = Chatroom()
    var listPreviews = NSMutableDictionary()
    var sendImageInProgress = 0
    var gradientEnable = true
    var shareCode = ""
    var chatID = ""
    var fileData : Data?
    var fileExtension = ""
    var mimeType = ""
    var usersCount = 0
    var isPinSelected = false
    var pushNotificationEnable = true
    var needMoveToBottom = true
    final let totalFavoriteMessages = 2
    final let messageHeightMax = CGFloat(100.0)
    final let featureHeightCell = 40.0
    var selectedFavs:[Int] = []
    var favIsActive = false
    var isUserReply = false
    var mensajeContestadoContenido = ""
    var mensajeContestadoId = ""
    var firstMessage = Message()
    var isLast = false
    var dowloadingVideoIndex = -10
    var downloadProgressValue = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        checkChatroomState()
        GlobalValues.sharedInstance.currentChat = chatID //Al ingresar al chat se indica que este es nuestro chat actual
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatWeb.clearObservers()
        GlobalValues.sharedInstance.currentChat  = "" //Al salir del chat indicamos que no se encuentra dentro de ningún chat
        chatWeb.addChatroomSeen(chatroomID: chatID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTblView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        chatTblView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "ReplyTableViewCell")
        chatTblView.delegate = self
        chatTblView.dataSource = self
        imagePicker.delegate = self
        messageTxtField.delegate = self
        chatTblView.rowHeight = UITableView.automaticDimension
        chatTblView.estimatedRowHeight = 200
        messageTxtField.layer.cornerRadius = 15
        messageTxtField.layer.masksToBounds = true
        chatIconImg.layer.cornerRadius = chatIconImg.frame.width/2
        chatIconImg.layer.masksToBounds = true
        hTopicsConstraint.constant = 0
        colorOptions = ChatColors().listColors
        
        self.hideKeyboardWhenTappedIn(currentView: chatTblView)
      
        
        uploadingFilesConstraint.constant = 0
        previewUploadImg.isHidden = true
        
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUploadingLabel), name:NSNotification.Name("upload_percent"), object: nil)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.chatTblView.addGestureRecognizer(longPressGesture)
        
        getFirstMessage()
        prepareHeader()
        prepareChatsMessages()
        checkSilentChat()
        checkMessageUpdateds()
        
        recordView.delegate = self
    }
    
    func checkMessageUpdateds(){
        self.chatWeb.clearObservers()
        self.chatWeb.listenForMessageDeleted(chatID: chatID) { (messageID) in
            for message in self.messageList{
                if (message as! Message).key == messageID{
                    var messageTemp = (message as! Message)
                    messageTemp.deleted = true
                    self.messageList.replaceObject(at: self.messageList.index(of: message), with: messageTemp)
                    self.chatTblView.reloadData()
                    return;
                }
            }
        }
        
        self.chatWeb.listenerForChatRoomDeleted{(chatroomKey) in
            if self.chatID == chatroomKey{
                let updateChats = UIAlertAction(title: "Salir", style: .default, handler: {
                    alert -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                MessageObject.sharedInstance.showMessage("Este chat ha sido borrado por un administrador", title: "Alerta", okAction: updateChats)
            }
        }
        
    }
    
    func prepareHeader(){
        self.headerView.layer.masksToBounds = false
        self.headerView.layer.shadowColor = UIColor.black.cgColor
        self.headerView.layer.shadowOpacity = 0.5
        self.headerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.headerView.layer.shadowRadius = 3
        
        self.headerView.layer.shadowPath = UIBezierPath(rect: headerView.bounds).cgPath
        self.headerView.layer.shouldRasterize = true
    }
    
    func prepareChatsMessages(){
        //Si el chat es p2p contigo
        if chatID.contains(UserSelected.sharedInstance.getUser().key){
            var contactUI = chatID.replacingOccurrences(of: UserSelected.sharedInstance.getUser().key, with: "")
            if contactUI.count <= 0{
                contactUI = UserSelected.sharedInstance.getUser().key
            }
            UsersWebServices().getUserByUID(contactUI, completion: { (contact) in
                self.chatNameLbl.text = contact.name
                self.contactChat = contact
                
                self.chatWeb.getChatroomPreviewFrom(chatID: self.chatID) { (chatroom) in
                    self.currentChatroom = chatroom
                    self.getListMessages()
                }
            })
        }else{
            chatWeb.getChatroomPreviewFrom(chatID: chatID) { (chatroom) in
                self.currentChatroom = chatroom
                //Si es un chat p2p donde no estas incluido, este caso puede ocurrir cuando eres admin
                if self.currentChatroom.key.contains(self.currentChatroom.owner){
                    var contactUI = self.currentChatroom.key.replacingOccurrences(of: self.currentChatroom.owner, with: "")
                    if contactUI.count <= 0{
                        contactUI = self.currentChatroom.owner
                    }
                    UsersWebServices().getUserByUID(contactUI, completion: { (contact1) in
                        UsersWebServices().getUserByUID(self.currentChatroom.owner, completion: { (contact2) in
                            self.chatNameLbl.text = "\(contact1.name) y \(contact2.name)"
                            self.chatWeb.getChatroomPreviewFrom(chatID: self.chatID) { (chatroom) in
                                self.currentChatroom = chatroom
                                self.getListMessages()
                            }
                        })
                    })
                }else{
                    self.chatNameLbl.text = chatroom.title
                    if chatroom.photo.isEmpty || chatroom.photo == "null"{
                        self.chatIconImg.image = #imageLiteral(resourceName: "user")
                    }else{
                        let url = URL(string: chatroom.photo)
                        self.chatIconImg.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-Descargando"))
                    }
                    self.getListMessages()
                }
            }
        }
        getfeaturedMessages()
    }
    
    func checkBusinessLogic(){
        //        chatWeb.getCountMessagesFrom(chatID: chatID) { (totalMessages) in
        //            if self.contactChat.typeProfile == userPerType.profesionista.rawValue && UserSelected.sharedInstance.getUser().typeProfile == userPerType.proveedor.rawValue{
        //                if totalMessages == 0{
        //                    self.footerView.isHidden = true
        //                    MessageObject.sharedInstance.showMessage("El chat no se activara hasta que el tecnico envíe el primer mensaje", title: "Alerta", accept: "Aceptar")
        //                }else{
        //                    self.footerView.isHidden = false
        //                }
        //            }
        //            if self.contactChat.typeProfile == userPerType.proveedor.rawValue
        //                && UserSelected.sharedInstance.getUser().typeProfile == userPerType.profesionista.rawValue
        //                && totalMessages == 0{
        //                MessageObject.sharedInstance.showMessage("El proveedor no podra enviar mensajes hasta que tu escribas el primer mensaje", title: "Alerta", accept: "Aceptar")
        //            }
        //        }
        self.checkUsersList()
    }
    
    func getListMessages(){
        self.checkBusinessLogic()
        messageList = NSMutableArray()
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
        chatWeb.getMessageFromIndex(chatID: chatID, beginIndex: TAM_LAZY_LOAD_PAQUETE, completion: { (messages) -> Void in
            self.stopAnimating()
            if messages.key != ""{
                self.messageList.add(messages)
                let cellNumbers = self.chatTblView.numberOfRows(inSection: 0)
                print("testando mensajes \(self.messageList.count) vs celdas \(cellNumbers)")
                if self.messageList.count > cellNumbers + 1{
                    self.chatTblView.reloadData()
                }else{
                    self.chatTblView.insertRows(at: [IndexPath(row: self.messageList.count-1, section:0)], with: .automatic)
                }
                self.scrollToBottom()
            }
        })
        if self.currentChatroom.sharedEnable && self.currentChatroom.owner == UserSelected.sharedInstance.getUser().key{
            self.getSharedCode()
        }
    }
    
    func scrollChatTableAt(indexPath:IndexPath){
        
        DispatchQueue.main.async {
            if(self.messageList.count > 2 ){
                self.chatTblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }else{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    
    func getfeaturedMessages(){
        featuredMessages = NSMutableArray()
        chatWeb.getFeaturedMessageFrom(chatID: chatID) { (messageId) in
            if messageId.count > 0{
                self.chatWeb.getMessageFrom(chatID: self.chatID, messageID: messageId, completion: { (message) in
                    if message.key.count > 0{
                        self.featuredMessages.add(message)
                        self.hTopicsConstraint.constant = CGFloat(self.featureHeightCell * Double(self.featuredMessages.count))
                        self.view.layoutIfNeeded()
                        
                        if self.gradientEnable{
                            self.gradientEnable = false
                            //                            let gradient = CAGradientLayer()
                            //                            gradient.frame = self.chatTblView.superview?.bounds ?? CGRect.null
                            //                            gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
                            //                            gradient.locations = [0.0, 0.01, 0.1, 1.0]
                            //                            self.chatTblView.superview?.layer.mask = gradient
                        }
                    }
                })
            }
        }
    }
    
    func getSharedCode(){
        self.chatWeb.findCodeFrom(chatroom: currentChatroom.key) { (code) in
            self.shareCode = code
        }
    }
    
    func checkSilentChat(){
        chatWeb.checkStatusPushNotificationFrom(chatId: chatID) { (silentsChats) in
            if silentsChats.count > 0{
                self.pushNotificationEnable = false
            }else{
                self.pushNotificationEnable = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.bTextViewConstraint.constant == 0{
                self.bTextViewConstraint.constant = -heightKeyboard()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.bTextViewConstraint.constant != 0{
            self.bTextViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    @objc func updateUploadingLabel(notification: NSNotification) {
        let percent = notification.object as! Double
        let percetnString = String(format: "%.1f", percent)
        self.uploadingLbl.text = "Subiendo \(percetnString)%"
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        if !(messageTxtField.text?.isEmpty)!{
            needMoveToBottom = true
            let timeStamp = Date()
            if(isUserReply){
                chatWeb.sendMessageTo(chatId: chatID, message: messageTxtField.text!, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: timeStamp.getTimeStamp(), mensajeContestadoId : self.mensajeContestadoId,mensajeContestadoContenido: self.mensajeContestadoContenido)
                chatWeb.updateChatRoomPreviewWith(chatroomID: chatID, message: messageTxtField.text!, time:  timeStamp.getTimeStamp())
                self.needMoveToBottom = true
                isUserReply = false
                replyView.isHidden = true
                recordView.isHidden = false
                addFileBtn.isHidden = false
            }else{
                chatWeb.sendMessageTo(chatId: chatID, message: messageTxtField.text!, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: timeStamp.getTimeStamp())
                chatWeb.updateChatRoomPreviewWith(chatroomID: chatID, message: messageTxtField.text!, time:  timeStamp.getTimeStamp())
                self.needMoveToBottom = true
            }
            messageTxtField.text = ""
            hMessageConstraint.constant = 30
            //view.endEditing(true)
        }
    }
    
    @IBAction func returnAction(_ sender: Any) {
        if sendImageInProgress > 0{
            let okAction = UIAlertAction(title: "Salir", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                if(self.audioPayer != nil){
                    self.audioPayer.stop()
                }
                self.navigationController?.popViewController(animated: true)
            })
            MessageObject.sharedInstance.showMessage("Todavía hay un archivo enviandose, seguro que deseas salir", title: "Alerta", okAction: okAction, cancelMessage: "Cancelar")
        }else{
            if(audioPayer != nil){
                audioPayer.stop()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addFileAction(_ sender: Any) {
        
        if favIsActive{
            addFileBtn.setImage(UIImage(named: "multimedia"), for: .normal)
            self.chatTblView.setEditing(false, animated: true)
            favIsActive = false
            let okAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                for index in self.selectedFavs{
                    self.selectFeatureMessageFrom(index: index)
                }
                self.selectedFavs = []
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                self.selectedFavs = []
            }
            MessageObject.sharedInstance.showMessage("Fijar mensajes", title: "Seguro que deseas agregar estos mensajes como favoritos, solo tienes \(self.totalFavoriteMessages - self.featuredMessages.count) mas para agregar",  okAction:okAction, cancelAction: cancelAction)
            return
        }else{
            
        }
        
        let docTypes = [
            kUTTypeXML as String,
            kUTTypePDF as String,
            kUTTypeGIF as String,
            kUTTypeMP3 as String,
            kUTTypePNG as String,
            kUTTypeJPEG as String,
            kUTTypeText as String,
            kUTTypeAudio as String,
            kUTTypeImage as String,
            kUTTypeMovie as String,
            kUTTypeMPEG4 as String,
            kUTTypeContent as String,
            kUTTypeApplication as String,
            kUTTypeZipArchive as String,
            kUTTypeSpreadsheet as String,
            kUTTypeUTF8PlainText as String,
            kUTTypeUTF16PlainText as String,
            kUTTypeApplicationFile as String,
            kUTTypeCompositeContent as String,
            kUTTypeWindowsExecutable as String,
            kUTTypeUTF8TabSeparatedText as String,
            kUTTypeTXNTextAndMultimediaData as String,
            "com.microsoft.word.doc",
            "com.microsoft.word.xls"
            ] as [String]
        let importMenu = UIDocumentMenuViewController(documentTypes: docTypes, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        importMenu.popoverPresentationController?.sourceView = self.view
        self.present(importMenu, animated: true, completion: nil)
        
//        importMenu.addOption(withTitle: "Imagenes", image: nil, order: .first, handler: {
//            let nohanaPicker = NohanaImagePickerController()
//            nohanaPicker.maximumNumberOfSelection = 7
//            nohanaPicker.delegate = self
//            self.present(nohanaPicker, animated: true, completion: nil)
//        })
        importMenu.addOption(withTitle: "Videos", image: nil, order: .first, handler: {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        importMenu.addOption(withTitle: "Camara", image: nil, order: .first, handler: {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker, animated: true, completion: nil)
        })
    }
    
    
    @IBAction func moreInfoAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Que acción deseas realizar", message: "Selecciona la opción de tu preferencia", preferredStyle: .actionSheet)
        
        let letLogOutHandler = { (action:UIAlertAction!) -> Void in
            self.logoutFromChat()
        }
        let seeContactsHandler = { (action:UIAlertAction!) -> Void in
            self.seeContacts()
        }
        let seeProfileChatP2PHandler = { (action:UIAlertAction!) -> Void in
            self.seeProfile()
        }
        let disablePushNotificationHandler = {(action:UIAlertAction!) -> Void in
            self.disablePushNotification()
        }
        let addFavoriteHandler = { (action:UIAlertAction!) -> Void in
            self.addFavorite()
        }
        
        let cancelHandler = { (action:UIAlertAction!) -> Void in}
        let contactsAction = UIAlertAction(title: "Ver integrantes del chat", style: .default, handler: seeContactsHandler)
        let profileAction = UIAlertAction(title: "Ver perfil", style: .default, handler: seeProfileChatP2PHandler)
        let logoutAction = UIAlertAction(title: "Salir del chat", style: .default, handler: letLogOutHandler)
        let silentChat = UIAlertAction(title: "Silenciar chat", style: .default, handler: disablePushNotificationHandler)
        let unSilentChat = UIAlertAction(title: "Desactivar silencio del chat", style: .default, handler: disablePushNotificationHandler)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: cancelHandler)
        let addFavorite = UIAlertAction(title: "Fijar mensajes", style: .default, handler: addFavoriteHandler)
        
        //Si eres administrador no puedes salir de un chat
        if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue{
            alertController.addAction(contactsAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            if pushNotificationEnable{
                alertController.addAction(silentChat)
            }else{
                alertController.addAction(unSilentChat)
            }
            
            //Solo si es un chat p2p puedes enviar cotizaciones
            if chatID.contains(UserSelected.sharedInstance.getUser().key){
                if usersCount != 1{
                    alertController.addAction(profileAction)
                }
                    alertController.addAction(logoutAction)
            }else{
                alertController.addAction(contactsAction)
                alertController.addAction(logoutAction)
            }
            //Solo si eres el creador puedes agregar mensajes favoritos
            if currentChatroom.owner == UserSelected.sharedInstance.getUser().key && !chatID.contains(UserSelected.sharedInstance.getUser().key){
                let totalFavs = (selectedFavs.count+self.featuredMessages.count)
                if(totalFavs < totalFavoriteMessages){
                    alertController.addAction(addFavorite)
                }
            }
            //Accion de cancelar
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func logoutFromChat(){
        let okAction = UIAlertAction(title: "Salir", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if self.chatWeb.removeMeFromChat(self.chatID, userID: UserSelected.sharedInstance.getUser().key){
                self.navigationController?.popViewController(animated: true)
            }
        })
        MessageObject.sharedInstance.showMessage("Estas seguro de querer abandonar este chat", title: "Alerta", okAction: okAction, cancelMessage: "Cancelar")
    }
    
    func seeProfile(){
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"UserDetailViewController") as! UserDetailViewController
//        vc.message = "Hola"
//        var contactUI = chatID.replacingOccurrences(of: UserSelected.sharedInstance.getUser().key, with: "")
//        if contactUI.count <= 0{
//            contactUI = UserSelected.sharedInstance.getUser().key
//        }
//        vc.contactUID = contactUI
//        vc.currentUID = UserSelected.sharedInstance.getUser().key
//        vc.parentView = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func seeContacts(){
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"ListContactsViewController") as! ListContactsViewController
//        vc.chatID = self.chatID
//        vc.owner = currentChatroom.owner
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkChatroomState(){
        chatWeb.getChatroomPreviewFrom(chatID: self.chatID) { (chatroom) in
            self.currentChatroom = chatroom
        }
    }
    
    func checkUsersList(){
        if chatID.contains(UserSelected.sharedInstance.getUser().key){
            chatWeb.getUsersFromChatroom(chatID) { (usersList) in
                self.usersCount = usersList.count
                if usersList.count == 1{
                    MessageObject.sharedInstance.showMessage("El usuario con el que contactabas ha abandonado el chat", title: "Alerta", okMessage: "Aceptar")
                    self.footerView.isHidden = true
                }
            }
        }
    }
    
    func disablePushNotification(){
        if pushNotificationEnable{
            let okAction = UIAlertAction(title: "Silenciar", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                self.chatWeb.disablePushNotificationsIn(chatId: self.chatID, completion: { (disableChat) in
                    if disableChat != ""{
                        self.pushNotificationEnable = false
                        MessageObject.sharedInstance.showMessage("El chat se ha silenciado exitosamente", title: "Alerta", okMessage: "Aceptar")
                    }else{
                        MessageObject.sharedInstance.showMessage("Error al silenciar el chat, favor de intentar mas tarde", title: "Error", okMessage: "Aceptar")
                    }
                })
            })
            MessageObject.sharedInstance.showMessage("Seguro que deseas silenciar este chat", title: "Alerta", okAction: okAction, cancelMessage: "Cancelar")
        }else{
            if chatWeb.enablePushNotificationsFor(chatID: chatID){
                self.pushNotificationEnable = true
                MessageObject.sharedInstance.showMessage("Se habilitaron las notificaciones para este chat", title: "Alerta", okMessage: "Aceptar")
            }else{
                MessageObject.sharedInstance.showMessage("Error al habilitar las notificaciones en este chat, favor de intentar mas tarde", title: "Error", okMessage: "Aceptar")
            }
        }
    }
    
    
    func createthumbnailVideo(forUrl url: URL) -> UIImage? {
        if (listPreviews.object(forKey: url.absoluteString) != nil){
            return listPreviews.object(forKey: url.absoluteString) as? UIImage
        }else{
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                listPreviews.addEntries(from: [url.absoluteString:UIImage(cgImage: thumbnailImage)])
                return UIImage(cgImage: thumbnailImage)
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    @IBAction func closeReplyView(_ sender: Any) {
        isUserReply = false
        replyView.isHidden = true
        recordView.isHidden = false
        addFileBtn.isHidden = false
    }
    
    func controllImageInProgress(increased: Bool, imageFile:URL?){
        if increased{
            sendImageInProgress += 1
        }else{
            sendImageInProgress -= 1
        }
        if sendImageInProgress > 0{
            uploadingFilesConstraint.constant = 65
            previewUploadImg.isHidden = false
        }else{
            uploadingFilesConstraint.constant = 0
            previewUploadImg.isHidden = true
        }
        self.view.layoutIfNeeded()
        if (imageFile != nil){
            previewUploadImg.image = getPreviewImage(videoFileURL: imageFile!)
        }
    }
    
    func getFirstMessage(){
        chatWeb.getFirstMessageFrom(chatID: chatID,completion:{ (message) -> Void in
            self.firstMessage = message
        })
    }
    
    func loadMessages(){
        print("Total de mensajes actuales \(messageList.count)")
        var index = 0
        let firstObjetc = (messageList.count > 0) ? (messageList.firstObject as! Message).key : nil
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
        chatWeb.getMessageFromIndex(chatID: chatID, beginIndex:TAM_LAZY_LOAD_PAQUETE, startetAt: firstObjetc, completion:{ (message) -> Void in
            if message.key != ""{
                if firstObjetc! != message.key{
                    self.messageList.insert(message, at: index)
                }
                index = index + 1
                if firstObjetc! == message.key{
                    if firstObjetc == self.firstMessage.key{
                        self.isLoadingData = true
                    }else{
                        self.isLoadingData = false
                    }
                    if (self.messageList.count - 1) >= index{
                        self.chatTblView.reloadData()
                        let indexPath = IndexPath(row: index, section: 0)
                        self.chatTblView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
            self.stopAnimating()
        })
    }
    
    func loadMessagesFrom(messageId: String){
        var index = 0
        var continueAdding = true
        let firstObjetc = (messageList.count > 0) ? (messageList.firstObject as! Message).key : nil
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
        chatWeb.getAllMessageFromIndex(chatID: chatID, startetAt: messageId) { (message) in
            if message.key != ""{
                if firstObjetc! != message.key{
                    if continueAdding{
                        self.messageList.insert(message, at: index)
                    }
                }
                index = index + 1
                if firstObjetc! == message.key{
                    continueAdding = false
                    if firstObjetc == self.firstMessage.key{
                        self.isLoadingData = true
                    }else{
                        self.isLoadingData = false
                    }
                    if (self.messageList.count - 1) >= index{
                        self.chatTblView.reloadData()
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.chatTblView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
            self.stopAnimating()
        }
    }
}

extension ChatRoomViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != hMessageConstraint.constant{
            if size.height >= messageHeightMax{
                hMessageConstraint.constant = messageHeightMax
            }else{
                hMessageConstraint.constant = size.height
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        isUserReply = false
        replyView.isHidden = true
        recordView.isHidden = false
        addFileBtn.isHidden = false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollToBottom()
    }
}

extension  ChatRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if let pickedImage = info[.originalImage] as? UIImage {
                let timeStamp = Date()
                let webServicesImg = WebImageServices()
                self.startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
                pickedImage.jpegData(compressionQuality: GlobalValues.sharedInstance.compressionQuoality)
                let dataToUpload = pickedImage.jpegData(compressionQuality: GlobalValues.sharedInstance.compressionQuoality)
                webServicesImg.upload(fileData: dataToUpload, fileName: "\(timeStamp.getTimeStamp()).jpeg", mimeType: "image/jpeg",  parameters: [:], onCompletion: { (response) in
                    self.chatWeb.sendImageTo(chatId: self.chatID, imageDir: response, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: timeStamp.getTimeStamp())
                    self.needMoveToBottom = true
                    self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID, message: "Imagen recibida", time:  timeStamp.getTimeStamp())
                    self.stopAnimating()
                }, onError: { (error) in
                    print(error)
                    self.stopAnimating()
                })
            }
            if let mediaType = info[.mediaType] as? NSString{
                if mediaType == kUTTypeMovie{
                    
                    let chosenVideo = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                    let videoData = try! Data(contentsOf: chosenVideo, options: [])
                    
                    let timeStamp = Date()
                    let webServicesImg = WebImageServices()
                    self.controllImageInProgress(increased: true, imageFile: chosenVideo)
                    //startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
                    webServicesImg.upload(fileData: videoData,
                                          fileName: "\(timeStamp.getTimeStamp())FBFirebaseChat.m4a",
                        mimeType: "video/mp4",  parameters: [:],
                        onCompletion: { (response) in
                            self.chatWeb.sendImageTo(chatId: self.chatID, imageDir: response, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: timeStamp.getTimeStamp(), messageType: messagePerType.video.rawValue, message: "Video recibido")
                            self.needMoveToBottom = true
                            self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID, message: "Video recibido", time:  timeStamp.getTimeStamp())
                            self.controllImageInProgress(increased: false, imageFile: nil)
                            //self.stopAnimating()
                    }, onError: { (error) in
                        print(error)
                        self.controllImageInProgress(increased: false, imageFile: nil)
                        //self.stopAnimating()
                    })
                }
            }
        })
        MessageObject.sharedInstance.showMessage("Seguro que deseas enviar este archivo", title: "Alerta", okAction: okAction, cancelMessage: "Cancelar")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChatRoomViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fileURL = url as URL
        print("The Url is : \(fileURL)")
        do{
            let extensionFile = url as NSURL
            var fileName = (extensionFile.absoluteString! as NSString).lastPathComponent
            fileName = fileName.replacingOccurrences(of: "%20", with: "")
            fileExtension = extensionFile.pathExtension!
            if fileExtension == "pdf" {
                mimeType =  "application/pdf"
            }
            else if fileExtension == "jpeg" {
                mimeType = "image/jpeg"
            }
            else if fileExtension == "mp3" {
                mimeType = "audio/mpeg"
            }
            else if fileExtension == "txt" {
                mimeType = "text/plain"
            }
            else if fileExtension == "mp4" {
                mimeType = "video/mp4"
            }
            fileData = try  Data(contentsOf: url)
            
            let webServicesImg = WebImageServices()
            startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
            webServicesImg.upload(fileData: fileData,
                                  fileName: "\(Date().getTimeStamp())\(fileName)",
                mimeType: mimeType,  parameters: [:],
                onCompletion: { (response) in
                    self.chatWeb.sendImageTo(chatId: self.chatID, imageDir: response, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: Date().getTimeStamp(), messageType: messagePerType.file.rawValue, message: fileName)
                    self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID, message: "Archivo recibido", time:  Date().getTimeStamp())
                    self.needMoveToBottom = true
                    self.stopAnimating()
            }, onError: { (error) in
                print(error)
                self.stopAnimating()
            })
        }catch{
            MessageObject.sharedInstance.showMessage("No se pudo acceder a tu archivo", title: "Error", okMessage: "Aceptar")
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor =  FBChatConfiguration().mainColor
        navigationBarAppearace.barTintColor =  FBChatConfiguration().mainColor
        
        UITabBar.appearance().unselectedItemTintColor =  FBChatConfiguration().mainColor
        UITabBar.appearance().tintColor =  FBChatConfiguration().secondaryColor
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor =  FBChatConfiguration().mainColor
        
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().tintColor =  FBChatConfiguration().secondaryColor
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row >= messageList.count - 4{
                needMoveToBottom = true
            }else{
                needMoveToBottom = false
            }
            let message = self.messageList[indexPath.row] as! Message
            
            if message.deleted{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
                cell.backgroundColor = .clear
                
                if message.userUID == UserSelected.sharedInstance.getUser().key{
                    cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                    cell.userNameLbl.backgroundColor = .white
                    cell.userNameLbl.textColor = .black
                    cell.userNameLbl.textAlignment = .right
                    cell.messageTxtView.textAlignment = .right
                    cell.messageeLbl.textAlignment = .right
                    cell.bubbleLeadingConstraint.constant = 100
                    cell.bubbleTrailingConstraint.constant = 8
                    cell.receivedTriangle.isHidden = true
                    cell.sendedTriangle.isHidden = false
                    let triangle = TriangleSended(frame: CGRect(x: 0, y: 0, width: cell.sendedTriangle.frame.width , height: 10))
                    triangle.backgroundColor = .clear
                    cell.sendedTriangle.addSubview(triangle)
                }else{
                    cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                    cell.userNameLbl.backgroundColor = .white
                    cell.userNameLbl.textColor = .white
                    cell.userNameLbl.textAlignment = .left
                    cell.messageTxtView.textAlignment = .left
                    cell.messageeLbl.textAlignment = .left
                    cell.bubbleLeadingConstraint.constant = 8
                    cell.bubbleTrailingConstraint.constant = 100
                    cell.receivedTriangle.isHidden = false
                    cell.sendedTriangle.isHidden = true
                    let triangle = TriangleRecived(frame: CGRect(x: 0, y: 0, width: cell.receivedTriangle.frame.width , height: 10))
                    triangle.backgroundColor = .clear
                    cell.receivedTriangle.addSubview(triangle)
                    
                    if (colorDic.object(forKey: message.userUID) != nil){
                        let color = colorDic.object(forKey: message.userUID) as! UIColor
                        cell.userNameLbl.textColor = color
                    }else{
                        var color = UIColor.random()
                        if (colorOptions.count > 0){
                            color = colorOptions.popLast()!
                        }
                        colorDic.setValue(color, forKey: message.userUID)
                        cell.userNameLbl.textColor = color
                    }
                }
                
                cell.userNameLbl.layer.cornerRadius = 5
                cell.userNameLbl.layer.masksToBounds = true
                if #available(iOS 11.0, *) {
                    cell.userNameLbl.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                }
                cell.userNameLbl.text = "   \(message.userName) - \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())   "
                cell.messageTxtView.isUserInteractionEnabled = true
                cell.playThumbView.isHidden = true
                cell.audioDurationLbl.isHidden = true
                cell.voiceNoteView.isHidden = true
                cell.downloadingIndicator.isHidden = true
                cell.progressDowloadView.isHidden = true
                cell.messageeLbl.text = ""
                cell.messageTxtView.text = "ø Este mensaje fue eliminado"
                cell.messageTxtView.font = UIFont.italicSystemFont(ofSize: 14)
                cell.messageTxtView.textColor = .lightGray
                cell.imageSended.image = nil
                cell.imageSended.isHidden = true
                return cell
            }
            
            if(message.mensajeContestadoId != ""){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as! ReplyTableViewCell
                cell.backgroundColor = .clear
                
                if message.userUID == UserSelected.sharedInstance.getUser().key{
                    cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                    cell.userNameLbl.backgroundColor = .white
                    cell.userNameLbl.textColor = .black
                    cell.userNameLbl.textAlignment = .right
                    cell.repliedMessageLbl.textAlignment = .right
                    cell.messageTextView.textAlignment = .right
                    cell.messageLbl.textAlignment = .right
                    cell.bubbleLeadingConstraint.constant = 100
                    cell.bubbleTrailingConstraint.constant = 8
                    cell.receivedTriangle.isHidden = true
                    cell.sendedTriangle.isHidden = false
                    let triangle = TriangleSended(frame: CGRect(x: 0, y: 0, width: cell.sendedTriangle.frame.width , height: 10))
                    triangle.backgroundColor = .clear
                    cell.sendedTriangle.addSubview(triangle)
                }else{
                    cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                    cell.userNameLbl.backgroundColor = .white
                    cell.userNameLbl.textColor = .white
                    cell.userNameLbl.textAlignment = .left
                    cell.repliedMessageLbl.textAlignment = .left
                    cell.messageTextView.textAlignment = .left
                    cell.messageLbl.textAlignment = .left
                    cell.bubbleLeadingConstraint.constant = 8
                    cell.bubbleTrailingConstraint.constant = 100
                    cell.receivedTriangle.isHidden = false
                    cell.sendedTriangle.isHidden = true
                    let triangle = TriangleRecived(frame: CGRect(x: 0, y: 0, width: cell.receivedTriangle.frame.width , height: 10))
                    triangle.backgroundColor = .clear
                    cell.receivedTriangle.addSubview(triangle)
                    
                    if (colorDic.object(forKey: message.userUID) != nil){
                        let color = colorDic.object(forKey: message.userUID) as! UIColor
                        cell.userNameLbl.textColor = color
                    }else{
                        
                        var color = UIColor.random()
                        if (colorOptions.count > 0){
                            color = colorOptions.popLast()!
                        }
                        colorDic.setValue(color, forKey: message.userUID)
                        cell.userNameLbl.textColor = color
                    }
                }
                cell.userNameLbl.text = "   \(message.userName) - \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())   "
                cell.messageLbl.text = message.message
                cell.messageTextView.text = message.message
                cell.messageLbl.isHidden = true
                let mesageArray = messageList as! [Message]
                if let replaiedMessage = mesageArray.first(where:{ $0.key == message.mensajeContestadoId}){
                    let messageIndex = mesageArray.index(where:{ $0.key == message.mensajeContestadoId})
                    cell.repliedUserLbl.text = replaiedMessage.userName
                    cell.repliedMessageLbl.text = replaiedMessage.message
                    cell.repliedAreaBtn.tag = messageIndex!
                    cell.repliedAreaBtn.addTarget(self, action: #selector(self.moveToRepliedMessage(sender:)), for: .touchUpInside)
                    if replaiedMessage.messageType == messagePerType.audio.rawValue{
                        cell.repliedMessageLbl.text = "Audio \(self.getTimeFromSeconds(recordingTime: replaiedMessage.recordingTime))"
                    }
                    if replaiedMessage.messageType == messagePerType.video.rawValue{
                        
                        cell.repliedMessageLbl.text = "Video \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())"
                    }
                    if replaiedMessage.messageType == messagePerType.image.rawValue{
                        cell.repliedMessageLbl.text = "Imagen \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())"
                    }
                    if replaiedMessage.messageType == messagePerType.file.rawValue{
                        cell.repliedMessageLbl.text = "Documento \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())"
                    }
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
            cell.backgroundColor = .clear
            
            cell.voiceNoteView.isHidden = true
            cell.downloadingIndicator.isHidden = true
            cell.progressDowloadView.isHidden = true
            cell.messageTxtView.textColor = .black
            cell.messageTxtView.font = UIFont(name: "ContinuumMedium", size: 14) ?? UIFont.systemFont(ofSize: 14)
            
            if message.userUID == UserSelected.sharedInstance.getUser().key{
                cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                cell.userNameLbl.backgroundColor = .white
                cell.userNameLbl.textColor = .black
                cell.userNameLbl.textAlignment = .right
                cell.messageTxtView.textAlignment = .right
                cell.messageeLbl.textAlignment = .right
                cell.bubbleLeadingConstraint.constant = 100
                cell.bubbleTrailingConstraint.constant = 8
                cell.receivedTriangle.isHidden = true
                cell.sendedTriangle.isHidden = false
                let triangle = TriangleSended(frame: CGRect(x: 0, y: 0, width: cell.sendedTriangle.frame.width , height: 10))
                triangle.backgroundColor = .clear
                cell.sendedTriangle.addSubview(triangle)
            }else{
                cell.bubbleView.backgroundColor =  FBChatConfiguration().backGroundColor
                cell.userNameLbl.backgroundColor = .white
                cell.userNameLbl.textColor = .white
                cell.userNameLbl.textAlignment = .left
                cell.messageTxtView.textAlignment = .left
                cell.messageeLbl.textAlignment = .left
                cell.bubbleLeadingConstraint.constant = 8
                cell.bubbleTrailingConstraint.constant = 100
                cell.receivedTriangle.isHidden = false
                cell.sendedTriangle.isHidden = true
                let triangle = TriangleRecived(frame: CGRect(x: 0, y: 0, width: cell.receivedTriangle.frame.width , height: 10))
                triangle.backgroundColor = .clear
                cell.receivedTriangle.addSubview(triangle)
                
                if (colorDic.object(forKey: message.userUID) != nil){
                    let color = colorDic.object(forKey: message.userUID) as! UIColor
                    cell.userNameLbl.textColor = color
                }else{
                    var color = UIColor.random()
                    if (colorOptions.count > 0){
                        color = colorOptions.popLast()!
                    }
                    colorDic.setValue(color, forKey: message.userUID)
                    cell.userNameLbl.textColor = color
                }
            }
            
            cell.userNameLbl.layer.cornerRadius = 5
            cell.userNameLbl.layer.masksToBounds = true
            if #available(iOS 11.0, *) {
                cell.userNameLbl.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            }
            cell.userNameLbl.text = "   \(message.userName) - \(message.timeStamp.getDateByOffset().getTimeWithDDMMMYYYHHmmFormat())   "
            cell.messageTxtView.text = message.message
            cell.messageeLbl.text = message.message
            cell.messageTxtView.isUserInteractionEnabled = true
            cell.playThumbView.isHidden = true
            cell.audioDurationLbl.isHidden = true
            if message.messageType == messagePerType.image.rawValue{
                let url = URL(string: message.imageURL.replacingOccurrences(of: " ", with: "%20"))
                cell.imageSended.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-Descargando"))
                cell.imageSended.isHidden = false
                cell.messageeLbl.text = "\n\n\n\n\n"
                cell.messageTxtView.text = ""
                cell.messageTxtView.isUserInteractionEnabled = false
                cell.playThumbView.isHidden = true
            }else{
                cell.imageSended.image = nil
                cell.imageSended.isHidden = true
            }
            if message.messageType == messagePerType.file.rawValue{
                let fileExt = String(message.imageURL.split(separator: ".").last!)
                switch fileExt {
                case "xls","xlsx","xlsm","xltx","xltm":
                    cell.imageSended.image = #imageLiteral(resourceName: "excelThumb")
                    break
                case "docx","docm","dotx","doc","dotm","docb":
                    cell.imageSended.image = #imageLiteral(resourceName: "docxThumb")
                    break
                case "pdf":
                    cell.imageSended.image = #imageLiteral(resourceName: "pdfThumb")
                    break
                default:
                    cell.imageSended.image = #imageLiteral(resourceName: "ic_insert_drive_file_3x")
                    break
                }
                let fileName = String(message.imageURL.split(separator: "/").last!)
                cell.imageSended.isHidden = false
                cell.messageeLbl.text = "\n\n\n\n\n"
                cell.messageTxtView.textAlignment = .center
                cell.messageTxtView.text = cell.messageeLbl.text!+"\n"+fileName
                cell.messageTxtView.isUserInteractionEnabled = false
                cell.playThumbView.isHidden = true
            }
            if message.messageType == messagePerType.cotizacion.rawValue{
                cell.messageTxtView.isUserInteractionEnabled = false
                cell.playThumbView.isHidden = true
            }
            if message.messageType == messagePerType.video.rawValue{
                
                cell.imageSended.contentMode = .scaleAspectFit
                cell.imageSended.isHidden = false
                cell.playThumbView.isHidden = false
                cell.messageeLbl.text = "\n\n\n\n\n"
                cell.messageTxtView.text = ""
                cell.messageTxtView.isUserInteractionEnabled = false
                
                if(self.verifyLocalVideo(fromMessage: message)){
                    cell.playThumbView.image = #imageLiteral(resourceName: "play_icon")
                    cell.imageSended.contentMode = .scaleAspectFit
                    cell.imageSended.image = self.createThumbnail(fromMessage: message)
                }else{
                    if(self.dowloadingVideoIndex == indexPath.row){
                        cell.imageSended.image = #imageLiteral(resourceName: "download_icon")
                        cell.imageSended.contentMode = .scaleAspectFit
                        cell.playThumbView.isHidden = true
                        cell.progressDowloadView.isHidden = false
                        cell.progressDowloadView.setProgress(Float(self.downloadProgressValue), animated: true)
                        //cell.downloadingIndicator.startAnimating()
                        //cell.progressDowloadView.setProgress(0.0, animated: true)
                        //cell.downloadingIndicator.startAnimating()
                    }else{
                        cell.imageSended.image = #imageLiteral(resourceName: "download_icon")
                        cell.imageSended.contentMode = .scaleAspectFit
                        cell.playThumbView.image = #imageLiteral(resourceName: "download_icon")
                    }
                }
                
            }
            if message.messageType == messagePerType.audio.rawValue{
                cell.audioDurationLbl.isHidden = false
                cell.playThumbView.isHidden = true
                cell.messageeLbl.text = "\n\n\n\n"
                cell.messageTxtView.text = ""
                cell.messageTxtView.isUserInteractionEnabled = false
                cell.voiceNoteView.isHidden = false
                cell.playAudioButton.tag = indexPath.row
                cell.audioDurationLbl.text = self.getTimeFromSeconds(recordingTime: message.recordingTime)
                cell.playAudioButton.addTarget(self, action: #selector(self.verifyAudio(sender:)), for: .touchUpInside)
                cell.progresSlider.tag = indexPath.row
                cell.progresSlider.maximumValue = Float(message.recordingTime)
                cell.progresSlider.value = 0.0
            }
        let heightConstraint = NSLayoutConstraint(item: cell.imageSended, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
            cell.imageSended.addConstraint(heightConstraint)
            if isPinSelected{
                cell.messageTxtView.isSelectable = false
                cell.messageTxtView.isUserInteractionEnabled = false
            }else{
                cell.messageTxtView.isSelectable = true
            }
            cell.layoutIfNeeded()
            self.view.layoutIfNeeded()
            return cell
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!favIsActive){
            tableView.deselectRow(at: indexPath, animated: false)
        }else{
            return
        }
        if isPinSelected{
            isPinSelected = false
            self.selectFeatureMessageFrom(index: indexPath.row)
            pinSelectionBtn.backgroundColor = UIColor.clear
            self.chatTblView.reloadData()
            return
        }
        var showAlert = false
        let message = self.messageList[indexPath.row] as! Message
        let alertController = UIAlertController(title: "Que acción deseas realizar", message: "Selecciona la opción de tu preferencia", preferredStyle: .actionSheet)
        
        if message.deleted{
            return
        }
        
        if message.messageType == messagePerType.audio.rawValue{
            
        }
        if message.messageType == messagePerType.video.rawValue{
            if  message.imageURL != ""{
                
                if(self.verifyLocalVideo(fromMessage: message)){
                    self.playDowloadedVideo(fromMessage: message)
                }else{
                    if(dowloadingVideoIndex != -10){
                        let alertController = UIAlertController(title: "Alerta", message: "Se esta descargando un video actualmente.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        dowloadingVideoIndex = indexPath.row
                        
                        self.downloadVideo(fromMessage: message)
                    }
                }
                
            }else{
                MessageObject.sharedInstance.showMessage("No se encontro archivo referenciado", title: "Error", okMessage: "Aceptar")
            }
        }
        if message.messageType == messagePerType.image.rawValue {
            let seeImage = UIAlertAction(title: "Ver imagen", style: .default, handler:  { (action:UIAlertAction!) -> Void in
                let imageViewer = ImageViewerViewController()
                imageViewer.urlToImage = message.imageURL
                imageViewer.titleView = message.userName
                self.navigationController?.pushViewController(imageViewer, animated: true)
            })
            alertController.addAction(seeImage)
            showAlert = true
        }
        if message.messageType == messagePerType.file.rawValue {
            let seeFile = UIAlertAction(title: "Ver archivo", style: .default, handler:  { (action:UIAlertAction!) -> Void in
                guard let url = URL(string: message.imageURL) else {
                    return
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            })
            alertController.addAction(seeFile)
            showAlert = true
        }
        
        alertController.addAction( UIAlertAction(title: "Cancelar", style: .default, handler: { (action:UIAlertAction!) -> Void in}))
        
        if showAlert{
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if(self.messageList.count > 2 && self.needMoveToBottom){
                let indexPath = IndexPath(row: self.messageList.count-1, section: 0)
                self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }else{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.chatTblView)
            if let indexPath = chatTblView.indexPathForRow(at: touchPoint) {
                
                let alertController = UIAlertController(title: "Que acción deseas realizar", message: "Selecciona la opción de tu preferencia", preferredStyle: .actionSheet)
                
                let replyMessageHandler = {(action:UIAlertAction!) -> Void in
                    self.isUserReply = true
                    self.replyMessage(indexpath: indexPath)
                }
                let seeContactHandler = {(action:UIAlertAction!) -> Void in
                    let message = self.messageList[indexPath.row] as! Message
                    //TODO:Contact user
                }
                let copyMessageHandler = {(action:UIAlertAction!) -> Void in
                    let message = self.messageList[indexPath.row] as! Message
                    UIPasteboard.general.string = message.message
                }
                let deleteMessageHandler = {(action:UIAlertAction!) -> Void in
                    let message = self.messageList[indexPath.row] as! Message
                    self.chatWeb.deleteMessage(chatID: self.chatID, messageID: message.key, completion: { (deleted) in
                        if deleted {
                            MessageObject.sharedInstance.showMessage("Mensaje borrado", title: "Alerta", okMessage: "Aceptar")
                            if indexPath.row == self.messageList.count-1{
                                self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID, message: "ø Este mensaje fue eliminado", time:  Date().getTimeStamp())
                            }
                        }else{
                            MessageObject.sharedInstance.showMessage("Hubo un problema al tratar de borrar el mensaje, favor de intentar mas tarde", title: "Error", okMessage: "Aceptar")
                        }
                    })
                }
                let replyMessageAction = UIAlertAction(title: "Responder mensaje", style: .default, handler: replyMessageHandler)
                let seeContactAction = UIAlertAction(title: "Ver perfil", style: .default, handler: seeContactHandler)
                let copyMessageAction = UIAlertAction(title: "Copiar mensaje", style: .default, handler: copyMessageHandler)
                let deleteMessage = UIAlertAction(title: "Borrar mensaje", style: .destructive, handler: deleteMessageHandler)
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                let message = self.messageList[indexPath.row] as! Message
                if message.deleted{
                    alertController.addAction(seeContactAction)
                } else{
                    alertController.addAction(replyMessageAction)
                    alertController.addAction(seeContactAction)
                    alertController.addAction(copyMessageAction)
                    if UserSelected.sharedInstance.getUser().typeProfile == userPerType.admin.rawValue ||
                        UserSelected.sharedInstance.getUser().key == message.userUID{
                        alertController.addAction(deleteMessage)
                    }
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }//Revisa si es una celda valida
        }//Revisa el estatus del gesto
    }//Fin del metodo
    
    func replyMessage(indexpath : IndexPath){
        messageTxtField.becomeFirstResponder()
        recordView.isHidden = true
        addFileBtn.isHidden = true
        replyView.isHidden = false
        let message = self.messageList[indexpath.row] as! Message
        userReplyLbl.text = message.userName
        messageReplyLbl.text = message.message
        mensajeContestadoId = message.key
        mensajeContestadoContenido = message.message
        sendMessageAction(self)
    }
    @objc func moveToRepliedMessage(sender:UIButton){
        
        chatTblView.scrollToRow(at: IndexPath(row: sender.tag, section: 0), at: .middle, animated: true)
    }
    
    func addFavorite(){
        let totalFavs = (selectedFavs.count+self.featuredMessages.count)
        if(totalFavs < totalFavoriteMessages){
            favIsActive = true
            selectedFavs = []
            self.chatTblView.setEditing(true, animated: true)
        }else{
            MessageObject.sharedInstance.showMessage("Solo puedes seleccionar \(self.totalFavoriteMessages) mensajes", title: "Error", okMessage: "Aceptar")
        }
        
    }
    
    func selectFeatureMessageFrom(index:Int){
        let message = self.messageList[index] as! Message
        let response = self.chatWeb.saveFeaturedMessage(message.key, inChat: self.chatID)
        if(response.count > 0){
            MessageObject.sharedInstance.showMessage("Mensaje guardado", title: "Exito", okMessage: "Aceptar")
            self.chatTblView.reloadData()
        }else{
            MessageObject.sharedInstance.showMessage("Error al guardar tu mensaje", title: "Error", okMessage: "Aceptar")
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if favIsActive{
            if(selectedFavs.contains(indexPath.row)){
                selectedFavs.remove(at: selectedFavs.index(of: indexPath.row)!)
                return true
            }
            
            let totalFavs = (selectedFavs.count+self.featuredMessages.count)
            if(totalFavs < totalFavoriteMessages){
                addFileBtn.setImage(UIImage(named: "ic_tick_white_48pt"), for: .normal)
                selectedFavs.append(indexPath.row)
                return true
            }else{
                MessageObject.sharedInstance.showMessage("Solo puedes seleccionar \(self.totalFavoriteMessages) mensajes", title: "Error", okMessage: "Aceptar")
                return false
            }
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.chatTblView == scrollView{
            if scrollView.contentOffset.y < 0{
                if(!isLoadingData){
                    isLoadingData = true
                    self.loadMessages()
                }
            }
        }
    }

}

extension ChatRoomViewController: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
}

//MARK: Video Manager
extension ChatRoomViewController{
    
    func verifyLocalVideo(fromMessage:Message!) -> Bool{
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let videoFileURL = dirPaths[0].appendingPathComponent("name\(fromMessage.key)\(fromMessage.timeStamp).mp4")
        
        if fileMgr.fileExists(atPath: videoFileURL.path){
            print(" Video for \(fromMessage.key) available!")
            return true
        }else{
            print(" Video for \(fromMessage.key) not available!")
        }
        return false
        
    }
    
    func createThumbnail(fromMessage:Message!) -> UIImage{
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let videoFileURL = dirPaths[0].appendingPathComponent("name\(fromMessage.key)\(fromMessage.timeStamp).mp4")
        
        return getPreviewImage(videoFileURL: videoFileURL)
    }
    
    func getPreviewImage(videoFileURL:URL) -> UIImage{
        let asset: AVAsset = AVAsset(url: videoFileURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do{
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return #imageLiteral(resourceName: "download_icon")
        
    }
    
    func playDowloadedVideo(fromMessage:Message!){
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let videoFileURL = dirPaths[0].appendingPathComponent("name\(fromMessage.key)\(fromMessage.timeStamp).mp4")
        
        //Set Audio to Speakers Mode
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        //Play local audio File
        videoPlayer = AVPlayer(url: videoFileURL )
        let playerController = AVPlayerViewController()
        playerController.player = videoPlayer
        
        self.present(playerController, animated: true) {
            self.videoPlayer.play()
        }
        
    }
    
    func downloadVideo(fromMessage:Message!){
        
        self.chatTblView.reloadData()
        let index = (messageList as! [Message]).index(where: {$0.key == fromMessage.key})
        
        var videoFileURL_ : URL!
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileMgr = FileManager.default
            let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
            let videoFileURL = dirPaths[0].appendingPathComponent("name\(fromMessage.key)\(fromMessage.timeStamp).mp4")
            videoFileURL_ = videoFileURL
            return (videoFileURL, [.removePreviousFile])
        }
        
        Alamofire.download(fromMessage.imageURL, to:destination)
            .downloadProgress { (progress) in
                print("Video descarga en \(progress.fractionCompleted/0.01) %")
                
                if(progress.fractionCompleted > self.downloadProgressValue + 0.05){
                    self.downloadProgressValue = progress.fractionCompleted
                    self.chatTblView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .none)
                }
            }
            .responseData { (data) in
                print("Completed!")
                self.chatTblView.reloadData()
                self.dowloadingVideoIndex = -10
                self.downloadProgressValue = 0.0
                //Play local audio File
                if videoFileURL_ != nil{
                    self.videoPlayer = AVPlayer(url: videoFileURL_ )
                    let playerController = AVPlayerViewController()
                    playerController.player = self.videoPlayer
                    self.present(playerController, animated: true) {
                        self.videoPlayer.play()
                    }
                }else{
                    MessageObject.sharedInstance.showMessage("Hubo un problema al descargar el video, favor de intentar mas tarde", title: "Error", okMessage: "Aceptar")
                }
                
        }
        
    }
    
}

//MARK: Audio Manager
extension ChatRoomViewController : RecordViewDelegate, AVAudioPlayerDelegate{
    
    func RecordViewDidSelectRecord(_ sender: RecordView, button: UIView) {
        playSound(.startRecord)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        if audioPayer != nil && audioPayer.isPlaying {
            audioPayer.stop()
        }
        sender.state = .recording
        sender.audioRecorder?.record()
        print("Began " + NSUUID().uuidString)
        sender.expandView()
    }
    
    func RecordViewDidStopRecord(_ sender: RecordView, button: UIView) {
        
        sender.state = .none
        
        let audioData = try! Data(contentsOf: RecordView.getFileURL(), options: [])
        
        let webServicesImg = WebImageServices()
        let miliseconds = Int(recordView.recordMiliSeconds+(recordView.recordSeconds*1000)+(recordView.recordMinutes*60000))
        if miliseconds > 2000{
            playSound(.endRecord)
            webServicesImg.upload(fileData: audioData,
                                  fileName: "\(Date().getTimeStamp())FBFirebaseChat.m4a",
                mimeType: "audio/x-m4a",  parameters: [:],
                onCompletion: { (response) in
                    print(response)
                    self.chatWeb.sendImageTo(chatId: self.chatID, imageDir: response, userName: UserSelected.sharedInstance.getUser().name, senderId: UserSelected.sharedInstance.getUser().key, time: Date().getTimeStamp(), messageType: messagePerType.audio.rawValue, message: "",recordingTime:miliseconds)
                    self.needMoveToBottom = true
                    self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID, message: "Audio recibido", time:  Date().getTimeStamp())
                    sender.collapseView()
            }, onError: { (error) in
                print(error)
                
                sender.collapseView()
                self.playSound(.stopRecord)
            })
            
        }else{
            self.playSound(.stopRecord)
        }
        sender.collapseView()
        print("Done")
    }
    
    func RecordViewDidCancelRecord(_ sender: RecordView, button: UIView) {
        
        sender.state = .none
        recordView.audioRecorder?.stop()
        sender.collapseView()
        print("Cancelled")
        playSound(.stopRecord)
        
    }
    func getTimeFromSeconds(recordingTime:Int) -> String{
        let seconds = Double(recordingTime)/1000
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        if seconds > 60{
            formatter.dateFormat = "mm:ss"
        }else{
            formatter.dateFormat = "ss:SS"
        }
        return formatter.string(from: date)
    }
    @objc func verifyAudio(sender:UIButton){
        var otherAudio = false
        
        if videoPlayer != nil{
            videoPlayer.pause()
            videoPlayer = nil
        }
        
        if sender != refAudioButton && refAudioButton != nil{
            otherAudio = true
            refAudioButton.setImage(UIImage(named: "ic_play_audio"), for: .normal)
        }
        refAudioButton = sender
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        if(audioPayer != nil && remainingSeconds != 0.0 && audioPayer.isPlaying == true && !otherAudio){
            audioPayer.pause()
            refAudioButton.setImage(UIImage(named: "ic_play_audio"), for: .normal)
            return
        }else{
            if(audioPayer != nil && remainingSeconds != 0.0 && !otherAudio){
                audioPayer.play()
                refAudioButton.setImage(UIImage(named: "ic_pause_audio"), for: .normal)
                return
            }
        }
        
        let message = self.messageList[sender.tag] as! Message
        let messageID = message.key
        if sliderReference != nil {
            sliderReference.value = 0.0
            remainingSeconds = 0.0
            if timerSlider != nil{
                timerSlider.invalidate()
            }
        }
        let cell = self.chatTblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MessageTableViewCell
        sliderReference = cell.progresSlider
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("name\(messageID)\(message.timeStamp).m4a")
        
        let url = soundFileURL
        
        let audioURL = url
        do {
            remainingSeconds = 0.0
            audioPayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPayer.delegate = self
            timerSlider = Timer.scheduledTimer(timeInterval: 0.0013, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            refAudioButton.setImage(UIImage(named: "ic_pause_audio"), for: .normal)
            audioPayer.play()
            
        }catch _{
            if message.imageURL == ""{
                MessageObject.sharedInstance.showMessage("Error al obtener el audio", title: "Favor de intentar mas tarde", okMessage: "Aceptar")
            }else{
                self.load(url: URL(string: message.imageURL)! , to: url, completion: {
                    do {
                        self.remainingSeconds = 0.0
                        self.audioPayer = try AVAudioPlayer(contentsOf: url)
                        self.audioPayer.delegate = self
                        DispatchQueue.main.async {
                            self.timerSlider = Timer.scheduledTimer(timeInterval: 0.0013, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                        }
                        self.refAudioButton.setImage(UIImage(named: "ic_pause_audio"), for: .normal)
                        self.audioPayer.play()
                    } catch let error {print(error.localizedDescription)}
                })
            }
        }
    }
    
    @objc func updateTime(_ timer: Timer) {
        if audioPayer.isPlaying{
            remainingSeconds+=1
            if (Float(remainingSeconds) == sliderReference.maximumValue) {
                timerSlider.invalidate()
                remainingSeconds = 0.0
                audioPayer = nil
                refAudioButton.setImage(UIImage(named: "ic_play_audio"), for: .normal)
            }
            sliderReference.value = Float(remainingSeconds)
        }
    }
    
    func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription ?? "Error");
            }
        }
        task.resume()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timerSlider.invalidate()
        remainingSeconds = 0.0
        audioPayer = nil
        sliderReference.value = 0.0
        refAudioButton.setImage(UIImage(named: "ic_play_audio"), for: .normal)
    }
    
    func playSound(_ sound: soundType) {
        AudioServicesPlayAlertSound(SystemSoundID(1112))
    }
    
}

//
//extension ChatRoomViewController: NohanaImagePickerControllerDelegate {
//
//    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
//        print("🐷Canceled🙅")
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts :[PHAsset]) {
//        print("🐷Completed🙆\n\tpickedAssets = \(pickedAssts)")
//        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere un momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: FBChatConfiguration().GrayAlpha, textColor: .white)
//        var countImgs = 0
//        for imgAsset in pickedAssts{
//            if imgAsset.mediaType == .image{
//                PHImageManager.default().requestImageData(for: imgAsset, options: nil) { (dataAsset, stringAsset, orientationImg, _) in
//                    let timeStamp = TimeFunctions()
//                    let webServicesImg = WebImageServices()
//                    var fileName = stringAsset != nil ? stringAsset: "FBFirebaseChat.jpeg"
//                    var dataFile = dataAsset
//                    if (fileName?.contains(".heic"))!{
//                        dataFile = UIImageJPEGRepresentation(UIImage(data: dataAsset!)!, 0.5)
//                        fileName = "FBFirebaseChat.jpeg"
//                    }
//                    webServicesImg.upload(fileData: dataFile,
//                                          fileName: "\(timeStamp.getTimeStamp())\(countImgs)\(fileName!)",
//                        mimeType: "image/jpeg",  parameters: [:],
//                        onCompletion: { (response) in
//                            countImgs = countImgs + 1
//
//                            self.chatWeb.sendImageTo(chatId: self.chatID,
//                                                     imageDir: response,
//                                                     userName: UserSelected.sharedInstance.getUser().name,
//                                                     senderId: UserSelected.sharedInstance.getUser().key,
//                                                     time: timeStamp.getTimeStamp())
//                            self.chatWeb.updateChatRoomPreviewWith(chatroomID: self.chatID,
//                                                                   message: "Imagen recibida",
//                                                                   time:  timeStamp.getTimeStamp())
//                            self.sendPushWithMessage("Imagen recibida")
//                            self.needMoveToBottom = true
//                            if countImgs >= pickedAssts.count{
//                                self.stopAnimating()
//                            }else{
//                                print("Continuamos subiendo, faltan \(pickedAssts.count - countImgs)")
//                            }
//                    }, onError: { (error) in
//                        countImgs = countImgs + 1
//                        if countImgs >= pickedAssts.count{
//                            self.stopAnimating()
//                        }else{
//                            print("Error pero continuamos subiendo, faltan \(pickedAssts.count - countImgs)")
//                        }
//                        MessageObject.sharedInstance.showMessage("Error al subir la imagen, favor de intentar mas tarde", title: "Error", accept: "Aceptar")
//                    })
//                }
//            }
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
