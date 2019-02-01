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
        rain: (inchToCm(inch: 2.0)*10).rounded()/10, snow: (inchToCm(inch: 1.0)*10).rounded()/10)
    var precip: Float = 40
    var uvIndex: Float = 4
    var locationAuthorization: Int = 0
    var systemType = 0  // 0: Imperial/English | 1: Metric
    var tempType = 0    // 0: ºF | 1: ºC
    
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

extension Settings {
    init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float, precipitation: Float, uvIndex: Float, locationAuth: Int, systemType: Int, tempType: Int){
        self.english = WeatherData.init(
            highTemp: highTemp,
            lowTemp: lowTemp,
            rain: rain,
            snow: snow)
        self.metric = WeatherData.init(
            highTemp: fahrenheitToCelsius(fromF: highTemp),
            lowTemp: fahrenheitToCelsius(fromF: lowTemp),
            rain: (inchToCm(inch: rain)*10).rounded()/10,
            snow: (inchToCm(inch: snow)*10).rounded()/10)
        self.precip = precipitation
        self.uvIndex = uvIndex
        self.locationAuthorization = locationAuth
        self.systemType = systemType
        self.tempType = tempType
    }
}
