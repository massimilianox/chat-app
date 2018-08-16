//
//  MessageCell.swift
//  Smack
//
//  Created by Massimiliano Abeli on 16/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) {
        avatarImg.image = UIImage(named: message.userAvatar)
        avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: message.userAvatarColor)
        messageBody.text = message.messagebody
        userNameLbl.text = message.userName
        timeStampLbl.text = message.timeStamp
    }

}
