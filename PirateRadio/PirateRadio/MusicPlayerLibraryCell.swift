//
//  MusicPlayerLibraryCell.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import UIKit

class MusicPlayerLibraryCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
