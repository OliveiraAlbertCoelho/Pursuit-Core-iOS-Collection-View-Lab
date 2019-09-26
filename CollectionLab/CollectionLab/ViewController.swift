//
//  ViewController.swift
//  CollectionLab
//
//  Created by albert coelho oliveira on 9/26/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var countries = [Country](){
        didSet{
    countryCollection.reloadData()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryCollection: UICollectionView!
    var userSearchTerm: String? {
          didSet {self.countryCollection.reloadData()}
      }
      var filteredCountry: [Country]  {
          guard let userSearchTerm = userSearchTerm else {
              return countries
          }
          guard userSearchTerm != "" else {
              return countries
          }
          return countries
      }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(str: nil)
        countryCollection.dataSource = self
        countryCollection.delegate = self
        searchBar.delegate = self
    }
    private func loadData(str: String?) {
          CountryAPIClient.manager.getCountry(urlStr: str) { (result) in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let country):
                    self.countries = country
                  case .failure(let error):
                      print(error)
                  }
              }
          }
      }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          guard let countryDetail = segue.destination as? DetailViewController else {
              fatalError("Unexpected segue")
          }
        let selectedCell = sender as! CountryCollectionViewCell
        let selectedIndexPath = (countryCollection.indexPath(for: selectedCell)?.row)!
        
        countryDetail.country = filteredCountry[selectedIndexPath]
      }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCountry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = countryCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CountryCollectionViewCell
        let info = filteredCountry[indexPath.row]
        let imageUrl = "https://www.countryflags.io/\(info.alpha2Code)/flat/64.png"
        ImageHelper.shared.getImage(urlStr: imageUrl){ (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell?.CountryImage.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
        print(info.name)
        cell?.countryName.text = info.name
        cell?.population.text = "Population: \(info.population.description)"
        cell?.capital.text = "Capital: \(info.capital)"
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 170, height: 190)
           }
       
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         self.userSearchTerm = searchText
        loadData(str: searchText)
    }
}
