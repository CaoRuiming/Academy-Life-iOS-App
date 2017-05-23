//
//  TopStoriesTableViewCell.swift
//  CA Life
//
//  Created by Raymond Cao on 5/18/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
    
    var cellUrl: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
