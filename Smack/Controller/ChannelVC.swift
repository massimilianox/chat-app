//
//  ChannelVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 22/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func performUnwindSegue(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var channelsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        channelsTableView.delegate = self
        channelsTableView.dataSource = self
        selectChannelRow()
        
        // set SWRevealViewController
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        
        // Listen on user data
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Listen on channels update
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannels { (success) in
            if success {
                self.channelsTableView.reloadData()
                self.selectChannelRow()
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id {
                MessageService.instance.foreignMessages.append(newMessage.channelId)
                self.channelsTableView.reloadData()
                self.selectChannelRow()
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channelCell = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channelCell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        MessageService.instance.clearMessages()
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        revealViewController().revealToggle(animated: true)
        
        // Check if there's any new message for the selected channel, if yes then update data and tableCell
        let newMessagesForChannelSelected = MessageService.instance.foreignMessages.contains(channel.id)
        if newMessagesForChannelSelected {
            // Update data
            MessageService.instance.foreignMessages = MessageService.instance.foreignMessages.filter({ (channelId) -> Bool in
                channelId != channel.id
            })
            // Reload cell content
            let idx = IndexPath(row: indexPath.row, section: 0)
            channelsTableView.reloadRows(at: [idx], with: .none)
            channelsTableView.selectRow(at: idx, animated: false, scrollPosition: .none)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        channelsTableView.reloadData()
        selectChannelRow()
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            avatarImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            avatarImg.image = UIImage(named: "profileDefault")
            avatarImg.backgroundColor = UIColor.clear
            channelsTableView.reloadData()
        }
    }
    
    func selectChannelRow() {
        let idx = MessageService.instance.channels.index(where: { (obj) -> Bool in
            obj.id == MessageService.instance.selectedChannel?.id
        })
        if idx != nil {
            let indexPath = IndexPath(row: idx!, section: 0)
            self.channelsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
}
