//
//  MessageService.swift
//  Smack
//
//  Created by Massimiliano Abeli on 13/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    // Using decodable
    // var channelDecodable = [ChannelDecodable]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
//                // Done with Decodable
//                do {
//                    self.channelDecodable = try JSONDecoder().decode([ChannelDecodable].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
//
//                print(self.channelDecodable)
//
//                completion(true)
                
                // JSON DECODE WITH SWIFTYJSON, you can ignore properties from the response
                if let json = JSON(data).array {
                    for item in json {
                        let channel = Channel(id: item["_id"].stringValue, channelTitle: item["name"].stringValue, channelDescritpion: item["description"].stringValue)
                        self.channels.append(channel)
                    }
                    completion(true)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
