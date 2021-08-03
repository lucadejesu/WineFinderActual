//
//  ML_Loader.swift
//  WineFinderActual
//
//  Created by luca on 7/30/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import Foundation


public class ML_Loader
{
    // Published allows updating the data to be easier
    @Published var ml_Reviews = [MLReview]()
    
    // Load on creation
    init()
    {
        load()
    }
    
    func load()
    {
        if let fileLocation = Bundle.main.url(forResource: "vectorizedData", withExtension: "json")
        {
            // do catch in case of an error
            do
            {
                let data = try Data(contentsOf: fileLocation)
                // allows us to decode instances of JSON object
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([MLReview].self, from: data)
                
                self.ml_Reviews = dataFromJson
                
            }
            catch
            {
                print(error)
            }
        }
    }
    
}
