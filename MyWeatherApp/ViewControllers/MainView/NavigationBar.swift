//
//  NavigationBar.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 9/24/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation
import UIKit

class NavigationBar: NavigationBarDelegate {
    let buttonName: [String] = ["NewBuddy", "Settings"]
    var parentViewController: UIViewController?
    var delegate: NavigationBarDelegate?
    var newBuddyButton: UIButton?
    var settingsButton: UIButton?
    
    func setUp(buddy: Buddy, parentViewController: UIViewController) {
        newBuddyButton = buttonConstructor(buddy: buddy, parentViewController: parentViewController, buttonType: 0)
        settingsButton = buttonConstructor(buddy: buddy, parentViewController: parentViewController, buttonType: 1)
    }
    
    func buttonTapped(sender: UIButton) {
        
    }
    
}

extension NavigationBar {
    func buttonConstructor(buddy: Buddy, parentViewController: UIViewController, buttonType: Int) -> UIButton {
        
        var newButton = UIButton.init(type: .custom)
        
        
        //MARK: Testing
        guard !testMode else {
            newButton.setImage(UIImage.init(named: "TestImage"), for: .normal)
            newButton.setImage(UIImage.init(named: "TestImage"), for: .disabled)
            functionCalled = true
            return newButton
        }
        
        newButton.adjustsImageWhenDisabled = true
        newButton.adjustsImageWhenHighlighted = false
        newButton.showsTouchWhenHighlighted = true
        
        if buttonType == 0 {
            newButton.setImage(UIImage.init(named: "newBuddy_\(buddy.settings.buddyType)"), for: .normal)
            newButton.setImage(UIImage.init(named: "newBuddy_\(buddy.settings.buddyType)"), for: .disabled)
        } else {
            newButton.setImage(UIImage.init(named: "settings_\(buddy.settings.buddyType)"), for: .normal)
            newButton.setImage(UIImage.init(named: "settings_\(buddy.settings.buddyType)"), for: .disabled)
        }
        
//        newButton = buttonConstructorConstraints(newButton: newButton, buttonType: buttonType, parentViewController: parentViewController)
        
        return newButton
    }
    
    func buttonConstructorConstraints(newButton: UIButton, buttonType: Int, parentViewController: UIViewController) -> UIButton {
        
        let margins = parentViewController.view.layoutMarginsGuide
        
        // Top Anchor
        newButton.topAnchor.constraint(greaterThanOrEqualTo: margins.topAnchor, constant: (CGFloat(navButtonDimensions.0/2))).isActive = true
        newButton.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant: (CGFloat(navButtonDimensions.1/2))).isActive = true
        // Width
        newButton.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(navButtonDimensions.0)).isActive = true
        newButton.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(navButtonDimensions.1)).isActive = true
        // Height
        newButton.widthAnchor.constraint(equalTo: newButton.widthAnchor).isActive = true
        // Margins
        if buttonType == 0 {    // newBuddy
            newButton.leftAnchor.constraint(greaterThanOrEqualTo: margins.leftAnchor, constant: (CGFloat(navButtonDimensions.0/2))).isActive = true
            newButton.leftAnchor.constraint(lessThanOrEqualTo: margins.leftAnchor, constant: (CGFloat(navButtonDimensions.1/2))).isActive = true
        } else {                // Settings
            newButton.rightAnchor.constraint(greaterThanOrEqualTo: margins.rightAnchor, constant: (CGFloat(navButtonDimensions.0/2))).isActive = true
            newButton.rightAnchor.constraint(lessThanOrEqualTo: margins.rightAnchor, constant: (CGFloat(navButtonDimensions.1/2))).isActive = true
        }
        
        return newButton
    }
}
