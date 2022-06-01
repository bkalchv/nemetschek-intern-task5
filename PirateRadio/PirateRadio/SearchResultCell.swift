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

    //@IBOutlet weak var videoIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offsetFromPublishTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    weak var delegate: SearchResultCellDelegate? = nil
    var videoId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onPlayButtonPress(_ sender: Any) {
        if !videoId.isEmpty {
            self.delegate?.presentVideoPlayerVC(videoId: videoId)
        }
    }
}
