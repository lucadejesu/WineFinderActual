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


// Helper function for heap sort:

func heapify(wines: [WineReview], size: Int, index: Int) -> [WineReview]
{
    var sortedWines = wines
    var smallest = index
    
    // The left child is 2i + 1 (balanced binary tree)
    let left = 2*index + 1
    // Right child is 2i +2 (balanced binary tree)
    let right = 2*index + 2
    
    // If the left child is smaller than the root, make the left child the root (building a min heap)
    if (left < size && sortedWines[left].matchPoints < sortedWines[smallest].matchPoints)
    {
        smallest = left
    }
    
    // If the right child is smaller than current smallest:
    if(right < size && sortedWines[right].matchPoints < sortedWines[smallest].matchPoints)
    {
        smallest = right
    }
    
    // If smallest is not the root:
    if(smallest != index)
    {
        // Swap the smallest to 'index' the root
        sortedWines.swapAt(index, smallest)
        
        // Make a recurive call to heapify the affected subtree
        sortedWines = heapify(wines: sortedWines, size: size, index: smallest)
    }
    
    return sortedWines
}


// Sort in descending order, based on the match points
func heapSort(wines: [WineReview]) -> [WineReview]
{
    var sortedWines = wines
    // Get the number of items in the array of found WineReviews:
    let size = wines.count
    // Step 1: Build a min heap from the input data
    // Step 2: Replace the root (the smallest item) with the last item of the heap
    // Step 3: Reduce heap size by 1
    // Step 4: heapify the root of the tree (make it conform to heap rules)
    // Step 5: Repeat the loop while the size of the heap is greater than 1.
    
    
    var index = size/2 - 1
    
    while(index >= 0)
    {
        
        sortedWines = heapify(wines: wines, size: size, index: index)
        
        index = index-1
    }

    // Extract elements from the newly created minHeap, sortedWines:
    var newIndex = size - 1
    
    while(newIndex >= 0)
    {
        // Move the current root, the smallest, to the end, to sort in descending order:
        sortedWines.swapAt(0, newIndex)
        
        // Heapify the reduced heap:
        sortedWines = heapify(wines: sortedWines, size: newIndex, index: 0)
        
        newIndex = newIndex - 1
    }
    
    return sortedWines
}





// Helper function to check if the user selected a range of price
func checkForRange(attributes: [String]) -> ClosedRange<Int>
{
    // Ranges for price
    let zeroToTen = 0...10
    let tenToTwenty = 10...20
    let twentyToThirtyFive = 20...35
    let thirtyFivePlus = 35...10000
    
    for attribute in attributes
    {
        if attribute == "1- 10 dollars"
        {
            return zeroToTen
        }
        else if attribute == "10-20 dollars"
        {
            return tenToTwenty
        }
        else if attribute == "20-35 dollars"
        {
            return twentyToThirtyFive
        }
        else if attribute == ">=35 dollars"
        {
            return thirtyFivePlus
        }
    
    }
    
    return 0...1
    
}

func matchWines(attributes: [String], wines: [WineReview]) -> [WineReview]
{
    // Only matches go here, along with their newly added "matchPoints"
    var foundWines: [WineReview] = []
    
    // Attributes is what was passed in from the user, in the above
    let range = checkForRange(attributes: attributes)
    
    var color = "Nothing"
    
    for attribute in attributes
    {
        if attribute == "red"
        {
            color = "red"
        }
        else if attribute == "white"
        {
            color = "white"
        }
        else if attribute == "sparkling/other"
        {
            color = "sparkling/other"
        }
    }
    
    
    
    for wine in wines
    {
        var matchScore = 0
        var currentWine = wine
        // Check if the price range fits
        if range != 0...1
        {
            // If price is not in the price range, skip the wine
            if !range.contains(wine.price ?? -1)
            {
                continue
            }
            else
            {
                matchScore = matchScore+1
            }
            
        }
        // If they specified a color, and it doesnt match, then break
        if color != "Nothing"
        {
            if wine.color != color
            {
                continue
            }
            else
            {
                matchScore = matchScore+1
            }
        }
        
        // Loop through all the wine description words
        for descriptor in wine.description ?? []
        {
            // Loop through all the attributes
            for attribute in attributes
            {
                // If the descriptor matches the attribute, add a point, break the inner loop
                if descriptor == attribute
                {
                    matchScore = matchScore+1
                    break
                }
            }
        }
        
        currentWine.matchPoints = matchScore
        foundWines.append(currentWine)
        
    }
    
    
    return foundWines
}
    


class FirstWineTableViewController: UITableViewController
{
    var chosenAttributes: [String] = []
    let data = DataLoader().wineReviews
    var foundWines: [WineReview] = []
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Need a recommendation algorithm, based on similarity of selected atttributes and color and price
        
        
        
        foundWines = matchWines(attributes: chosenAttributes, wines: data)
        
        
        // Need to sort the wines by:
        // [Highest score ---> Lowest score]
        // Use our heap sort implementation:
        foundWines = heapSort(wines: foundWines)
        
        
        
        print(foundWines[0].title ?? "null")
        print(foundWines[0].description ?? "null")
        print(foundWines[0].matchPoints)
        
        print(foundWines.count, " found")
        
        print(foundWines[300].title ?? "null")
        print(foundWines[300].description ?? "null")
        print(foundWines[300].matchPoints)
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
        return 10
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
        
        
        
        // Configure the cell...
        cell.textLabel?.text = foundWines[indexPath.row].title
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
