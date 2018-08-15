//
//  ChatVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 22/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the action touchUpInside with #selector to SWRevealViewController.revealToggle(_:)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        // Gesture recognizer built in SWRevealViewController to swap the view back and forth
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Gesture recognizer built in SWRevealViewController to open the view at a tap
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChannelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessage()
        } else {
            titleLbl.text = "Please log in"
        }
    }
    
    @objc func onChannelSelected(_ notif: Notification) {
        updateChannel()
    }
    
    func updateChannel() {
        let channelTitle = MessageService.instance.selectedChannel?.channelTitle ?? ""
        titleLbl.text = "#\(channelTitle)"
        getMessages()
    }
    
    func onLoginGetMessage() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                print("ChannelVC Channels fetched")
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateChannel()
                } else {
                    self.titleLbl.text = "No channel yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForCahnnel(channelId: channelId) { (success) in
            if success {
                print("All messages retrived")
            }
        }
    }

}
