//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var buddyImage: UIImageView!
    
    var location = defaultLocation
    var testMode = false
    var buddy: Buddy!
    var initalLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalLocation = super.view.center
        
        backgroundImage.image = imageBuilder(buddyName: buddy.settings.buddyType)
        buddyImage.image = imageBuilder(buddy: buddy)
    }
    
    /* Reimpliment when basics are working
    @IBAction func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .changed {
            if recognizer.location(in: super.view).y > initalLocation.y { // Down Drag
                let translateY = recognizer.translation(in: super.view).y
                super.view.center.y += translateY
                if super.view.center.y > initalLocation.y + 100 {
                    super.view.center.y = initalLocation.y + 100
                }
                reloadViewAfterFetch()
            }
        } else if recognizer.state == .ended {
            super.view.center = initalLocation
        }
    }*/
}
