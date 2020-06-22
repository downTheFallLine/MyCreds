//
//  AssessmentViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/19/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class AssessmentViewController: UIViewController {

    var de = DIDEngine.shared
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        qrCode.image = de.generateQRCode(from: "identity vc goes here")
        
    }
    
 
    @IBAction func doneClicked(_ sender: Any) {
          self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var qrCode: UIImageView!
    /*
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    } */
}
