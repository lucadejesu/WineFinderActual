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

// For a future prediction model:
// Step 1: create a NLP-driven python program to find similarity between wines, based on
// reviews
// Step 2: Convert the NLP program into a CoreML model
// Step 3: Use the coreML model for predictions

// Dot product of two vectors, helper function for the magnitude function:
private func dot(_ a: [Double], _ b: [Double]) -> Double
{
    assert(a.count == b.count, "Vectors must have the same dimension")
    let result = zip(a, b)
        .map { $0 * $1 }
        .reduce(0, +)

    return result
}

// Magnitude of the vector is the square root of the dot product of the vector with itself.
private func mag(_ vector: [Double]) -> Double
{
    return sqrt(dot(vector, vector))
}
// Formula for cosine similarity of two vectors:
public func cosineSimilarity(a: [Double], b: [Double]) -> Double
{
    return dot(a, b) / (mag(a) * mag(b))
}

// Vector returns a NL embedding  sentence embedding in the english language:
public func vector(for description: String) -> [Double]
{
    if #available(iOS 14.0, *)
    {
        guard let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english),
              let vector = sentenceEmbedding.vector(for: description) else {
            fatalError()
        }
        
        return vector
    }
    else
    {
        
        return []
    }
    
}
 

// This code is a helper function that can find the documents directory for the app, if something needs to be written to the app documents (its a hard to find location)
// It was used earlier, for computing embeddings for the wines):
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//func getDocumentsDirectory() -> URL
//{
//    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//    return paths[0]
//}

// For customization on the cell:
class RecommendedCell: UITableViewCell
{
    
    @IBOutlet weak var WineName: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var FindAnother: UIButton!
    @IBOutlet weak var Variety: UILabel!
    @IBOutlet weak var ReturnHome: UIButton!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var CosineSimilarity: UILabel!
    @IBOutlet weak var QuestionMark: UIButton!
    
    
    
    
}
// Custom button class (not implemented in version 1.0 but could be in future updates):
class QuestionButton: UIButton
{
    private let title_label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let icon_view: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var viewModel: QuestionButtonViewModel?
    
    override init(frame: CGRect)
    {
        self.viewModel = nil
        super.init(frame: frame)
    }
    
    init(with viewModel: QuestionButtonViewModel)
    {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubviews()
        
        configure(with: viewModel)
        
    }
    
    private func addSubviews()
    {
        guard !title_label.isDescendant(of: self) else { return }
        addSubview(title_label)
        addSubview(icon_view)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Allows us to configure a button after it has already been created:
    public func configure(with viewModel: QuestionButtonViewModel)
    {
        addSubviews()
        
        title_label.text = viewModel.title
        icon_view.image = UIImage(systemName: viewModel.imageName)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        icon_view.frame = CGRect(x: 5, y: 5, width: 50, height: frame.height).integral
        
        title_label.frame = CGRect(x: 60, y: 5, width: frame.width-65, height: (frame.height-10)/2).integral
        
    }
    
    
}
struct QuestionButtonViewModel
{
    let title: String
    let imageName: String
}



class RecommendedTableViewController: UITableViewController
{
    
// The following code is if a custom button is to be added in the future:
//    private let qButton: QuestionButton =
//    {
//        let button = QuestionButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
//        return button
//    }()
//
    
    // Need the total wine data:
    var data = ML_Loader().ml_Reviews
    var old_data = DataLoader().wineReviews
    var startIndex = 0
    var endIndex = 100
    
    var wineModel: WineReview?
    var bestMatch: MLReview?
    var max_similarity = 0.0
    
    // User pressed to go home:
    
