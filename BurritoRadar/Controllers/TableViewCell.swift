//
//  TableViewCell.swift
//  BurritoRadar
//
//  Created by Oliver Morland on 07/09/2019.
//  Copyright © 2019 Oliver Morland. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
