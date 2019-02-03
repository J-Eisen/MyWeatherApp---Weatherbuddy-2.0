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
    var dayEnd: Int = 8
    var dayStart: Int = 19
    var locationAuthorization: Int = 0
    var locationPreferences: [Bool] = [true, true]
    var systemType = 0  // 0: Imperial/English | 1: Metric
    var tempType = 0    // 0: ºF | 1: ºC
    
    struct WeatherData {
        var highTemp: Float
        var lowTemp: Float
        var rain: Float
        var snow: Float
        
        init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float) {
            self.highTemp = highTemp
            self.lowTemp = lowTemp
            self.rain = rain
            self.snow = snow
        }
    }
}

extension Settings {
    init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float, precipitation: Float, uvIndex: Float, locationAuth: Int, gpsSwitch: Bool, zipcodeSwitch: Bool, systemType: Int, tempType: Int, dayStart: Int, dayEnd: Int){
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
        self.dayStart = dayStart
        self.dayEnd = dayEnd
        self.locationPreferences[0] = gpsSwitch
        self.locationPreferences[1] = zipcodeSwitch
    }
}
