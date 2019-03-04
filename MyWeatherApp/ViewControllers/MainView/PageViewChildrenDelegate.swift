//
//  PageViewChildrenDelegate.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/20/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

protocol PageViewChildrenDelegate {
    var childViewControllers: [UIViewController] { get }
    func initializeChildren(names: [String], buddy: Buddy)
    func addNewChild(name: String, buddy: Buddy)
    func updateChild(child: UIViewController, buddy: Buddy, weather: [Weather]?)
    func updateAllChildren(buddy: Buddy, weather: [Weather])
}
