//
//  ViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.04.22.
//

import UIKit
import YouTubeiOSPlayerHelper

class ViewController: UIViewController {

    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var ytLinkTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: "H9154xIoYTA")
    }
}
