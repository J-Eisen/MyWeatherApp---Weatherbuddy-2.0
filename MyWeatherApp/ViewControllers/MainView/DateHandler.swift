//
//  DateHandler.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/25/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation
class DateHandler {
    
    func currentDate() -> Date! {
        if !testMode {
            return Date.init()
        } else {
            return Date.init(timeIntervalSince1970: TimeInterval(timeInterval))
        }
    }
}
