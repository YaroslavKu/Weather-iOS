//
//  ViewController.swift
//  Weather
//
//  Created by Slavik on 01.03.2020.
//  Copyright © 2020 Slavik. All rights reserved.
//

import UIKit
import CoreLocation

struct CityWeather: Decodable {
    var main: Main
    var weather: [Weather]
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Decodable {
    var temp: Float
    var feels_like: Float
    var temp_min: Float
    var temp_max: Float
    var pressure: Int
    var humidity: Int
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var submitCityButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var condImage: UIImageView!
    @IBOutlet weak var condLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let apiKey = "21896932f2e13d2867dd752a6f763afc"
    let dateFormatter = DateFormatter()
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.text = "Lviv"
        cityLabel.text = "Lviv"
        
        // Get current weekday
        dateFormatter.dateFormat = "EEEE"
        dayLabel.text = dateFormatter.string(from: Date())
        
        // Get current weather
        getWeather()
    }
    
    @IBAction func getWeather() {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityTextField.text!)&units=metric&APPID=\(apiKey)") else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
               guard let data = data else { return }
               guard error == nil else { return }
               
               do {
                   let cityWeather = try JSONDecoder().decode(CityWeather.self, from: data)
                    DispatchQueue.main.async {
                        self.cityLabel.text = self.cityTextField.text
                        self.tempLabel.text = "\(Int(cityWeather.main.temp))"
                        self.condLabel.text = cityWeather.weather[0].main
                        self.condImage.image = UIImage(named: cityWeather.weather[0].icon)
                    }
               } catch let error {
                   print(error)
               }
           }.resume()
    }
}

