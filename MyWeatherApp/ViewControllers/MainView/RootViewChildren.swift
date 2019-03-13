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
    var childCount: Int = 0
    lazy var functionCalled: String = ""
    
    func initializeChildren(names: [String], buddy: Buddy) {
        for name in names {
            if !testMode {
                addNewChild(name: name, buddy: buddy)
            } else {
                childCount += 1
            }
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
            if !testMode {
                let mainVC = child as! MainViewController
                mainVC.buddy = buddy
                mainVC.buddyImage.image = imageBuilder(buddy: buddy)
            } else {
                functionCalled = "updateChild_MainViewController"
            }
        } else if child is CurrentWeatherViewController {
            if !testMode {
                let weatherVC = child as! CurrentWeatherViewController
                weatherVC.weatherArray = weather
                weatherVC.buddy = buddy
            } else {
                functionCalled = "updateChild_CurrentWeatherViewController"
            }
        }
    }
    
    func updateAllChildren(buddy: Buddy, weather: [Weather]) {
        for child in childViewControllers {
            if !testMode {
                updateChild(child: child, buddy: buddy, weather: weather)
            }
            else {
                childCount += 1
            }
        }
    }
}
