//
//  HistoryViewController.swift
//  MyCreds
//
//  Created by tom danner on 6/17/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {

    private var de = DIDEngine.shared
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
    }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return de.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellReuseIdentifier") as! HistoryTableViewCell
        let history = de.historyList
        cell.date.text = history[indexPath.row].date
        cell.sharedParty.text = history[indexPath.row].relyingParty
        cell.credentialTitle.text = history[indexPath.row].title
        
              
        
        return cell
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 115.0;//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
                
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
        alertController.addAction(alertAction)
                
        present(alertController, animated: true, completion: nil)
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.rowHeight = 100.0

      
        
        historyTableView.dataSource = self
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        titleLabel.textColor = UIColor.blue
        historyTableView.reloadData()
    }
    
    @IBOutlet weak var historyTableView: UITableView!
    

    @IBOutlet weak var titleLabel: UILabel!
}
