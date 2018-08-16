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
    var messages = [Message]()
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
                        let channel = Channel(
                            id: item["_id"].stringValue,
                            channelTitle: item["name"].stringValue,
                            channelDescritpion: item["description"].stringValue
                        )
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
    
    func findAllMessagesForCahnnel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_MESSAGES_BY_CHANNEL)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                
                if let json = JSON(data).array {
                    for item in json {
                        let message = Message(
                            id: item["_id"].stringValue,
                            messagebody: item["messageBody"].stringValue,
                            userId: item["userId"].stringValue,
                            channelId: item["channelId"].stringValue,
                            userName: item["userName"].stringValue,
                            userAvatar: item["userAvatar"].stringValue,
                            userAvatarColor: item["userAvatarColor"].stringValue,
                            timeStamp: item["timeStamp"].stringValue
                        )
                        self.messages.append(message)
                    }
                    print(self.messages)
                    completion(true)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
            
        }
    }
    
    // Convert an ISODate string into a Date object
//    func formatDate(date: String) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss.SSS'Z'"
//        print("Date: \(String(describing: dateFormatter.date(from: date)))")
//        return dateFormatter.date(from: date)
//    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
