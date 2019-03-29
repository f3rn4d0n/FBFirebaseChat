//
//  ReplyTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Ricardo Hernandez on 23/04/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var repliedUserLbl: UILabel!
    @IBOutlet weak var repliedMessageLbl: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var sendedTriangle: UIView!
    @IBOutlet weak var receivedTriangle: UIView!
    @IBOutlet weak var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var repliedAreaBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
