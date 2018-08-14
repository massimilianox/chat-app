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
    lazy var socket: SocketIOClient = manager.defaultSocket
   
    
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
            // let json = JSON(data[0])
            // let channel = Channel(id: json["id"].stringValue, channelTitle: json["name"].stringValue, channelDescritpion: json["description"].stringValue)
            
            // Parse data with plain Swift
            guard let dictionary = data[0] as? Dictionary<String, Any> else { return }
            let channel = Channel(
                id: dictionary["id"] as! String,
                channelTitle: dictionary["name"] as! String,
                channelDescritpion: dictionary["description"] as! String
            )
            
            MessageService.instance.channels.append(channel)
            
            completion(true)
        }
    }
    
}
