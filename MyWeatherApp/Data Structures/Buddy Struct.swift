//
//  Buddy Struct.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/16/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

struct Buddy {
    var location: (Double, Double)
    var clothing: [String: Bool]
    var rawData: RawData
    var settings: Settings
    
    struct RawData {
        var english: WeatherData = WeatherData.init()
        var metric: WeatherData = WeatherData.init()
        var precip: Float
        var uvIndex: Float
        
        init(englishHighTemp: Float, englishLowTemp: Float, englishRain: Float, englishSnow: Float,
         metricHighTemp: Float, metricLowTemp: Float, metricRain: Float, metricSnow: Float,
         precip: Float, uvIndex: Float) {
            self.english.highTemp = englishHighTemp
            self.english.lowTemp = englishLowTemp
            self.english.rain = englishRain
            self.english.snow = englishSnow
            self.metric.highTemp = metricHighTemp
            self.metric.lowTemp = metricLowTemp
            self.metric.rain = metricRain
            self.metric.snow = metricSnow
            self.precip = precip
            self.uvIndex = uvIndex
        }
        
        init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float, precip: Float, uvIndex: Float) {
            self.english.highTemp = highTemp
            self.english.lowTemp = lowTemp
            self.english.rain = rain
            self.english.snow = snow
            self.metric.highTemp = fahrenheitToCelsius(fromF: highTemp)
            self.metric.lowTemp = fahrenheitToCelsius(fromF: lowTemp)
            self.metric.rain = inchToCm(inch: rain)
            self.metric.snow = inchToCm(inch: snow)
            self.precip = precip
            self.uvIndex = uvIndex
        }
        
        struct WeatherData {
            var highTemp: Float
            var lowTemp: Float
            var rain: Float
            var snow: Float
            
            init() {
                self.highTemp = 0.0
                self.lowTemp = 100.0
                self.rain = 0.0
                self.snow = 0.0
            }
            
            init(highTemp: Float, lowTemp: Float, rain: Float, snow: Float) {
                self.highTemp = highTemp
                self.lowTemp = lowTemp
                self.rain = rain
                self.snow = snow
            }
        }
    }
}

extension Buddy {
    init(location: Double) {
        self.location = (location, 0)
        self.rawData = RawData.init(highTemp: 0, lowTemp: 100, rain: 0, snow: 0, precip: 0, uvIndex: 0)
        self.settings = Settings.init()
        self.clothing = staticClothing
        print("Buddy Init Complete!")
    }
    
    init(latitude: Double, longitude: Double, highTemp: Float, lowTemp: Float, rain: Float, snow: Float, precip: Float, uvIndex: Float, settings: Settings) {
        self.location = (latitude, longitude)
        self.rawData = RawData.init(highTemp: highTemp, lowTemp: lowTemp, rain: rain, snow: snow, precip: precip, uvIndex:uvIndex)
        self.settings = settings
        self.clothing = staticClothing
        print("Buddy Init Complete!")
    }
}


extension Buddy {
    mutating func updateBuddy(newWeatherArray: [Weather]){
        print("Updating Buddy...")
        var outOfBounds = false
        var index = 0
        if Int(newWeatherArray[index].hour)! >= settings.dayEnd ||
           Int(newWeatherArray[index].hour)! <= settings.dayStart {
            outOfBounds = true
        }
        repeat{
            if Int(newWeatherArray[index].hour)! <= settings.dayStart
                && Int(newWeatherArray[index].hour)! >= settings.dayEnd
                && outOfBounds {
                outOfBounds = false
            }
            rawWeatherUpdate(newWeatherData: newWeatherArray[index])
            index += 1
        }while(outOfBounds && Int(newWeatherArray[index].hour)! <= settings.dayEnd)
        clothingUpdate()
        print("Buddy Update Complete!")
        print("Raw Data Check")
        print(self.rawData.precip)
        print(self.rawData.english)
        print(self.rawData.metric)
        print(self.rawData.uvIndex)
    }
    
    mutating func rawWeatherUpdate(newWeatherData: Weather){
        if Float(newWeatherData.precipitation)! > rawData.precip {
            rawData.precip = Float(newWeatherData.precipitation)!
        }
        if Float(newWeatherData.rainEnglish)! > rawData.english.rain {
            rawData.english.rain = Float(newWeatherData.rainEnglish)!
            rawData.metric.rain = Float(newWeatherData.rainMetric)!
        }
        if Float(newWeatherData.snowEnglish)! > rawData.english.snow {
            rawData.english.snow = Float(newWeatherData.snowEnglish)!
            rawData.metric.snow = Float(newWeatherData.snowMetric)!
        }
        if Float(newWeatherData.tempFeelslikeEnglish)! > rawData.english.highTemp {
            rawData.english.highTemp = Float(newWeatherData.tempFeelslikeEnglish)!
            rawData.metric.highTemp = Float(newWeatherData.tempFeelslikeMetric)!
        }
        if Float(newWeatherData.tempFeelslikeEnglish)! < rawData.english.lowTemp {
            rawData.english.lowTemp = Float(newWeatherData.tempFeelslikeEnglish)!
            rawData.metric.lowTemp = Float(newWeatherData.tempFeelslikeMetric)!
        }
        if Float(newWeatherData.uvIndex)! > rawData.uvIndex {
            rawData.uvIndex = Float(newWeatherData.uvIndex)!
        }
    }
    
    mutating func clothingUpdate(){
        print("Updating Clothing...")
        for item in clothing {
            clothing[item.key] = false
        }
        if rawData.english.lowTemp >= settings.english.highTemp {
            clothing["Hot Outfit"] = true
        } else if rawData.english.highTemp <= settings.english.highTemp
            && rawData.english.lowTemp >= settings.english.lowTemp {
            clothing["Medium Outfit"] = true
        } else if rawData.english.highTemp <= settings.english.lowTemp {
            clothing["Heavy Coat"] = true
        } else if rawData.english.lowTemp <= settings.english.lowTemp {
            clothing["Light Coat"] = true
        }
        if rawData.uvIndex >= settings.uvIndex {
            clothing["Sunglasses"] = true
        }
        if rawData.precip >= settings.precip {
            clothing["Umbrella"] = true
        }
        if rawData.english.rain >= settings.english.rain {
            clothing["Rainboots"] = true
        }
        if rawData.english.snow >= settings.english.snow {
            clothing["Snowboots"] = true
        }
        print("Clothing Update Complete")
        print(self.clothing)
    }
}
