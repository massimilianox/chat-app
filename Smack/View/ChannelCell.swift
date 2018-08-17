//
//  ChannelCellTableViewCell.swift
//  Smack
//
//  Created by Massimiliano Abeli on 13/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? ""
        channelCell.font = UIFont(name: DefaultFontRegular, size: DefaultFontSize)
        channelCell.text = "#\(title)"
        var numberOfNewMessages: Int = 0
        for id in MessageService.instance.foreignMessages {
            if id == channel.id {
                channelCell.font = UIFont(name: DefaultFontSemibold, size: DefaultFontSize)
                numberOfNewMessages += 1
                channelCell.text = "#\(title) \(String(describing: numberOfNewMessages))"
            }
        }
        
        
    }

}
