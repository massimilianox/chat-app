//
//  SocketService.swift
//  Smack
//
//  Created by Massimiliano Abeli on 14/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class SocketService: NSObject {

    static let instance = SocketService()
    
    // Since it is a subclass of NSObject it needs to be initilized
    override init() {
        super.init()
    }
    
    // From the lesson, doesn't works!
    // var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL))
    
    // work around
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket: SocketIOClient = manager.defaultSocket // lazy cos self is not yet available, property initializer run before self is available
   
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannels(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { data, ack in
            
            // Parse data with SwiftyJSON
//            let json = JSON(data[0])
//            let channel = Channel(
//                id: json["id"].stringValue,
//                channelTitle: json["name"].stringValue,
//                channelDescritpion: json["description"].stringValue
//            )
            
            // Parse data with plain Swift
            guard let dictionary = data[0] as? Dictionary<String, Any> else { return }
            let channel = Channel(
                id: dictionary["_id"] as? String ?? "",
                channelTitle: dictionary["name"] as? String ?? "",
                channelDescritpion: dictionary["description"] as? String ?? ""
            )
            
            MessageService.instance.channels.append(channel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (data, ack) in
            guard let dictionary = data[0] as? Dictionary<String, Any> else { return }
            if dictionary["channelId"] as? String == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                let message = Message(
                    id: dictionary["id"] as? String ?? "",
                    messagebody: dictionary["messageBody"] as? String ?? "",
                    userId: dictionary["userId"] as? String ?? "",
                    channelId: dictionary["channelId"] as? String ?? "",
                    userName: dictionary["userName"] as? String ?? "",
                    userAvatar: dictionary["userAvatar"] as? String ?? "",
                    userAvatarColor: dictionary["userAvatarColor"] as? String ?? "",
                    timeStamp: dictionary["timeStamp"] as? String ?? ""
                )
                MessageService.instance.messages.append(message)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (data, ack) in
            guard let typingUsers = data[0] as? Dictionary<String, String> else { return }
            
            completionHandler(typingUsers)
        }
    }
    
}













