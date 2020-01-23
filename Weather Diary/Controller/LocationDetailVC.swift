//
//  LocationDetailVC.swift
//  Weather Diary
//
//  Created by Spencer Halverson on 1/22/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit

class LocationDetailVC: UITableViewController {
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.title = " "
        configureView()
    }

    func configureView() {
        
        if let city = location?.city, let state = location?.state {
            navigationItem.title = "Weather for \(city), \(state)"
        }
        
        if let weatherDescription = location?.weather?.weather
            .map({ $0.description })
            .joined(separator: ", ") {
            details.text = "Today's weather looks like: \(weatherDescription)"
        }
        
        temp.text = location?.weather?.main.temp.farenheit
        name.text = location?.weather?.name
        sunrise.text = location?.weather?.sys.sunrise.time
        sunset.text = location?.weather?.sys.sunset.time
        feelsLike.text = location?.weather?.main.feels_like.farenheit
        tempMin.text = location?.weather?.main.temp_min.farenheit
        tempMax.text = location?.weather?.main.temp_max.farenheit
        humidity.text = location?.weather?.main.humidity.percent
        visibility.text = location?.weather?.visibility.miles
        wind.text = "\(Int(location?.weather?.wind.speed ?? 0)) mph"
        pressure.text = location?.weather?.main.pressure.hg
        clouds.text = location?.weather?.clouds.all?.percent

        if let icon = location?.weather?.weather.first?.icon,
            let iconUrl = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") {
            iconView.sd_setImage(with: iconUrl, completed: nil)
        }
    }
}

extension Double {
    
    var farenheit: String {
        return " \(Int(self))\u{00B0}"
    }
}

extension Int {
    
    var percent: String {
        return "\(self)%"
    }
    
    var miles: String {
        let m = self / 5280
        return "\(m) mi"
    }
    
    var time: String {
        let interval = Double(self)
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var hg: String {
        let d = Double(self) / 100.0
        return "\(d) inHg"
    }
}

