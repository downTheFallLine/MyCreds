//
//  SettingsViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/18/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var de = DIDEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        
        if (de.did != "Not Set") {
            registerButton.isEnabled = false
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        mySettingsTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        mySettingsTitle.textColor = UIColor.blue
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerHit(_ sender: Any) {
        de.register(userName: userName.text!)
        let myMessage = "You have registered with the Ministry of Magic"

        let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)

        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var mySettingsTitle: UILabel!
}
