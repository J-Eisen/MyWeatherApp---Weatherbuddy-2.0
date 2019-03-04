//
//  NavBar.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/20/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation
import UIKit

class NavBar: NavigationBarDelegate {
    var delegate: NavigationBarDelegate?
    var parentViewController: UIViewController?
    
    func setUp(buddy: Buddy, parentViewController: UIViewController){
        self.parentViewController = parentViewController
        let navYPosition = UIApplication.shared.statusBarFrame.height
        let navWidth = UIApplication.shared.statusBarFrame.width
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: navYPosition, width: navWidth, height: navYPosition))
        
        
        var titleString: String
        titleString = "WeatherBuddy"
        let navItem = UINavigationItem(title: titleString)
        let settingsButton = UIBarButtonItem(image: UIImage(named: "Settings_\(buddy.settings.buddyType)"), style: .plain, target: nil, action: #selector(buttonTapped(sender:)))
        let storeButton = UIBarButtonItem(image: UIImage(named: "NewBuddy_\(buddy.settings.buddyType)"), style: .plain, target: nil, action: #selector(buttonTapped(sender:)))
        
        navItem.rightBarButtonItem = settingsButton
        navItem.leftBarButtonItem = storeButton
        navigationBar.setItems([navItem], animated: false)
    }
    
    @objc func buttonTapped(sender: UIBarButtonItem) {
        if sender.accessibilityIdentifier == "settingsButton" {
            parentViewController?.performSegue(withIdentifier: "rootToSettings", sender: nil)
        } else if sender.accessibilityIdentifier == "storeButton" {
            print("Storebutton Tapped")
        }
    }
}
