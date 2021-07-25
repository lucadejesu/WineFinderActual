//
//  SearchTableViewController.swift
//  WineFinderActual
//
//  Created by luca on 7/24/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
class searchTableCell: UITableViewCell
{
    
    @IBOutlet weak var wineTitle: UILabel!
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var descriptors: UILabel!
    
}
class SearchTableViewController: UITableViewController {

    // All wines in the current dataset:
    var data: [WineReview] = []
    
    
    // Important things in the search: fine the wine by name, like a wine lookup from one
    // that was found at the store
    // Identify the descriptors and the rating, if the wine is found.
    override func viewDidLoad()
    {
        super.viewDidLoad()

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
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableCell
        
        // Outfit the top of the cell with the wine title
        cell.wineTitle.text = data[indexPath.row].title
        cell.wineTitle.adjustsFontSizeToFitWidth = true
        
        // Let the user read the full review
        let stringDescRepresentation = (data[indexPath.row].full_description)
        let trimmed = stringDescRepresentation?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.descriptors.text = trimmed
        cell.descriptors.adjustsFontSizeToFitWidth = true
    
        // Display the wine score and the critic who scored it
        let stringCritic = "Score: \(data[indexPath.row].points) (from \(data[indexPath.row].taster_name) of www.winemag.com)"
        cell.score.text = stringCritic
        cell.score.adjustsFontSizeToFitWidth = true
        
        return cell
        
        
    }
    
    // Allows the changing of the cell heights, should be the same for each row/cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 280
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
