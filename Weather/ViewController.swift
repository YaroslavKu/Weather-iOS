//
//  ViewController.swift
//  Weather
//
//  Created by Slavik on 01.03.2020.
//  Copyright © 2020 Slavik. All rights reserved.
//

import UIKit

struct CityWeather: Decodable {
    var main: Main
}



struct Main: Decodable {
    var temp: Float
    var feels_like: Float
    var temp_min: Float
    var temp_max: Float
    var pressure: Int
    var humidity: Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var submitCityButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var condImage: UIImageView!
    @IBOutlet weak var condLabel: UILabel!
    
    let apiKey = "21896932f2e13d2867dd752a6f763afc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.text = "Miami"
        
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
                       self.tempLabel.text = "\(Int(cityWeather.main.temp))"
                       print(cityWeather.main.temp)
                    }
               } catch let error {
                   print(error)
               }
           }.resume()
    }
}

