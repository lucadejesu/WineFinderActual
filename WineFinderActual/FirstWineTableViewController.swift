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


class WineTableViewCell: UITableViewCell
{
    @IBOutlet weak var WineName: UILabel!
    @IBOutlet weak var WineType: UILabel!
    @IBOutlet weak var Descriptors: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var FindSimilar: UIButton!
    @IBOutlet weak var CriticScore: UILabel!
}






// Extension on arrays that can eliminate duplicate elements from an array.
// This will be used for removing the duplicate descriptors so that matches are not boosted by the same word in the review being used repeatedly
public extension Array where Element: Hashable
{
    func getUnique() -> [Element]
    {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

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
    // Parameters in swift are immutable, so we need to copy it for a mutable copy:
    var sortedWines = wines
    // Get the number of items in the array of found WineReviews:
    let size = wines.count
    // Step 1: Build a min heap from the input data
    
    // Why build a min heap?
    // We want to sort in descending order, with the wine that has the HIGHEST match score at the front, to be displayed
    // at the top. This is can be achieved by building a min heap, then swapping the root (the smallest score) with the last item
    // (the highest score), pushing the top rated item to the front of the array.
    // In order to maintain the heap, we need to heapify after each swap and continue the process.
    // Heapify (in the min heap case) bubbles up the smaller child, if the child is smaller than the parent.
    
    // Step 2: Replace the root (the smallest item) with the last item of the heap
    // Step 3: Reduce heap size by 1
    // Step 4: heapify the root of the tree (make it conform to heap rules)
    // Step 5: Repeat the loop while the size of the heap is greater than 1.
    
    // Why heap sort?
    // The overall complexity of heap sort is O(n * log (n)), where n is the number of matching wines found.
    // This is because building the heap runs in O(n) time, and heapify runs in O(log (n)) time (because of the heap
    // height) and we call heapify n-1 times. So, n*log(n) makes the whole algorithm O(n* log(n)). This is decently quick
    // sorting algorithm, making for efficient use of time for now and for future expansion of the app (more wines added, more
    // scoring feature, etc)
    
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
    
    let tenToTwenty = 10...20
    let twentyToThirtyFive = 20...35
    let thirtyFivePlus = 35...10000
    
    var rangeArray: [ClosedRange<Int>] = []
    
    // Check if they selected more than 1 range
    
    for attribute in attributes
    {
        if attribute == "10-20 dollars"
        {
            rangeArray.append(tenToTwenty)
        }
        else if attribute == "20-35 dollars"
        {
            rangeArray.append(twentyToThirtyFive)
        }
        else if attribute == ">= 35 dollars"
        {
            rangeArray.append(thirtyFivePlus)
        }
    }
    
    if rangeArray.count > 1
    {
        // All 3 ranges selected:
        if rangeArray.count > 2
        {
            return 10...10000
        }
        // Just 2 selected, need to find which two:
        else
        {
            for range in rangeArray
            {
                // It will be either this, or if not, for sure the range will be both of the other two
                if range == tenToTwenty
                {
                    for range in rangeArray
                    {
                        // 10...20 and 20...35 are selected
                        if range == twentyToThirtyFive
                        {
                            return 10...35
                        }
                        // 10...20 and 35...10000 are selected
                        else if range == thirtyFivePlus
                        {
                            return 10...10000
                        }
                    }
                }
                // Make sure we have all combinations possible searched
                // I'd like to avoid nested loops but this is, at max, 3 elements, so it
                // really doesnt matter much time-wise
                else if range == twentyToThirtyFive
                {
                    for range in rangeArray
                    {
                        // 10...20 and 20...35 are selected
                        if range == tenToTwenty
                        {
                            return 10...35
                        }
                        // 20...35 and 35...10000 are selected
                        else if range == thirtyFivePlus
                        {
                            return 20...10000
                        }
                    }
                }
            }
        }
    }
    
    
    for attribute in attributes
    {
        
        if attribute == "10-20 dollars"
        {
            return tenToTwenty
        }
        else if attribute == "20-35 dollars"
        {
            return twentyToThirtyFive
        }
        else if attribute == ">= 35 dollars"
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
    
    // Check if color was specified, if not it will remain "Nothing"
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
    
    }
    
    
    
    for wine in wines
    {
        // Match score will keep track of the points in this custom score system
        // Current wine is the current wine being looped through, in mutable form
        // Matching attributes makes sure that if no descriptors matched, we ignore the wine and don't give it a score or append it
        
        var matchScore = 0
        var currentWine = wine
        var matchingAttributes = 0
        
        // To be added to the found wine, indicating what words matched:
        var matchingDescriptors: [String] = []
        
        
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
                matchingAttributes = matchingAttributes + 1
                
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
                matchingAttributes = matchingAttributes + 1
            }
        }
        
        
        let uniqueDescriptors = currentWine.description?.getUnique()
        
        
        // Loop through all the wine description words
        for descriptor in uniqueDescriptors ?? []
        {
            // Loop through all the attributes
            for attribute in attributes
            {
                // If the descriptor matches the attribute, add a point, break the inner loop
                if descriptor == attribute
                {
                    matchScore = matchScore+7
                    // Keep count of how many matched, so those will all descriptors can see a boost
                    matchingAttributes = matchingAttributes + 1
                    
                    // Add the attribute to the matching descriptors array:
                    matchingDescriptors.append(descriptor)
                    break
                }
            }
        }
        
