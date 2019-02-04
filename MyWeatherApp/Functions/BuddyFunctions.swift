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
    print("Updating Labels...")
    labels[3].isHidden = true
    for index in 0...(orderedClothing.count-1) {
        if index < 4 && buddy.clothing[orderedClothing[index]]!{
            labels[0].text = orderedClothing[index]
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
