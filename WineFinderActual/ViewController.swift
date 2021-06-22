//
//  ViewController.swift
//  WineFinderActual
//
//  Created by luca on 6/4/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController
{

    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var findWineCell: UICollectionViewCell!
    
    @IBAction func findButtonPressed(_ sender: Any)
    {
        findWineCell.contentView.backgroundColor = .systemGray4
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

