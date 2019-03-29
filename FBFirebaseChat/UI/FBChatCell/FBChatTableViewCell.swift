//
//  UserTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 24/01/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit

class FBChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var redPoint: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
