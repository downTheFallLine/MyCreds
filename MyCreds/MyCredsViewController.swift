//
//  MyCredsViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/17/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class MyCredsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var de = DIDEngine.shared
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return de.walletVisualization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! CredentialTableViewCell
       
        let wvi = de.walletVisualization[indexPath.row]
        cell.title.text = wvi.title
        cell.date.text = wvi.date
        cell.issuedBy.text = wvi.issuer
        /*
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.lightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "sharedCred") as? ShareCredViewController {
            let wvi = de.walletVisualization[indexPath.row]
            vc.name = wvi.title
            vc.relyingParty = "Gringotts Bank"
            self.present(vc, animated:true, completion:nil)
        }
    }
   
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0;//Choose your custom row height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        credsTableView.delegate = self
        credsTableView.dataSource = self
        //self.credsTableView.rowHeight = 40.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCredentials.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        myCredentials.textColor = UIColor.blue
        credsTableView.reloadData()
    }
    
     
    @IBOutlet weak var credsTableView: UITableView!
    
    @IBOutlet weak var myCredentials: UILabel!
}
