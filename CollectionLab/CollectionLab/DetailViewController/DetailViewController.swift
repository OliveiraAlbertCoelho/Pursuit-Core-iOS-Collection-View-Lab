//
//  DetailViewController.swift
//  CollectionLab
//
//  Created by albert coelho oliveira on 9/26/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var country: Country!
    @IBOutlet weak var imageCountry: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var capital: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUp()
        loadImage()
    }
    func loadUp(){
        name.text = country?.name
        population.text = "Population: \(country.population.description)"
        capital.text = "Capital: \(country.capital)"
    }
    func loadImage(){
        let url = "https://www.countryflags.io/\(country.alpha2Code)/flat/64.png"
        ImageHelper.shared.getImage(urlStr: url){(result)in
            DispatchQueue.main.async {
                switch result{
                case .failure(let failure):
                    print(failure)
                case .success(let image):
                    self.imageCountry.image = image
                    
                }
            }
        }
    }
}
