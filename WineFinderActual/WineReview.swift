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
    var variety: String?
    var taster_name: String
    var points: String
    var winery: String?
    var title: String?
    var description: [String]?
    var country: String?
    var price: Int?
    var color: String?
    var matchPoints = 0
    var matchedDescriptors: [String] = []
    var full_description: String?
}

