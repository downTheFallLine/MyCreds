//
//  QRCodeCredViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/19/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class QRCodeCredViewController: UIViewController {
    var de = DIDEngine.shared
    
    var name: String = ""
    var jwc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        credTitle.text = name
        qrCode.image = de.generateQRCode(from: jwc)
       
    }

    @IBOutlet weak var credTitle: UILabel!
    
    @IBOutlet weak var qrCode: UIImageView!
    
    @IBAction func doneHit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