    @IBAction func ReturnHomeTapped(_ sender: UIButton)
    {
        sender.backgroundColor = .darkGray
        
        var vcArray = self.navigationController?.viewControllers
        
        vcArray?.removeAll()
        
        // Add home back
        guard let nextPage = storyboard?.instantiateViewController(identifier: "CollectionViewController") as? CollectionViewController else { return }
        
        // Append to the view controller array
        vcArray!.append(nextPage)
        
        // Set the view controllers (effectively returning home)
        self.navigationController?.setViewControllers(vcArray!, animated: false)
        
    }
    
    
    
    
    // User pressed to look for another wine:
    @IBAction func findAnotherTapped(_ sender: UIButton)
    {
        sender.backgroundColor = .darkGray
        
        // We can't search another 100 when we get to 1100, so don't allow the user to go further.
        if(startIndex == 1100)
        {
            let end_alert = UIAlertController(title: "There are no more wines to recommend", message: "Press 'Okay' to dismiss", preferredStyle: .alert)
            
            end_alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(end_alert, animated: true)
            
            sender.backgroundColor = .systemGray2
        }
        else
        {
            guard let nextPage = storyboard?.instantiateViewController(identifier: "recommendedTableView") as? RecommendedTableViewController else { return }
        
            // Configure the data to pass to the next page here:
            
            // So we can search the next block of wines, set the newest pushed instance of the recommended indices (update them)
            // This way, we run the same code over and over, only moving to another 100 wines each time, until all wines have been looked at (if the user wants to look through all).
            nextPage.startIndex = startIndex
            nextPage.endIndex = endIndex
            nextPage.data = data
            nextPage.wineModel = wineModel
        
            // Reset max_similarity on each load:
            nextPage.max_similarity = 0.0
        
            navigationController?.pushViewController(nextPage, animated: true)
        }
        
    }
    
    
    @IBAction func QuestionMarkTapped(_ sender: UIButton)
    {
        let question_alert = UIAlertController(title: "Cosine Similarity?", message: "Cosine similarity is a metric used to compare text similarity. The value ranges from 0 to 1.0, with a value closer to 1 representing \'more similar.\' ", preferredStyle: .alert)
        
        question_alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

        self.present(question_alert, animated: true)
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
    
    @objc func goBack()
    {
        // It will go back to the "CollectionViewController" VC, and in that swift file, you can find the
        // resetting of the view in "viewDidAppear"
        // "viewDidAppear" happens whenever the view pops up, unlike "viewDidLoad"
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func search()
    {
        // Instantiate the next view controller
        guard let searchPage = storyboard?.instantiateViewController(identifier: "searchTable") as? SearchTableViewController else { return }
        
        searchPage.ml_data = data
        searchPage.data = old_data
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
        
       
        print(startIndex)
        configureBarItems()
        
        var counter = startIndex
        
        for wine in data
        {
        
            // Get the embedding for the unwanted wine:
            let wineDescription = (wineModel?.description)?.joined(separator: " ") ?? " "
            let wineVector = vector(for: wineDescription)
            
            // Get the current wine embedding:
            let current_vector = data[counter].embedding
            
            
            
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
            
            
            if(current_cosine_similarity > max_similarity)
            {
                max_similarity = current_cosine_similarity
                bestMatch = wine
            }
            
            counter = counter + 1
            if (counter == endIndex)
            {
                //counter = counter + 1
                break
            }
            
        }
        
        startIndex = counter
        endIndex = startIndex + 100
        
    }

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
        
        // Set the price
        let stringPrice = "$\(Int(bestMatch?.price ?? 0))"
        
        if Int(bestMatch?.price ?? 0) == 0
        {
            cell.Price.text = "unknown price"
        }
        else
        {
            cell.Price.text = stringPrice
        }
        
        // Double(round(1000*x)/1000)
        
        // Set the cosine similarity:
        let stringSimilarity = "Cosine similarity: \(Double(round(1000*max_similarity)/1000))"
        cell.CosineSimilarity.text = stringSimilarity
        
        cell.WineName.adjustsFontSizeToFitWidth = true
        cell.Score.adjustsFontSizeToFitWidth = true
        cell.Description.adjustsFontSizeToFitWidth = true
        cell.Variety.adjustsFontSizeToFitWidth = true
        cell.Price.adjustsFontSizeToFitWidth = true
        
        
        
        
        cell.FindAnother.addTarget(self, action: #selector(findAnotherTapped), for: .touchUpInside)
        // Rounded look for the button, matching previous button style
        cell.FindAnother.layer.cornerRadius = 10
        
        // Add home target:
        cell.ReturnHome.addTarget(self, action: #selector(ReturnHomeTapped), for: .touchUpInside)
        cell.ReturnHome.layer.cornerRadius = 10
        
        
        return cell
    }
    
    // This number was selected from the height of the cell in recommended table view controller (size inspector):
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 575
        
    }

}
