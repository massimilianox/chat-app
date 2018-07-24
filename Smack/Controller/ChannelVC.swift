//
//  ChannelVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 22/07/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let loginVC = segue.destination as? UIViewController {
//           // perform some logic
//        }
//    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
}
