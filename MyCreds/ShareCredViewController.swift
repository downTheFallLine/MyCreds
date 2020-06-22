//
//  ShareCredViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/19/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class ShareCredViewController : UIViewController {
    var de = DIDEngine.shared
    
    var name: String? = ""
    var jwc: String? = ""
    var relyingParty: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        credentialName.text = name
    }

   

    @IBAction func doneHit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var credentialName: UILabel!
    
    @IBAction func qrHit(_ sender: Any) {
    
        de.addHistory(relyingParty: relyingParty ??  "unknown", title: name ??  "unknown", date: getCurrentShortDate())
        
        if let vc = storyboard?.instantiateViewController(identifier: "qrCred") as? QRCodeCredViewController {
                vc.name = self.name!
                vc.jwc = self.jwc!
                self.present(vc, animated:true, completion:nil)
            }
        
        
    } 

    private func getCurrentShortDate() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    
    @IBAction func emailHit(_ sender: Any) {
    }

}
