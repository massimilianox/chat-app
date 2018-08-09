//
//  UserDataService.swift
//  Smack
//
//  Created by Massimiliano Abeli on 05/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatarName: String, avatarColor: String, email: String, name: String) {
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = avatarColor
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(component: String) -> UIColor {
        
        let scanner = Scanner(string: component)
        let skip = CharacterSet(charactersIn: "[], ")
        let split = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skip
        
        var r, g, b, a: NSString?
        scanner.scanUpToCharacters(from: split, into: &r)
        scanner.scanUpToCharacters(from: split, into: &g)
        scanner.scanUpToCharacters(from: split, into: &g)
        scanner.scanUpToCharacters(from: split, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrap = r else { return defaultColor }
        guard let gUnwrap = g else { return defaultColor }
        guard let bUnwrap = b else { return defaultColor }
        guard let aUnwrap = a else { return defaultColor }
        
        let rFloat = CGFloat(rUnwrap.doubleValue)
        let gFloat = CGFloat(gUnwrap.doubleValue)
        let bFloat = CGFloat(bUnwrap.doubleValue)
        let aFloat = CGFloat(aUnwrap.doubleValue)
        
        let newColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newColor
        
    }
    
}
