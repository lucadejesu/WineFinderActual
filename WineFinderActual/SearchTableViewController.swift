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
class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    // All wines in the current dataset:
    var data: [WineReview] = []
    // Exists, but is not initialized
    var filteredData: [WineReview]!
    
    // Adding in the next chunk of wines (used for the ML recommendations)
    var ml_data = ML_Loader().ml_Reviews
    
    
    
    
    
    // Important things in the search: fine the wine by name, like a wine lookup from one
    // that was found at the store
    // Identify the descriptors and the rating, if the wine is found.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var name_array: [String] = []
        searchBar.delegate = self
        
        // Convert the ML_review struct into WineReview stucts so we can
        // add them to the data list.
        for wine in ml_data
        {
            var current_wine = WineReview()
            
            // Dont append duplicate reviews
            if(name_array.contains(wine.title ?? " "))
            {
                continue
            }
            // Initialize the current wine with every piece of data from the "ml" wine
            current_wine.variety = wine.variety
            current_wine.taster_name = wine.taster_name
            current_wine.points = wine.points
            current_wine.winery = wine.winery
            current_wine.title = wine.title
            // We are not going to use the trimmed descriptors, so just initialize
            // full description
            current_wine.full_description = wine.full_description
            current_wine.country = wine.country
            current_wine.price = wine.price
            current_wine.color = wine.color
            
            
            name_array.append(wine.title ?? " ")
            
            data.append(current_wine)
            
        }
        
        
        
        
        
        // Initialize the filtered data variable:
        filteredData = data
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
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableCell
        
        // Outfit the top of the cell with the wine title
        cell.wineTitle.text = filteredData[indexPath.row].title
        cell.wineTitle.adjustsFontSizeToFitWidth = true
        
        // Let the user read the full review
        let stringDescRepresentation = (filteredData[indexPath.row].full_description)
        let trimmed = stringDescRepresentation?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.descriptors.text = trimmed
        cell.descriptors.adjustsFontSizeToFitWidth = true
    
        // Display the wine score and the critic who scored it
        let stringCritic = "Score: \(filteredData[indexPath.row].points) (from \(filteredData[indexPath.row].taster_name) of www.winemag.com)"
        cell.score.text = stringCritic
        cell.score.adjustsFontSizeToFitWidth = true
        
        return cell
        
        
    }
    
    // Allows the changing of the cell heights, should be the same for each row/cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 280
    }
    
    // Mark :- configuring the search bar
    
    // When ever text in search bar changes, this code is run:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        filteredData = []
        
        // What happens when you delete something from the search bar?
        if searchText == ""
        {
            filteredData = data
        }
            
        // Else: so that you only filter and add when something is actually being searched:
        else
        {
            for wine in data
            {
                if wine.title?.lowercased().contains(searchText.lowercased()) ?? false
                {
                filteredData.append(wine)
                }
            }
        }
        // So the search is refreshed every time, and filtering occurs
        self.tableView.reloadData()
        
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
