//
//  FBMessageTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 5/3/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib
import Kingfisher

class FBMessageTableViewCell: GenericCell<Message> {
    
    override public var item: Message! {
        didSet {
            
        }
    }
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        return nameLabel
    }()
    let messageLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = .white
        return detailLabel
    }()
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        return textView
    }()
    let imageSended: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "ic_generic_person"))
        img.contentMode = .scaleToFill
        return img
    }()
    let backgroundCoverView: UIView = {
        let background = UIView()
        background.backgroundColor = .gray
        return background
    }()
    let receivedTriangle: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    let sendedTriangle: UIView = {
        let background = UIView()
        background.backgroundColor = .gray
        return background
    }()
    
    override public func setupViews() {
        super.setupViews()
        addSubview(backgroundCoverView)
        
        backgroundCoverView.fillSuperview(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        
        backgroundCoverView.addSubview(imageSended)
        imageSended.anchor(top: backgroundCoverView.topAnchor,
                            leading: backgroundCoverView.leadingAnchor,
                            bottom: backgroundCoverView.bottomAnchor,
                            trailing: nil,
                            padding: .init(top: 16, left: 8, bottom: 16, right: 0))
        imageSended.widthAnchor.constraint(equalTo: imageSended.heightAnchor).isActive = true
        
        backgroundCoverView.addSubview(nameLabel)
        nameLabel.anchor(top: imageSended.topAnchor,
                         leading: imageSended.trailingAnchor,
                         bottom: nil,
                         trailing: backgroundCoverView.trailingAnchor,
                         padding: .init(top: 0, left: 8, bottom: 0, right: 20))
        
        backgroundCoverView.addSubview(messageLabel)
        messageLabel.anchor(top: nil,
                           leading: imageSended.trailingAnchor,
                           bottom: imageSended.bottomAnchor,
                           trailing: backgroundCoverView.trailingAnchor,
                           padding: .init(top: 8, left: 8, bottom: 0, right: 20))
    }
}
