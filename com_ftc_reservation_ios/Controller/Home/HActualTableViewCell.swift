//
//  HActualTableViewCell.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/18.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class HActualTableViewCell: UITableViewCell {
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tel: UILabel!
    var xuid : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