        // If no attributes matched, skip over adding this wine.
        if(matchScore == 0)
        {
            continue
        }
        
        // If we made it here, then the wine is valid and its going to be recommended.
        // We want to prioritize the well reviewed wines, so we can add extra points for those with better scores:
        
        let criticScore = Int(currentWine.points )
        
        // Most wines are well reviewed in our data set.
        // So, only the best of the best should be pushed to the top, and a way to do that would be to only give points for those scored 95 and above
        let perfect = 95...100
        
        // Arbitrary point weight
        if (perfect.contains(criticScore ?? 0))
        {
            matchScore = matchScore+4
        }
        
        
        //If all attributes matched, give extra points:
        if(matchingAttributes == attributes.count)
        {
            // The more specific the attributes, the more points we want to add if this wine fulfills all of the attributes (it would be a closer match)
            if (attributes.count == 1)
            {
                matchScore = matchScore+1
            }
            else if (attributes.count == 2)
            {
                matchScore = matchScore+2
            }
            else if (attributes.count == 3)
            {
                matchScore = matchScore+3
            }
            else if (attributes.count > 3)
            {
                matchScore = matchScore+7
            }
            
            
        }
        
        
        currentWine.matchPoints = matchScore
        currentWine.matchedDescriptors = matchingDescriptors
        foundWines.append(currentWine)
        
        
    }
    
    
    
    return foundWines
}



class FirstWineTableViewController: UITableViewController
{
    var chosenAttributes: [String] = []
    let data = DataLoader().wineReviews
    var foundWines: [WineReview] = []
    
    
    @objc func goBack()
    {
        // It will go back to the "CollectionViewController" VC, and in that swift file, you can find the
        // resetting of the view in "viewDidAppear"
        // "viewDidAppear" happens whenever the view pops up, unlike "viewDidLoad"
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func search()
    {
        // Instantiate the next view controller
        guard let searchPage = storyboard?.instantiateViewController(identifier: "searchView") as? SearchViewController else { return }
        
        searchPage.data = data
        
        navigationController?.pushViewController(searchPage, animated: true)
    }
    
    
    // Function to assign actions and details for bar button
    private func configureBarItems()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Go Back", style: .done, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .white
        // Top right will allow for the user to search for a wine, to check if it is in the database
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search wines", style: .done, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Need a recommendation algorithm, based on similarity of selected atttributes and color and price
        
        
        
        foundWines = matchWines(attributes: chosenAttributes, wines: data)
        
        
        
        // Need to sort the wines by:
        // [Highest score ---> Lowest score]
        // Use our heap sort implementation:
        foundWines = heapSort(wines: foundWines)
        
        // The navigation controller bar items are connected to this class.
        configureBarItems()
        
        print(foundWines[0].title ?? "null")
        print(foundWines[0].description ?? "null")
        print(foundWines[0].matchPoints)
        print(foundWines[0].points)
        print(foundWines[0].price)
        print(foundWines[0].taster_name)
        print("total wines", data.count)
        //print(foundWines[500].matchPoints)
       // print(foundWines[500].points)
        print(foundWines.count, " found")
        
        // print(foundWines[300].title ?? "null")
        // print(foundWines[300].description ?? "null")
        // print(foundWines[300].matchPoints)
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
        return foundWines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chicken", for: indexPath) as! WineTableViewCell
        // Configure the cells here
        
        
        // user selected wine attributes are held in chosenAttributes array
        // The loaded data from the JSON file is in 'data' - its an array of 1000 wine review
        // objects
        
        
        
        
        // Configure the cells - class for these custom cells is at the top of the file
        cell.WineName.text = foundWines[indexPath.row].title
        
        
        let stringVariety = "Variety: \(foundWines[indexPath.row].variety ?? "Unknown")"
        cell.WineType.text = stringVariety
        
        let stringDescRepresentation = foundWines[indexPath.row].matchedDescriptors.joined(separator: ", ")
        
        // So that the "matching words" section doesnt just appear empty:
        if (stringDescRepresentation.isEmpty)
        {
            cell.Descriptors.text = "Price range/Color selection matched"
        }
        else
        {
            cell.Descriptors.text = stringDescRepresentation
        }
        
        // Get price formatted with a US dollar sign prefix
        let stringPrice = "$\(Int(foundWines[indexPath.row].price ?? 0))"
        
        // Some of the prices were not reported or nil, turned into 0.
        // If this is the case, do not list an incorrect '0 dollar' price,
        // rather state that the price is unknown
        if Int(foundWines[indexPath.row].price ?? 0) == 0
        {
            cell.Price.text = "unknown price"
        }
        else
        {
            cell.Price.text = stringPrice
        }
        let stringCritic = "Score: \(foundWines[indexPath.row].points) (from \(foundWines[indexPath.row].taster_name) of www.winemag.com)"
        cell.CriticScore.text = stringCritic
        
        // Adjust each label in case the labels get long, we wanna display the entire label still:
        cell.WineName.adjustsFontSizeToFitWidth = true
        cell.WineType.adjustsFontSizeToFitWidth = true
        cell.Price.adjustsFontSizeToFitWidth = true
        cell.Descriptors.adjustsFontSizeToFitWidth = true
        cell.CriticScore.adjustsFontSizeToFitWidth = true
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        
        
        
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
