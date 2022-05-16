//
//  SearchResultCell.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 12.05.22.
//

import UIKit

protocol SearchResultCellDelegate : AnyObject {
    func presentVideoPlayerVC(videoId: String)
}

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var videoIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    weak var delegate: SearchResultCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onPlayButtonPress(_ sender: Any) {
        print("Play button pressed")
        if let videoId =  videoIDLabel.text {
            self.delegate?.presentVideoPlayerVC(videoId: videoId)
        }
    }
}
