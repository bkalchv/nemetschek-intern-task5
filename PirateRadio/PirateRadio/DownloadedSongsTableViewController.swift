//
//  DownloadedSongsTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import UIKit
import AVFAudio
import RealmSwift

protocol SongPlayerDelegate: AnyObject {
    func play(song: Song)
}

class DownloadedSongsTableViewController: UITableViewController, SongsDataSourceDelegate {
    
    internal var songs: [Song] = []
    weak var songPlayerDelegate: SongPlayerDelegate?
    
    private func updateTableData() {
        songs = DownloadedMP3sFileReader.downloadedSongsSortedByDateOfCreation()
    }
    
    private func updateTableDataFromDataBase() {
        if let downloadedSongs = RealmWrapper.allDownloadedSongs() {
            songs = Array(downloadedSongs)
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableDataFromDataBase()
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishDownload(notification:)), name: .DidFinishDownloadingMP3File, object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func didFinishDownload(notification: Notification) {
        updateTableDataFromDataBase()
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        // Configure the cell...
        let song = songs[indexPath.row]
        
        cell.songTitleLabel.text = song.title
        cell.songDurationLabel.text = song.duration
        cell.songArtistLabel.text = song.artist
        
        if !song.albumArtworkFilename.isEmpty {
            let albumArtworkImage = UIImage(contentsOfFile: Constants.ALBUM_ARTWORK_DIRECTORY_URL.appendingPathComponent(song.albumArtworkFilename).path)
            cell.songAlbumArtworkImage.image = albumArtworkImage
        } else {
            let noArtworkImage = UIImage(named: Constants.NO_ALBUM_ART_FILENAME)
            cell.songAlbumArtworkImage.image = noArtworkImage
        }        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Downloaded MP3s"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songPlayerDelegate?.play(song: self.songs[indexPath.row])
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
