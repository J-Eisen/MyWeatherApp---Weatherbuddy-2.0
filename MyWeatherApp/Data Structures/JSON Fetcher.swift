//
//  JSON Fetcher.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

let apiKeyString = "fb2d4e978c2c2a11"
let testString = "://MyWeatherApp/MyWeatherAppTests/MockJSON.JSON"
var testMode = false;
var urlString = "https://api.wunderground.com/api/"

func fetch(location: Int, testMode: Bool, completionHandler: @escaping ([Weather]?) -> Void) {
    var weatherData: WeatherContainer?
    if testMode == true {
        urlString = testString
    }
    else {
        urlString.append("\(apiKeyString)/hourly/q/")
        urlString.append("\(location).json")
        
    }
    
    guard let url = URL(string: urlString) else {
        print("Error: could not create URL")
        return
    }
    let urlRequest = URLRequest(url: url)
    
    // session set up
    let session = URLSession.shared
    
    //make the request
    
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
