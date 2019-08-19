//
//  Yelp.swift
//  CityRundown
//
//  Created by William Moody on 8/15/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation

struct YelpData: Decodable {
    let businesses: [Business]
}

struct Business: Decodable {
    let name: String
    let image_url: String?
    let review_count: Int
    let rating: Double
    let coordinates: coordinates
    let price: String?
    let categories: [Categories]
    let location: Location
}

struct coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Location: Decodable {
    let address1: String?
}

struct Categories: Decodable {
    let title: String?
}
