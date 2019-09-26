//
//  ElementAPIClient.swift
//  collection-views
//
//  Created by David Rifkin on 9/26/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct CountryAPIClient {
    
    // MARK: - Static Properties
    
    static let manager = CountryAPIClient()
    
    // MARK: - Instance Methods
    
    
    func getCountry(urlStr: String?, completionHandler: @escaping (Result<[Country], AppError>) -> ())  {
            
           var url = URL(string: "https://restcountries.eu/rest/v2/")
        if let word = urlStr?.lowercased(){
        let newString = word.replacingOccurrences(of: " ", with: "%20")
            url = URL(string:"https://restcountries.eu/rest/v2/name/\(newString)")
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url!, andMethod: .get) { (results) in
            switch results {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let elementInfo = try Country.decodeElementsFromData(from: data)
                    completionHandler(.success(elementInfo))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
        
    }
    
    
    
    private init() {}
}
