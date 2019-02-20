//
//  BuddyFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/25/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

/*
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
 */

// Creating Strings to call the Proper Image
// All image names and string should be formatted as follows:
// [BuddyName]_[OutfitName]_[Umbrella]_[Sunscreen]_[Boots]
// (Last 3 are optional)

func imageBuilder(buddy: Buddy) -> UIImage {
    let imageString: String!
    if buddy.settings.buddyType == "TestBuddy" {
        imageString = "TestImage"
    } else {
        imageString = makeImage(buddy: buddy)
    }
    return UIImage.init(named: imageString)!
}

func imageBuilder(buddyName: String) -> UIImage {
    let imageString: String!
    if buddyName == "TestBuddy" {
        imageString = "TestImage"
    } else {
        imageString = makeImage(buddyName: buddyName)
    }
    return UIImage.init(named: imageString)!
}

func makeImage(buddyName: String) -> String {
    return "\(buddyName)_Background"
}

func makeImage(buddy: Buddy) -> String {
    var image = "\(buddy.settings.buddyType)" as String
    for clothes in orderedClothing {
        // Skip Rainboots if both rainboots = true && snowboots = true
        if clothes == "Rainboots" && buddy.clothing["Snowboots"]! &&  buddy.clothing["Rainboots"]! { }
        else if buddy.clothing[clothes] ?? false {
            image.append("_\(clothes)")
        }
    }
    if image == buddy.settings.buddyType {
        image.append("_Thinking")
    }
    return image
}
