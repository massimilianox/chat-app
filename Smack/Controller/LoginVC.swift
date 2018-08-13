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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        spinner.isHidden = true
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smakFormPlaceholer])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smakFormPlaceholer])
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else {
            return
        }
        
        guard let password = passwordTxt.text, passwordTxt.text != "" else {
            return
        }
        
        AuthService.instance.login(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                    }
                })
            }
        }
    }
}
