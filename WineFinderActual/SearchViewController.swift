//
//  SearchViewController.swift
//  WineFinderActual
//
//  Created by luca on 7/23/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit

// Let user search all of the wines in the data for quick lookup
// This "SearchViewController" is just a view controller instance, and it contains outlets
// for the results (in a table view instance) and text box for searching.
class SearchViewController: UIViewController {

    @IBOutlet weak var searchBox: UITextField!
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // All of the wines in the database
    var data: [WineReview] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
