//
//  WineReview.swift
//  WineFinderActual
//
//  Created by luca on 6/14/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import Foundation

// Codable allows us to represent as JSON
struct WineReview: Codable
{
    // Fields:
    // “variety” “points” “winery” “title” “description” “country” “price”
    // types: ALL are Strings, except price, which is an int
    private enum CodingKeys : String, CodingKey
    {
        case variety, points, winery, description, country, price, color, title, taster_name, full_description
    }
    
    
    // So we can create empty instances of this struct:
    init()
    {
        variety = " "
        taster_name = " "
        points = " "
        winery = " "
        title = " "
        description = []
        country = " "
        price = 0
        color = " "
        matchPoints = 0
        matchedDescriptors = []
        embedding = []
        cosineSimilarity = 0.0
        full_description = " "
    }
    
    
    var variety: String?
    var taster_name: String
    var points: String
    var winery: String?
    var title: String?
    var description: [String]?
    var country: String?
    var price: Int?
    var color: String?
    
    // Non-coding fields:
    var matchPoints = 0
    var matchedDescriptors: [String] = []
    var embedding: [Double] = []
    var cosineSimilarity = 0.0
    
    var full_description: String?
}

