//
//  BuddyFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/25/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit


// Buddy Screen Tap Checks
func tapCheck(tap: CGPoint, target: CGRect) -> Bool {
    var result = false
    if tap.x > target.minX && tap.x < target.maxX
        && tap.y > target.minY && tap.y < target.maxY { result = true}
    return result
}

func tapCheck(tap: CGPoint, targetX: CGRect, targetY: CGRect) -> Bool {
    var result = false
    if tap.x > targetX.minX && tap.x < targetX.maxX
        && tap.y > targetY.minY && tap.y < targetY.maxY { result = true}
    return result
}

func tapCheck(tap: CGPoint, targetY1: CGRect, targetY2: CGRect) -> Bool {
    var result = false
    var minPoint: CGPoint = CGPoint.init(x: targetY2.minX, y: targetY2.minY)
    var maxPoint: CGPoint = CGPoint.init(x: targetY2.maxX, y: targetY2.maxY)
    
    // Checking if X update needed
    if targetY1.maxX > targetY2.maxX {
        maxPoint.x = targetY1.maxX
    }
    if targetY1.minX > targetY2.minX {
        minPoint.x = targetY1.minX
    }
    // Checking if Y update needed
    if targetY1.maxY > targetY2.maxY {
        maxPoint.y = targetY1.maxY
    }
    if targetY1.minY > targetY2.minY {
        minPoint.y = targetY1.minY
    }
    
    // Checking tap vs target
    if tap.x > minPoint.x && tap.x < maxPoint.x
        && tap.y > minPoint.y && tap.y < maxPoint.y { result = true }
    return result
}


/////////////
func updateBuddyLabels(buddy: Buddy, labels: [UILabel]) -> [UILabel] {
    for label in labels {
        label.isHidden = true
    }
    print("Updating Labels...")
    labels[3].isHidden = true
    for index in 0...(orderedClothing.count-1) {
        if index < 4 && buddy.clothing[orderedClothing[index]]!{
            labels[0].text = orderedClothing[index]
            labels[0].isHidden = false
        } else if index > 5 && buddy.clothing[orderedClothing[index]]!{
            labels[3].text = orderedClothing[index]
            labels[3].isHidden = false
        } else if orderedClothing[index] == "Sunscreen" || orderedClothing[index] == "Umbrella" {
            labels[index-3].isHidden = !buddy.clothing[orderedClothing[index]]!
        }
    }
    print(buddy.clothing)
    return labels
}

// Creating Strings to call the Proper Image
// All image names and string should be formatted as follows:
// [BuddyName]_[OutfitName]_[Umbrella]_[Sunscreen]_[Boots]
// (Last 3 are optional)

func imageBuilder(buddy: Buddy) -> UIImage {
    var image = "\(buddy.settings.buddyType)"
    for clothes in orderedClothing {
        if buddy.clothing[clothes] ?? false {
            image.append("_\(clothes)")
        }
    }
    if image == buddy.settings.buddyType {
        image.append("_Thinking")
    }
    print("Image Called: \(image)")
    return UIImage.init(named: image)!
}

func imageBuilder(buddyName: String) -> UIImage {
    let image = "\(buddyName)_Background"
    print("Image Called: \(image)")
    return UIImage.init(named: image)!
}
