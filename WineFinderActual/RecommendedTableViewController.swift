//
//  RecommendedTableViewController.swift
//  WineFinderActual
//
//  Created by luca on 7/26/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
import NaturalLanguage
import Foundation

// Current idea: build a kNN model in Keras, convert it to CoreML model,
// use this CoreML model to recommend new wines.
// Probably need a new set of wine reviews to recommend based on.

// We can get word embeddings with this function.
// We can then get word embeddings for each word within a wine review
// then we have a vector of words and their embeddings
private func dot(_ a: [Double], _ b: [Double]) -> Double
{
    assert(a.count == b.count, "Vectors must have the same dimension")
    let result = zip(a, b)
        .map { $0 * $1 }
        .reduce(0, +)

    return result
}

/// Magnitude
private func mag(_ vector: [Double]) -> Double {
    // Magnitude of the vector is the square root of the dot product of the vector with itself.
    return sqrt(dot(vector, vector))
}
public func cosineSimilarity(a: [Double], b: [Double]) -> Double
{
    return dot(a, b) / (mag(a) * mag(b))
}

public func vector(for string: String) -> [Double]
{
    if #available(iOS 14.0, *)
    {
        guard let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english),
              let vector = sentenceEmbedding.vector(for: string) else {
            fatalError()
        }
        
        return vector
    } else {
        // Fallback on earlier versions
        return []
    }
    
}
class RecommendedTableViewController: UITableViewController
{
    // Need the total wine data:
    var data: [WineReview] = []
    var wineModel: WineReview?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(wineModel?.title)
        
        for i in 0...10
        {
            // For each word, get a word embedding
            let word = wineModel?.description?[i]
            
        }
        
        // Get a sentence embedding for the wine review:
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
