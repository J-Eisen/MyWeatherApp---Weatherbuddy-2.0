//
//  NavigationBarDelegate.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/20/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationBarDelegate {
    var parentViewController: UIViewController? { get }
    func setUp(buddy: Buddy, parentViewController: UIViewController)
//    func buttonTapped(sender: UIBarButtonItem)
}
