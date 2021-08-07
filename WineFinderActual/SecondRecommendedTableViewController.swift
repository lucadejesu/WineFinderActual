//
//  SecondRecommendedTableViewController.swift
//  WineFinderActual
//
//  Created by luca on 8/6/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
import NaturalLanguage
import Foundation

class newRecommendedCell: UITableViewCell
{
    @IBOutlet weak var WineName: UILabel!
    @IBOutlet weak var Variety: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var TryAgain: UIButton!
    
}


class SecondRecommendedTableViewController: UITableViewController
{
    var startIndex = 0
    var data: [MLReview] = []
    var wineModel: WineReview?
    var max_similarity = 0.0
    var bestMatch: MLReview?
    var newStartIndex = 0
    
    
    @IBAction func TryAgainTapped(_ sender: UIButton)
    {
        sender.backgroundColor = .darkGray
        
        guard let nextPage = storyboard?.instantiateViewController(identifier: "thirdRecommendedView") as? ThirdRecommendedViewController else { return }
        
        // Configure the data for the next page here:
        nextPage.startIndex = newStartIndex
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
            let currCell = cell as! newRecommendedCell
            currCell.TryAgain.backgroundColor = .systemGray2
            
        }
    }
    
    
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()

        // Same process as before, only this time, go from previous
        // last index to the next point (last index + 400)
        var endIndex = startIndex + 99
        var counter = startIndex
        
        for wine in data
        {
            // Get the embedding for the unwanted wine:
            let wineDescription = (wineModel?.description)?.joined(separator: " ") ?? " "
            
            let wineVector = vector(for: wineDescription)
            
            let current_vector = data[counter].embedding
            
            // Skip the empty wine vectors
            if(current_vector == [0.0])
            {
                counter = counter + 1
                continue
            }
            
            // Get cosine similarity (according to the NLP sentence embeddings):
            let current_cosine_similarity = cosineSimilarity(a: wineVector, b: current_vector!)
            
            if(current_cosine_similarity > 1.0)
            {
                counter = counter + 1
                continue
            }
            
            if(current_cosine_similarity > max_similarity)
            {
                max_similarity = current_cosine_similarity
                bestMatch = wine
            }
            
            counter = counter + 1
            if(counter == endIndex)
            {
                break
            }
            
        }
        
        newStartIndex = counter
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 420
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newRecommendedCell", for: indexPath) as! newRecommendedCell

        // Configure the cell
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
        
        cell.TryAgain.addTarget(self, action: #selector(TryAgainTapped), for: .touchUpInside)
        cell.TryAgain.layer.cornerRadius = 10
        
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
