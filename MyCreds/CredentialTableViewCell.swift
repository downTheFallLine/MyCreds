//
//  CredentialTableViewCell.swift
//  MyCreds
//
//  Created by tom danner on 6/17/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class CredentialTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        date.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        date.textColor = UIColor.systemGray2
        
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        title.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var issuedBy: UILabel!
    @IBOutlet weak var date: UILabel!
    
}
