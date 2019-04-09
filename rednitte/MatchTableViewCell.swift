//
//  MatchTableViewCell.swift
//  rednitte
//
//  Created by 板垣智也 on 2019/04/10.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell {

    var recipientObjectId = ""
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sendTapped(_ sender: Any) {
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageTextField.text
        
        message.saveInBackground()
        print("message has been sent")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
