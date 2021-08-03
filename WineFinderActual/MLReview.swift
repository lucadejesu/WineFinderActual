//
//  MLReview.swift
//  WineFinderActual
//
//  Created by luca on 7/30/21.
//  Copyright © 2021 Luca. All rights reserved.
//

import Foundation

struct MLReview: Codable, Equatable
{
    // Fields:
    // “variety” “points” “winery” “title” “description” “country” “price”
    // types: ALL are Strings, except price, which is an int
    private enum CodingKeys : String, CodingKey
    {
        case variety, points, winery, description, country, price, color, title, taster_name, full_description, embedding
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
    var embedding: [Double]?
    // Non-coding fields:
    
    var matched = false
    
    var full_description: String?
}
