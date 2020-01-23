//
//  Weather.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation
import UIKit

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int

    struct Clouds: Codable {
        let all: Int?
    }

    struct Coord: Codable {
        let lon, lat: Double
    }

    struct Main: Codable {
        let temp, feels_like, temp_min, temp_max: Double
        let pressure, humidity: Int
    }

    struct Sys: Codable {
        let type, id: Int
        let country: String
        let sunrise, sunset: Int
    }

    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }

    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
    }
}
