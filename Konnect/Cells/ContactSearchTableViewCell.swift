//
//  ContactSearchTableViewCell.swift
//  Konnect
//
//  Created by Philip Yu on 4/14/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class ContactSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sendRequestButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
