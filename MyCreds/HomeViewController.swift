//
//  HomeViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/18/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var de = DIDEngine.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLabel.text = de.did
        didQRCode.image = de.generateQRCode(from: de.did)
        
    
    }

    override func viewDidAppear(_ animated: Bool) {
        didLabel.text = de.did
        didQRCode.image = de.generateQRCode(from: de.did)
    }

    @IBOutlet weak var didLabel: UILabel!
    @IBOutlet weak var didQRCode: UIImageView!
    @IBOutlet weak var assessmentButton: UIButton!
}


