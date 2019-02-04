//
//  JSON Struct.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

struct WeatherContainer: Decodable {
    let weatherData: [Weather]
    
    enum CodingKeys: String, CodingKey  {
        case weatherData = "hourly_forecast"
    }
}

struct Weather: Decodable {
    let hour: String
    let uvIndex: String
    let precipitation: String
    let tempActualEnglish: String
    let tempActualMetric: String
    let tempFeelslikeEnglish: String
    let tempFeelslikeMetric: String
    let rainEnglish: String
    let rainMetric: String
    let snowEnglish: String
    let snowMetric: String
    
    enum HourlyForecastKeys: String, CodingKey {
        case time = "FCTTIME"
        case temp
        case uvIndex = "uvi"
        case feelslike
        case rain = "qpf"
        case snow
        case precipitation = "pop"
    }
    enum TimeKeys: String, CodingKey {
        case hour
    }
    enum TempKeys: String, CodingKey {
        case tempActualEnglish = "english"
        case tempActualMetric = "metric"
    }
    enum FeelslikeKeys: String, CodingKey {
        case tempFeelslikeEnglish = "english"
        case tempFeelslikeMetric = "metric"
    }
    enum RainKeys: String, CodingKey {
        case rainEnglish = "english"
        case rainMetric = "metric"
    }
    enum SnowKeys: String, CodingKey {
        case snowEnglish = "english"
        case snowMetric = "metric"
    }
    
    init(from decoder: Decoder) throws {
        //        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let hourlyForecast = try decoder.container(keyedBy: HourlyForecastKeys.self)
        uvIndex = try hourlyForecast.decode(String.self, forKey: .uvIndex)
        precipitation = try hourlyForecast.decode(String.self, forKey: .precipitation)
        
        let time = try hourlyForecast.nestedContainer(keyedBy: TimeKeys.self, forKey: .time)
        hour = try time.decode(String.self, forKey: .hour)
        
        let temp = try hourlyForecast.nestedContainer(keyedBy: TempKeys.self, forKey: .temp)
        tempActualEnglish = try temp.decode(String.self, forKey: .tempActualEnglish)
        tempActualMetric = try temp.decode(String.self, forKey: .tempActualMetric)
        
        let feelslike = try hourlyForecast.nestedContainer(keyedBy: FeelslikeKeys.self, forKey: .feelslike)
        tempFeelslikeEnglish = try feelslike.decode(String.self, forKey: .tempFeelslikeEnglish)
        tempFeelslikeMetric = try feelslike.decode(String.self, forKey: .tempFeelslikeMetric)
        
        let rain = try hourlyForecast.nestedContainer(keyedBy: RainKeys.self, forKey: .rain)
        rainEnglish = try rain.decode(String.self, forKey: .rainEnglish)
        rainMetric = try rain.decode(String.self, forKey: .rainMetric)
        
        let snow = try hourlyForecast.nestedContainer(keyedBy: SnowKeys.self, forKey: .snow)
        snowEnglish = try snow.decode(String.self, forKey: .snowEnglish)
        snowMetric = try snow.decode(String.self, forKey: .snowMetric)
    }
}
