//
//  CollectionViewCell.swift
//  WineFinderActual
//
//  Created by luca on 6/5/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import UIKit
import CoreData

// Implementing a custom collection view cell class, so that each cell will have it's own
// design that we can repeat
class CollectionViewCell: UICollectionViewCell
{
    
    
    
    
    @IBOutlet weak var topLabel: UILabel!
    
    
    @IBOutlet weak var descriptorLabel: UILabel!
    
    
    // Configure method that will take a string descriptor and create a label for it.
    func configure(with descriptor: String)
    {
        descriptorLabel.text = descriptor
        descriptorLabel.adjustsFontSizeToFitWidth = true
        
        // CUSTOMIZE THE DESCRIPTOR BUTTONS
        
    }
    
    
    
    
}
