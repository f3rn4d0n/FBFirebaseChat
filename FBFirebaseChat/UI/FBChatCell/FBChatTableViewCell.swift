//
//  UserTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 24/01/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

public class FBChatTableViewCell: GenericCell<Chatroom> {
    
    override public var item: Chatroom! {
        didSet {
            nameLabel.text = item.owner
            detailLabel.text = item.lastMessage
            redPointView.isHidden = !item.newContent
        }
    }
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        return nameLabel
    }()
    let detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = .white
        return detailLabel
    }()
    let chatImage: UIImageView = {
        let chatImg = UIImageView()
        chatImg.image = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "ic_generic_person"))
        chatImg.contentMode = .scaleToFill
        return chatImg
    }()
    lazy var redPointView: UIView = {
        let redView = UIView()
        redView.backgroundColor = .red
        redView.layer.masksToBounds = true
        return redView
    }()
    let backgroundCoverView: UIView = {
        let background = UIView()
        background.backgroundColor = .gray
        return background
    }()
    
    override public func setupViews() {
        super.setupViews()
        addSubview(backgroundCoverView)
        
        backgroundCoverView.fillSuperview(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        
        backgroundCoverView.addSubview(chatImage)
        chatImage.anchor(top: backgroundCoverView.topAnchor,
                         leading: backgroundCoverView.leadingAnchor,
                         bottom: backgroundCoverView.bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 16, left: 8, bottom: 16, right: 0))
        chatImage.widthAnchor.constraint(equalTo: chatImage.heightAnchor).isActive = true
        
        backgroundCoverView.addSubview(nameLabel)
        nameLabel.anchor(top: chatImage.topAnchor,
                         leading: chatImage.trailingAnchor,
                         bottom: nil,
                         trailing: backgroundCoverView.trailingAnchor,
                         padding: .init(top: 0, left: 8, bottom: 0, right: 20))
        
        backgroundCoverView.addSubview(detailLabel)
        detailLabel.anchor(top: nil,
                           leading: chatImage.trailingAnchor,
                           bottom: chatImage.bottomAnchor,
                           trailing: backgroundCoverView.trailingAnchor,
                           padding: .init(top: 8, left: 8, bottom: 0, right: 20))
        
        
        addSubview(redPointView)
        redPointView.anchor(top: backgroundCoverView.topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: backgroundCoverView.trailingAnchor,
                            padding: .init(top: -4, left: 0, bottom: 0, right: -4),
                            size: .init(width: 20, height: 20))
        redPointView.layer.cornerRadius = 10
    }
    
    
}
