//
//  MessagesListViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 5/3/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import AVFoundation
import LFBR_SwiftLib

class MessagesListViewController: GenericTableViewController<FBMessageTableViewCell, Message> {

    var chatController = MessagesController()
    var chatID = ""
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        let recordView = RecordView()
        view.addSubview(recordView)
        recordView.backgroundColor = .clear
        recordView.view.backgroundColor = .clear
        recordView.image = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "ic_send_audio"))
        recordView.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 5, right: 5),
                          size: .init(width: 40, height: 40))
        
        let sendMessage = UIButton()
        view.addSubview(sendMessage)
        
        sendMessage.setImage(UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "ic_send_white")), for: .normal)
        sendMessage.anchorEqualTo(view: recordView, atXLayout: recordView.leadingAnchor, space: -5)
        
        let sendAttachment = UIButton()
        view.addSubview(sendAttachment)
        sendAttachment.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        sendAttachment.setTitle("+", for: .normal)
        sendAttachment.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil,
                          padding: .init(top: 0, left: 0, bottom: 5, right: 0),
                          size: .init(width: 40, height: 40))
        
        let textView = UITextView()
        view.addSubview(textView)
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.anchor(top: view.topAnchor, leading: sendAttachment.trailingAnchor, bottom: view.bottomAnchor, trailing: sendMessage.leadingAnchor,
                        padding: .init(top: 5, left: 5, bottom: 5, right: 10))
        
        return view
    }()
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = footerView
        footerView.anchor(top: nil, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    
    @objc func sendMessage() {
        self.footerView.textV
    }
}
