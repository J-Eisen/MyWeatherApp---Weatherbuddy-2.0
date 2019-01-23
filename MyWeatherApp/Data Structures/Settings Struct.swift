//
//  Settings Struct.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/17/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

struct Settings {
    var english: WeatherData = WeatherData.init(highTemp: 80, lowTemp: 40, rain: 2.0, snow: 1.0)
    var metric: WeatherData = WeatherData.init(
        highTemp: fahrenheitToCelsius(fromF: 80),
        lowTemp: fahrenheitToCelsius(fromF: 40),
        rain: inchToCm(inch: 2.0), snow: inchToCm(inch: 1.0))
    var percip: Float = 40
    var uvIndex: Float = 4
    
    struct WeatherData {
        var highTemp: Float = 0.0
        var lowTemp: Float = 0.0
        var rain: Float = 0.0
        var snow: Float = 0.0
        
        init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float) {
            self.highTemp = highTemp
            self.lowTemp = lowTemp
            self.rain = rain
            self.snow = snow
        }
    }
}
