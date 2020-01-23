//
//  LocationFetchController.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import Foundation

class LocationFetchController {
    
    private let apikey: String = "c2d2dcee438f902d23984c439b29bd34"
    
    func getWeather(at zipcode: String, completion: @escaping ((WeatherResponse?, String?) -> Void)) {
        
        guard var urlComps = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else {
            completion(nil, "Invalid URL")
            return
        }
        
        urlComps.queryItems = [
            URLQueryItem(name: "zip", value: "\(zipcode),us"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: apikey)
        ]
        
        var request = URLRequest(url: urlComps.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept":"application/json"]
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            
            DispatchQueue.main.async {

                guard let data = data else {
                    completion(nil, error?.localizedDescription);
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    print("PARSED RESPONSE: ", weatherResponse)
                    completion(weatherResponse, nil)
                } catch let error {
                    print("PARSING ERROR: ", error)
                    completion(nil, error.localizedDescription)
                }
            }
            
        }).resume()
    }
    
}
