//
//  FirstWineTableViewController.swift
//  WineFinderActual
//
//  Created by luca on 6/8/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
import CoreData

// Modularize the logic of the program by using a protocol, and then extending the methods we want to create:

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// //
// When back button is pressed on the navigation bar, reset all selected attributes //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// //


func matchWines(attributes: [String], wines: [WineReview]) -> [WineReview]
{
    // Only matches go here, along with their newly added "matchPoints"
    var foundWines: [WineReview] = []
    
    
    
    return foundWines
}
    


class FirstWineTableViewController: UITableViewController
{
    var chosenAttributes: [String] = []
    let data = DataLoader().wineReviews
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Need a recommendation algorithm, based on similarity of selected atttributes and color and price
        
        var foundWines: [WineReview] = []
        
        foundWines = matchWines(attributes: chosenAttributes, wines: data)
        
        //print(data)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        // Number of rows can be the max number of wines to be presented ************
        return chosenAttributes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chicken", for: indexPath)
        // Configure the cells here
        
        
        // user selected wine attributes are held in chosenAttributes array
        // The loaded data from the JSON file is in 'data' - its an array of 1000 wine review
        // objects
        
        // example of calling a logic method from the protocol
        // matchWines(attributes: chosenAttributes, wines: data)
        
        print(data[1].description)
        
        // Configure the cell...
        cell.textLabel?.text = chosenAttributes[indexPath.row]
        print(indexPath.row)
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
