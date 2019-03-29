//
//  MessageTableViewCell.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 2/1/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSended: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendedTriangle: UIView!
    @IBOutlet weak var receivedTriangle: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var messageeLbl: UILabel!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var playThumbView: UIImageView!
    @IBOutlet weak var voiceNoteView: UIView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var progresSlider: UISlider!
    @IBOutlet weak var audioDurationLbl: UILabel!
    @IBOutlet weak var downloadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressDowloadView: UIProgressView!
    
    var itemWritten = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imageSended.isUserInteractionEnabled = true
//        imageSended.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("apreto la imagen")
        
        
    }
    
}
