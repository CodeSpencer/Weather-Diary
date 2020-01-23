//
//  Location.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation

struct Location: Codable {
    var city: String
    var state: String
    var zipCode: String
    var weather: WeatherResponse?
}
