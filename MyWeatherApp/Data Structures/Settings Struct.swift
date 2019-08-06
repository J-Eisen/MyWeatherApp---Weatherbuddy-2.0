//
//  Settings Struct.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/17/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

struct Settings {
    var english: WeatherData = WeatherData.init(highTemp: defaultSettingsFloats[0], lowTemp: defaultSettingsFloats[1], rain: defaultSettingsFloats[2], snow: defaultSettingsFloats[3])
    var metric: WeatherData = WeatherData.init(
        highTemp: fahrenheitToCelsius(fromF: defaultSettingsFloats[0]),
        lowTemp: fahrenheitToCelsius(fromF: defaultSettingsFloats[1]),
        rain: (inchToCm(inch: defaultSettingsFloats[2])*10).rounded()/10, snow: (inchToCm(inch: defaultSettingsFloats[3])*10).rounded()/10)
    var precip: Float = defaultSettingsFloats[4]
    var uvIndex: Float = defaultSettingsFloats[5]
    var dayStart: Int = defaultSettingsInts[3]
    var dayEnd: Int = defaultSettingsInts[4]
    var zipcode: Double = defaultZipcode
    var locationAuthorization: Int = defaultSettingsInts[0]
    var locationPreferences: [Bool] = defaultSettingsBools
    var systemType = defaultSettingsInts[1]  // 0: Imperial/English | 1: Metric
    var tempType = defaultSettingsInts[2]    // 0: ºF | 1: ºC
    var buddyType: String = defaultBuddyType
    
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
    init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float, precipitation: Float, uvIndex: Float, zipcode: Double, locationAuth: Int, gpsSwitch: Bool, zipcodeSwitch: Bool, systemType: Int, tempType: Int, dayStart: Int, dayEnd: Int, buddy: String){
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
        self.zipcode = zipcode
        self.locationAuthorization = locationAuth
        self.systemType = systemType
        self.tempType = tempType
        self.dayStart = dayStart
        self.dayEnd = dayEnd
        self.locationPreferences[0] = gpsSwitch
        self.locationPreferences[1] = zipcodeSwitch
        self.buddyType = buddy
    }
}
