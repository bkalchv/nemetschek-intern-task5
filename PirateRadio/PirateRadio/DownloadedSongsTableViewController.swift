//
//  DownloadedSongsTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import UIKit
import AVFAudio

protocol DownloadedSongsTableViewControllerDelegate: AnyObject {
    var player: AudioPlayer? { get }
    //func updateAudioPlayerSongs(newSongs: [Song])
}

class DownloadedSongsTableViewController: UITableViewController, MusicPlayerSongsViewControllerDelegate {
    
    internal var tableData: [Song] = []
    weak var delegate: DownloadedSongsTableViewControllerDelegate!
    
    private func updateTableData() {
        tableData = DownloadedMP3sFileReader.downloadedSongsSortedByDateOfCreation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableData()
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableData.count != DownloadedMP3sFileReader.downloadedSongsSortedByDateOfCreation().count {
            updateTableData()
            // TODO: Notify AudioPlayer that tableData has been updated, instead of delegation?
            //self.delegate.updateAudioPlayerSongs(newSongs: tableData)
            let tableDataDict:[String: [Song]] = ["tableData": tableData]
            NotificationCenter.default.post(name: .DownloadedSongsVCTableDataUpdated, object: nil, userInfo: tableDataDict)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        // Configure the cell...
        let song = tableData[indexPath.row]
        
        cell.songTitleLabel.text = song.title
        cell.songDurationLabel.text = song.duration
        cell.songArtistLabel.text = song.artist
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Downloaded MP3s"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let player = delegate.player {
            player.playSongAtIndex(index: indexPath.row)
            // TODO: Ask if that's a fine usage of notification
            NotificationCenter.default.post(name: .SongSelectedNotification, object: nil)
        }
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
