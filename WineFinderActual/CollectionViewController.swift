//
//  CollectionViewController.swift
//  WineFinderActual
//
//  Created by luca on 6/5/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController
{
    
    
    
    let findButton = UIButton(frame: CGRect(x:104,y:53,width:206,height:93))
    // Act as switches when the descriptors are selected:
    var selected: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    // List of top wine descriptors used in reviews
    // From the top 60 words in the reviews, in order of flavor, texture, body
    let dataSource: [String] = ["fruit", "cherry", "spice", "rich", "oak", "lemon", "savory", "apple", "pepper", "raspberry", "herb", "plum", "strawberry", "citrus", "peach", "berry", "tangy","crisp", "blackberry", "light", "dark", "full", "red",
    "white", "10-20 dollars","20-35 dollars", ">= 35 dollars"]
    
    // This will be an array of actual chosen descriptors clicked on:
    var chosen: [String] = []
    
    // When the view appears, aka when we go back on the next VC (popping it off the stack), reset the variables for a new search.
    // Anything else that needs to be reset upon popping can be done here.
    override func viewDidAppear(_ animated: Bool)
    {
        // self.collectionView.isScrollEnabled = false
        selected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        chosen = []
        
        //  Reset all of the cells to the original gray color:
        for cell in collectionView.visibleCells
        {
            cell.contentView.backgroundColor = .systemGray5
        }
        // Reset the find button to the original red color
        findButton.backgroundColor = UIColor(red: 0.50, green: 0.00, blue: 0.00, alpha: 1.00)
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func findButtonTapped(_ sender: UIButton) -> Void
    {
        
        
        // Collect all of the selected words at this point, to be passed to the next view.
        var count = 0
        // Used to check if anything was selected
        var pickedCount = 0
        for descriptor in dataSource
        {
            if selected[count] == true
            {
                chosen.append(descriptor)
                pickedCount = pickedCount + 1
            }
            count = count + 1
        }
        
        
        // Now, we need to take the chosen words, and compare against some wine data,
        // and then present these wines in a new view
        
        // Use guard to check if we can instantiate, if we can't, then return
        // nextPage is a child view controller, and this is a modal transition
        
        
        // If the user picked attributes, continue
        if pickedCount != 0
        {
            sender.backgroundColor = UIColor(red: 0.33, green: 0.00, blue: 0.00, alpha: 1.00)
            
            guard let nextPage = storyboard?.instantiateViewController(identifier: "firstWineTable") as? FirstWineTableViewController else { return }
        
            nextPage.chosenAttributes = chosen
        
            print(chosen)
            navigationController?.pushViewController(nextPage, animated: true)
        }
        
        // If nothing is selected, display a UIAlert asking for descriptors to be selected
        else
        {
            let alert = UIAlertController(title: "Did you select any descriptors?", message: "In order to recommend some wines, you need to select some descriptors.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
        
        
        
    }
    
    
    
    // Returns the amount of descriptors in a section of a collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    
    // Return a collection view cell for each section
    // This function manages the creation of the cells, and they are created and returned dynamically.
    // The number of cells that are returned depends on the number of string descriptors in the
    // "dataSource" array.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        // Casting the colletion view cell as our custom collection view cell
        // (Reuse Identifier can be found in the attribute inspector of the Cell in interface builder)
        if let descriptorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell
        {
            
            // Each descriptor is configured into a cell, using wineDescriptors as the datasource
            descriptorCell.configure(with: dataSource[indexPath.row])
            
            
            // To return this cell
            cell = descriptorCell
        }
        
        // change structural stuff here
        cell.layer.cornerRadius = 10
        // cell.layer.backgroundColor = 
        
        // NOTE: The reason that the labels were not showing was because the constraints on the label were not
        // centered to the content view correctly (bottom right corner)
        
        
        
        return cell
    }
    
    // Allows the header and footer sections to be shown.
    // Override the function that takes a collection view, view for a string label, returns a reusable view
    // This function creates our header and footer supplementary views, as well as the find button (that is wired
    // to an IB action above)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if (kind == UICollectionView.elementKindSectionFooter)
        {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            // Customize footerView here
            
            // This is where we add the UI button as a subview and return it, so we can
            // wire up action to it.
            
            // let findButton = UIButton(frame: CGRect(x:104,y:53,width:206,height:93))
            findButton.setTitle("Find wines", for: .normal)
            
            // The selector is the IB action function above
            findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
            
            //  To get the proper values for the swift color, I converted maroon hex to these
            //  values using an online converter
            findButton.backgroundColor = UIColor(red: 0.50, green: 0.00, blue: 0.00, alpha: 1.00)
            findButton.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: 18)
            findButton.layer.cornerRadius = 10
            findButton.layer.borderWidth = 1
            
            footerView.addSubview(findButton)
            
            
            
            return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader)
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            // Customize headerView here
            
            return headerView
        }
        fatalError()
    }
    
    // Make sure that we implement cell selection (when you click a label, what happens next?)
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // IndexPath row is numbered 0-26 (or 0-(# of attributes - 1))
        
        
        if let cell = collectionView.cellForItem(at:indexPath) as? CollectionViewCell
        {
            selected[indexPath.row].toggle()
            
            if selected[indexPath.row] == true
            {
            cell.contentView.backgroundColor = .gray
            }
            else
            {
            cell.contentView.backgroundColor = .systemGray5
            }
            
            
        }
        
        
        
    }
}
