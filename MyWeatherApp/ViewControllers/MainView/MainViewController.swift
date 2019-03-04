//
//  MainViewController.swift
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
    var buddy: Buddy!
    var buddyImageInitalLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buddyImageInitalLocation = buddyImage.center
        
        backgroundImage.image = imageBuilder(buddyName: buddy.settings.buddyType)
        buddyImage.image = imageBuilder(buddy: buddy)
    }
}
