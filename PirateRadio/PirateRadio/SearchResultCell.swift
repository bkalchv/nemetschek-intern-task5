//
//  SearchResultCell.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 12.05.22.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var videoIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadThumbnail(withVideoID videoID: String) {
        let thumbnailFilename = "\(videoID)_thumbnail.jpg"
        let thumbnailURL = Constants.thumbnailsDirectoryURL.appendingPathComponent(thumbnailFilename)
        do {
            let thumbnailData = try Data(contentsOf: thumbnailURL)
            thumbnailImage.image = UIImage(data: thumbnailData)
        } catch {
            print(error)
        }
    }

}
