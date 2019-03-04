//
//  RootViewChildren.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/20/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

class RootViewChildren: PageViewChildrenDelegate {
    var childViewControllers: [UIViewController] = []
    
    func initializeChildren(names: [String], buddy: Buddy) {
        for name in names {
            addNewChild(name: name, buddy: buddy)
        }
    }
    
    func addNewChild(name: String, buddy: Buddy) {
        var newVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(name)ViewController")
        if newVC is MainViewController {
            let mainVC = newVC as! MainViewController
            mainVC.buddy = buddy
            newVC = mainVC
        } else if newVC is CurrentWeatherViewController {
            let weatherVC = newVC as! CurrentWeatherViewController
            weatherVC.buddy = buddy
            newVC = weatherVC
        }
        childViewControllers.append(newVC)
    }
    
    func updateChild(child: UIViewController, buddy: Buddy, weather: [Weather]?) {
        if child is MainViewController {
            let mainVC = child as! MainViewController
            mainVC.buddy = buddy
            mainVC.buddyImage.image = imageBuilder(buddy: buddy)
        } else if child is CurrentWeatherViewController {
            let weatherVC = child as! CurrentWeatherViewController
            weatherVC.weatherArray = weather
            weatherVC.buddy = buddy
        }
    }
    
    func updateAllChildren(buddy: Buddy, weather: [Weather]) {
        for child in childViewControllers {
            updateChild(child: child, buddy: buddy, weather: weather)
        }
    }
}
