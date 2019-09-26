//
//  CountryModel.swift
//  CollectionLab
//
//  Created by albert coelho oliveira on 9/26/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct Country: Codable{
    let name: String
    let capital: String
    let population: Int
    let alpha2Code: String
    static func decodeElementsFromData(from jsonData: Data) throws -> [Country] {
           let response = try JSONDecoder().decode([Country].self, from: jsonData)
           return response
       }
}
