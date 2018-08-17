//
//  ChatVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 22/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var typingLbl: UILabel!
    
    var isTyping: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        sendMessageBtn.isHidden = true
        
        // Tap recognizer to close the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        // Set the action touchUpInside with #selector to SWRevealViewController.revealToggle(_:)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        // Gesture recognizer built in SWRevealViewController to swap the view back and forth
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Gesture recognizer built in SWRevealViewController to open the view at a tap
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Bound the view to the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Listen on user data update
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Listen on chennel is selected
        NotificationCenter.default.addObserver(self, selector: #selector(onChannelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        // Load user data if logged-in
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id {
                MessageService.instance.messages.append(newMessage)
                self.messagesTableView.reloadData()
                let lastMessageIdx = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                self.messagesTableView.scrollToRow(at: lastMessageIdx, at: .bottom, animated: true)
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (user, channel) in typingUsers {
                if user != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = user
                    } else {
                        names = "\(names), \(user)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingLbl.text = "\(names) \(verb) typing"
            } else {
                self.typingLbl.text = ""
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            cell.configureCell(message: MessageService.instance.messages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn && messageTxtBox.text != "" {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtBox.text else { return }
            let userId = UserDataService.instance.id
            
            SocketService.instance.addMessage(messageBody: message, userId: userId, channelId: channelId) { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                    self.isTyping = false
                    self.sendMessageBtn.isHidden = true
                }
            }
        }
    }
    
    @IBAction func messageTxtBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        if messageTxtBox.text == "" {
            if isTyping {
                sendMessageBtn.isHidden = true
                SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                isTyping = false
            }
        } else {
            if !isTyping {
                sendMessageBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
                isTyping = true
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessage()
        } else {
            titleLbl.text = "Please log in"
            self.messagesTableView.reloadData()
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
                self.messagesTableView.reloadData()
            }
        }
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.view.frame.origin.y += deltaY
        },completion: {(true) in
            self.view.layoutIfNeeded()
        })
    }

}
