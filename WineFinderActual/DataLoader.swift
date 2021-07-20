//
//  DataLoader.swift
//  WineFinderActual
//
//  Created by luca on 6/14/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import Foundation

public class DataLoader
{
    // Published allows updating the data to be easier
    @Published var wineReviews = [WineReview]()
    
    // Load on creation
    init()
    {
        load()
    }
    
    func load()
    {
        if let fileLocation = Bundle.main.url(forResource: "NEWwineData", withExtension: "json")
        {
            // do catch in case of an error
            do
            {
                let data = try Data(contentsOf: fileLocation)
                // allows us to decode instances of JSON object
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([WineReview].self, from: data)
                
                self.wineReviews = dataFromJson
                
            }
            catch
            {
                print(error)
            }
        }
    }
    
}
