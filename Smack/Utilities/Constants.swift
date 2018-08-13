//
//  Constants.swift
//  Smack
//
//  Created by Massimiliano Abeli on 23/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL constant
let BASE_URL = "http://localhost:3005/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADD_USER = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_CHANNELS = "\(BASE_URL)channel"

// colors
let smakFormPlaceholer = #colorLiteral(red: 0, green: 0.3632077575, blue: 0.7506918311, alpha: 0.6)

// notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChenge")

// segue
let TO_LOGIN = "loginVC"
let TO_CREATE_ACCOUNT = "createAccountVC"
let UNWIND_TO_CHANNEL = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedInKey"
let USER_EMAIL = "userEmail"

// header
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
