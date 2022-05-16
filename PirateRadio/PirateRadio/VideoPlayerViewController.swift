//
//  ViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.04.22.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var videoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
    }
    
}
