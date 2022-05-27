//
//  MusicPlayerLibraryTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import UIKit

class MusicPlayerLibraryTableViewController: UITableViewController {
    
    private let menuItems: [MusicPlayerLibraryMenuItem] = [MusicPlayerLibraryMenuItem(name: "Playlists", iconImageFilename: Constants.MUSIC_PLAYER_LIBRARY_PLAYLISTS_ICON_FILENAME), MusicPlayerLibraryMenuItem(name: "Artists", iconImageFilename: "music_artists_black_24pt"), MusicPlayerLibraryMenuItem(name: "Songs", iconImageFilename: "music_songs_black_24pt")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUserInteractionEnabled = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicPlayerLibraryCell", for: indexPath) as! MusicPlayerLibraryCell

        let menuItem = menuItems[indexPath.row]
                
        cell.menuNameLabel.text = menuItem.name
        cell.iconImageView.image = UIImage(named: menuItem.iconImageFilename)
        cell.accessoryType = .disclosureIndicator
        // Configure the cell...

        return cell
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
