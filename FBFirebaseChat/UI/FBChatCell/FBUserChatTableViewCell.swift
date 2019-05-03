//
//  FBUserChatTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 5/2/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
import LFBR_SwiftLib
import Kingfisher

class FBUserChatTableViewCell: GenericCell<UserFirebase> {
    
    override public var item: UserFirebase! {
        didSet {
            nameLabel.text = item.name
            detailLabel.text = item.debugDescription
            
            guard let url = URL(string: item.photoUrl) else {
                return
            }
            profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "ic_generic_person"))
            
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
    let profileImage: UIImageView = {
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
    
    override public func setupViews() {
        super.setupViews()
        addSubview(backgroundCoverView)
        
        backgroundCoverView.fillSuperview(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        
        backgroundCoverView.addSubview(profileImage)
        profileImage.anchor(top: backgroundCoverView.topAnchor,
                         leading: backgroundCoverView.leadingAnchor,
                         bottom: backgroundCoverView.bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 16, left: 8, bottom: 16, right: 0))
        profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        
        backgroundCoverView.addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.topAnchor,
                         leading: profileImage.trailingAnchor,
                         bottom: nil,
                         trailing: backgroundCoverView.trailingAnchor,
                         padding: .init(top: 0, left: 8, bottom: 0, right: 20))
        
        backgroundCoverView.addSubview(detailLabel)
        detailLabel.anchor(top: nil,
                           leading: profileImage.trailingAnchor,
                           bottom: profileImage.bottomAnchor,
                           trailing: backgroundCoverView.trailingAnchor,
                           padding: .init(top: 8, left: 8, bottom: 0, right: 20))
    }
}
