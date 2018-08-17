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
        
        // I have to substring the isodate cos of a bug in Swift ISO8601.
        // Breaks with milliseconds, you have to rip them off
        var isoDate = message.timeStamp
        let end = isoDate?.index((isoDate?.endIndex)!, offsetBy: -6)

        // isoDate = isoDate?.substring(to: end!) substring is DEPRECATED
        isoDate = String((isoDate?[...end!])!) // Use slicing instead
        
        if isoDate != nil {
            let isoFormatter = ISO8601DateFormatter()
            guard let date = isoFormatter.date(from: (isoDate?.appending("Z"))!) else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let finalDate = dateFormatter.string(from: date)
            timeStampLbl.text = finalDate
        }
    }

}
