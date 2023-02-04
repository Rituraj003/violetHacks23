//
//  MainTableViewCell.swift
//  Chow Time
//
//  Created by Rituraj Sharma on 2/4/23.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var CenterName: UILabel!
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var availableCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
