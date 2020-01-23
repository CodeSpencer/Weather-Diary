//
//  LocationSearchController.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MBProgressHUD

class LocationSearchController: UITableViewController {
    
    private var searchResults: [Location] = []
    private var geoCoder = CLGeocoder()
    var selectionHandler: ((Location) -> Void)?
    
    @IBAction private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - SEARCH FIELD
extension LocationSearchController: UISearchBarDelegate {
    
    //NOTE: - Validates search by getting nearest city
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        let hud = MBProgressHUD.showAdded(to: tableView, animated: true)
        hud.label.text = "Validating Search"
        geoCoder.geocodeAddressString(text, completionHandler: {(placemarks, error) in
            hud.hide(animated: true)
            
            if let error = error {
                print("Error Geocoding Address: ", error.localizedDescription)
            } else if let placemarks = placemarks {
                
                var places: [Location] = []
                for place in placemarks {
                    
                    if let city = place.locality, let state = place.administrativeArea, let zip = place.postalCode {
                        let location = Location(city: city, state: state, zipCode: zip, weather: nil)
                        places.append(location)
                    }
                }
                self.searchResults = places
                self.tableView.reloadData()
            }
        })
    }
}

//MARK: - TABLE VIEW
extension LocationSearchController {
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let location = searchResults[indexPath.row]
        cell.textLabel?.text = "\(location.city), \(location.state) \(location.zipCode)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selected = searchResults[indexPath.row]
        selectionHandler?(selected)
    }
}


