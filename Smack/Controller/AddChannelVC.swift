//
//  AddChannelVC.swift
//  Smack
//
//  Created by Massimiliano Abeli on 13/08/2018.
//  Copyright © 2018 Massimiliano Abeli. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var channelTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    private var isEditingWinOut: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Notify the editing software keyboard on - off
        NotificationCenter.default.addObserver(self, selector: #selector(AddChannelVC.editingIsTrue), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddChannelVC.editingIsFalse), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
        guard channelTxt.text != nil && channelTxt.text != "" else { return }
        guard descriptionTxt.text != nil && descriptionTxt.text != "" else { return }
        
        SocketService.instance.addChannel(channelName: channelTxt.text!, channelDescription: descriptionTxt.text!) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        channelTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: ColorFormPlaceholer])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: ColorFormPlaceholer])
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func editingIsTrue() {
        isEditingWinOut = true
    }
    
    @objc func editingIsFalse() {
        isEditingWinOut = false
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        if isEditingWinOut {
            view.endEditing(true);
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
