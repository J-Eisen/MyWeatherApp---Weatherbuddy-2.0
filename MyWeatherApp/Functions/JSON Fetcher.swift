//
//  JSON Fetcher.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

let apiKeyString = "fb2d4e978c2c2a11"
let testString = "/MyWeatherAppTests/MockJSON.JSON"
var urlString = "https://api.wunderground.com/api/"

func fetch(location: (Double, Double), completionHandler: @escaping ([Weather]?) -> Void) {
    var weatherData: WeatherContainer?
    if testMode == true {
        urlString = testString
    }
    else {
        urlString.append("\(apiKeyString)/hourly/q/")
        if location.0 == 0 && location.1 == 0 {
            urlString.append("\(defaultLocation).json")
            print("Error: No location found")
        } else if location.1 == 0 {
            urlString.append("\(round(location.0)).json")
        } else {
            urlString.append("\(round((location.0)*10)/10),\(round((location.1)*10)/10).json")
        }
    }
    
    guard let url = URL(string: urlString) else {
        print("Error: could not create URL")
        return
    }
    let urlRequest = URLRequest(url: url)
    
    // Session set up
    let session = URLSession.shared
    
    // Make the request
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        guard error == nil else {
            print ("Error - Fetch")
            return
        }
        guard let responseData = data else {
            print("Error - no data")
            return
        }
        let decoder = JSONDecoder()
        do {
            weatherData = try decoder.decode(WeatherContainer.self, from: responseData)
            print("JSON Check...:")
            for weather in (weatherData?.weatherData)! {
                print("\(weather.hour) \(weather.tempActualEnglish) \(weather.tempActualMetric)")
            }
            completionHandler(weatherData?.weatherData)
        } catch {
            print("Error - parsing JSON")
            print(error)
            return
        }
    }
    task.resume()
}
