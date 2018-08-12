//
//  LoginVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 24/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, emailTxt.text != nil else {
            return
        }
        
        guard let password = passwordTxt.text, passwordTxt.text != nil else {
            return
        }
        
        AuthService.instance.login(email: email, password: password) { (success) in
            if success {
                print("login success")
                // NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
}
