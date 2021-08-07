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


// Step 1: create a NLP-driven python program to find similarity between wines, based on
// reviews
// Step 2: Convert the NLP program into a CoreML model
// Step 3: Use the coreML model for predictions




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

public func vector(for description: String) -> [Double]
{
    if #available(iOS 14.0, *)
    {
        guard let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english),
              let vector = sentenceEmbedding.vector(for: description) else {
            fatalError()
        }
        
        return vector
    } else {
        // Fallback on earlier versions
        return []
    }
    
}
 


func getDocumentsDirectory() -> URL

{

    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    return paths[0]

}

// For customization on the cell:
class RecommendedCell: UITableViewCell
{
    
    @IBOutlet weak var WineName: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var FindAnother: UIButton!
    @IBOutlet weak var Variety: UILabel!
    
    
}



class RecommendedTableViewController: UITableViewController
{
    // Need the total wine data:
    var data = ML_Loader().ml_Reviews
    
    var startIndex = 0

    var wineModel: WineReview?
    var bestMatch: MLReview?
    var max_similarity = 0.0
    
    // User pressed to look for another wine:
    @IBAction func findAnotherTapped(_ sender: UIButton)
    {
        sender.backgroundColor = .darkGray
        
        guard let nextPage = storyboard?.instantiateViewController(identifier: "secondRecommendedView") as? SecondRecommendedTableViewController else { return }
        
        // Configure the data to pass to the next page here:
        nextPage.startIndex = startIndex
        nextPage.data = data
        nextPage.wineModel = wineModel
        
        navigationController?.pushViewController(nextPage, animated: true)
        
        
    }
    
    // When view re-appears (on back):
    override func viewDidAppear(_ animated: Bool)
    {
        for cell in tableView.visibleCells
        {
            // Change the cells button color
            let currCell = cell as! RecommendedCell
            currCell.FindAnother.backgroundColor = .systemGray2
            
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var counter = 0
        
        for wine in data
        {
        
            // Get the embedding for the unwanted wine:
            let wineDescription = (wineModel?.description)?.joined(separator: " ") ?? " "
            let wineVector = vector(for: wineDescription)
            
            // Get the current wine embedding:
            let current_vector = wine.embedding
            
            
            
            if(current_vector == [0.0])
            {
                counter = counter + 1
                continue
            }
            // Get the cosine similarity of the two vectors (how similar the descriptions are, according to NLP sentence embeddings):
            let current_cosine_similarity = cosineSimilarity(a: wineVector, b: current_vector!)
            
            if(current_cosine_similarity > 1.0)
            {
                counter = counter + 1
                continue
            }
            
//            if(current_cosine_similarity > 0.85)
//            {
//                max_similarity = current_cosine_similarity
//                bestMatch = wine
//                break
//            }
            
            
            
            if(current_cosine_similarity > max_similarity)
            {
                max_similarity = current_cosine_similarity
                bestMatch = wine
            }
            
            counter = counter + 1
            if (counter == 100)
            {
                break
            }
            
        }
        
        startIndex = counter
        // print("data size: ", data.count)
        print(bestMatch?.title)
        
        
        print(bestMatch?.full_description)
        print(bestMatch?.variety)
        print(max_similarity)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // Only have one wine being returned:
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Only have one wine being returned:
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell", for: indexPath) as! RecommendedCell
        
        cell.WineName.text = bestMatch?.title
        
        // Get rid of newlines and set the text to hold the full description:
        let stringDescRepresentation = bestMatch?.full_description
        let trimmed = stringDescRepresentation?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.Description.text = trimmed
        
        let stringCritic = "Score: \(bestMatch?.points ?? "unknown") (from \(bestMatch?.taster_name ?? "unknown") of www.winemag.com)"
        cell.Score.text = stringCritic
        
        let stringVariety = "Variety: \(bestMatch?.variety ?? "Unknown")"
        cell.Variety.text = stringVariety
        
        
        cell.WineName.adjustsFontSizeToFitWidth = true
        cell.Score.adjustsFontSizeToFitWidth = true
        cell.Description.adjustsFontSizeToFitWidth = true
        cell.Variety.adjustsFontSizeToFitWidth = true

        
        cell.FindAnother.addTarget(self, action: #selector(findAnotherTapped), for: .touchUpInside)
        // Rounded look for the button, matching previous button style
        cell.FindAnother.layer.cornerRadius = 10
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 420
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
