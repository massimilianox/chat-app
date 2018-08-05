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

// segue
let TO_LOGIN = "loginVC"
let TO_CREATE_ACCOUNT = "createAccountVC"
let UNWIND_TO_CHANNEL = "unwindToChannel"

// user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedInKey"
let USER_EMAIL = "userEmail"
