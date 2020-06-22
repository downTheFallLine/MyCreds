//
//  HistoryTableViewCell.swift
//  MyCreds
//
//  Created by tom danner on 6/17/20.
//  Copyright © 2020 tom danner. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        date.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        date.textColor = UIColor.systemGray2
        
        sharedParty.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        sharedParty.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var credentialTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var sharedParty: UILabel!
}
