//
//  SortPopoverTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 13.06.22.
//

import UIKit

class SortMenuPopoverTableViewController: UITableViewController {
    
    private let sortMenuOptions: [String] = [SortMenuOption.title.rawValue, SortMenuOption.recentylAdded.rawValue, SortMenuOption.artist.rawValue]
    private var selectedCellIndexPath: IndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = false
        self.tableView.rowHeight = 45.0
        let height = sortMenuOptions.count * Int(tableView.rowHeight)
        self.preferredContentSize = CGSize(width: 220, height: height)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let selectedCellIndexPath = selectedCellIndexPath {
            UserDefaults.standard.set(selectedCellIndexPath.row, forKey: "SelectedSortMenuItemRow")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            self.tableView.contentInset = UIEdgeInsets(top: self.tableView.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortMenuPopoverCell", for: indexPath) as! SortMenuPopoverTableViewCell
        
        let menuOption = sortMenuOptions[indexPath.row]
        
        if selectedCellIndexPath != nil {
            if indexPath == selectedCellIndexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            //get it from userdefaults
            let prevSelectedCellIndexPath = IndexPath(row: UserDefaults.standard.integer(forKey: "SelectedSortMenuItemRow"), section: 0)
            if indexPath == prevSelectedCellIndexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }

        // Configure the cell...
        cell.menuLabel.text = menuOption
        print("\(indexPath.row):  \(cell.isSelected)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCellIndexPath = selectedCellIndexPath {
            // deselection gets rid of gray-selected animation
            tableView.deselectRow(at: indexPath, animated: true)
        
            if indexPath == selectedCellIndexPath { return }
            
            let previouslySelectedCell = tableView.cellForRow(at: selectedCellIndexPath)
            if previouslySelectedCell?.accessoryType == .checkmark {
                previouslySelectedCell?.accessoryType = .none
            }
            
            let currentlySelectedCell = tableView.cellForRow(at: indexPath)
            if currentlySelectedCell?.accessoryType == UITableViewCell.AccessoryType.none {
                currentlySelectedCell?.accessoryType = .checkmark
            }
        } else {
            tableView.reloadData()
        }
        
        selectedCellIndexPath = indexPath
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
