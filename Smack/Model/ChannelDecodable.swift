//
//  ChannelDecodable.swift
//  Smack
//
//  Created by Massimiliano Abeli on 13/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import Foundation

struct ChannelDecodable: Decodable { // Decodable protocol, must include all the key from
                                     // the response, if there's no match it throws an error
    
    public private(set) var _id: String!
    public private(set) var name: String!
    public private(set) var description: String!
    public private(set) var __v: Int?
    
}
