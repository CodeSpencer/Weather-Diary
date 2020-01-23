//
//  UserLocation.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocation: NSObject {
    
    private let manager = CLLocationManager()
    
    var completion: ((Location) -> Void)?
    
    func update() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestLocation()
    }
    
}

extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.first else { return }
        
        CLGeocoder().reverseGeocodeLocation(current, completionHandler: {(placemarks, error) in
            guard let place = placemarks?.first else { return }
            if let city = place.locality, let state = place.administrativeArea, let zip = place.postalCode {
                let location = Location(city: city, state: state, zipCode: zip, weather: nil)
                self.completion?(location)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Failed: ", error)
    }
}

