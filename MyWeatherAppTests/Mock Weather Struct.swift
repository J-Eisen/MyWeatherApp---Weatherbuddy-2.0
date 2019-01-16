//
//  Mock Weather Struct.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/15/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

struct MockWeather {
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
    
    init(hour: String, uvIndex: String, precipitation: String, tempActualEnglish: String, tempActualMetric: String, tempFeelslikeEnglish: String, tempFeelslikeMetric: String, rainEnglish: String, rainMetric: String, snowEnglish: String, snowMetric: String) {
        self.hour = hour
        self.uvIndex = uvIndex
        self.precipitation = precipitation
        self.tempActualEnglish = tempActualEnglish
        self.tempActualMetric = tempActualMetric
        self.tempFeelslikeEnglish = tempFeelslikeEnglish
        self.tempFeelslikeMetric = tempFeelslikeMetric
        self.rainEnglish = rainEnglish
        self.rainMetric = rainMetric
        self.snowEnglish = snowEnglish
        self.snowMetric = snowMetric
    }
}
