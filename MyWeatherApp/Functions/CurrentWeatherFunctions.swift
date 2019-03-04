//
//  CurrentWeatherFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/25/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

func getCurrentHour() -> Int {
    let currentDate = DateHandler().currentDate()!
    let calendar = NSCalendar.autoupdatingCurrent
    return calendar.component(Calendar.Component.hour, from: currentDate)
}
