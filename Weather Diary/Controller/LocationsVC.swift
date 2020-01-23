//
//  LocationsVC.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class LocationsVC: UITableViewController {

    private var locations: [Location] = []
    private let userLocation = UserLocation()
    private let detailSegue: String = "showDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        let searchUpdater = storyboard?.instantiateViewController(withIdentifier: "LocationSearchController") as? LocationSearchController
        searchUpdater?.selectionHandler = {(location) in
            self.insertNew(location)
        }
        let searchController = UISearchController(searchResultsController: searchUpdater)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by zip code"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.delegate = searchUpdater
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
     
        getCurrentWeather()
    }
    
    private func getCurrentWeather() {
        userLocation.update()
        userLocation.completion = {(location) in
            self.insertNew(location)
        }
    }
    
    @IBAction private func onAddTap() {
        navigationItem.searchController?.isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue,
            let dest = segue.destination as? UINavigationController,
            let location = sender as? Location,
            let detailVC = dest.topViewController as? LocationDetailVC {
            
            detailVC.location = location
            detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    func insertNew(_ location: Location) {
        navigationItem.searchController?.isActive = false
        guard !locations.contains(where: { $0.zipCode == location.zipCode }) else { return }
        
        let fetcher = LocationFetchController()
        let hud = MBProgressHUD.showAdded(to: tableView, animated: true)
        hud.label.text = "Fetching Weather"
        fetcher.getWeather(at: location.zipCode, completion: {(response, message) in
            hud.hide(animated: true)
            guard let response = response else {
                let alert = UIAlertController(title: "Oops..",
                                              message: "Looks like we can't find any weather for that area.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            var location = location
            location.weather = response
            self.locations.append(location)
            let path = IndexPath(row: self.locations.count - 1, section: 0)
            self.tableView.insertRows(at: [path], with: .automatic)
            
            self.performSegue(withIdentifier: self.detailSegue, sender: location)
        })
    }
}

//MARK: - TABLE VIEW
extension LocationsVC {

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location = locations[indexPath.row]
        cell.label.text = "\(location.city), \(location.state)"
    
        let weatherDescription = location.weather?.weather.map({ $0.description }).joined(separator: ", ")
        cell.detailLabel.text = weatherDescription
        
        if let temp = location.weather?.main.temp {
            cell.temp.text = "\(Int(temp))\u{00B0}"
        }
        
        if let icon = location.weather?.weather.first?.icon,
            let iconUrl = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") {
            cell.icon.sd_setImage(with: iconUrl, completed: nil)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailSegue, sender: locations[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(
            style: .destructive,
            title: "Delete",
            handler: {(action, path) in
                self.locations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        })
        return [delete]
    }
}

