//
//  CoreDataTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/4/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
import CoreData
@testable import MyWeatherApp

class CoreDataTests: XCTestCase {
    
    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchData() {
        let fetchResults = fetchData(entityString: "SettingsSave")
        XCTAssertNotNil(fetchResults)
    }
    
    func test_saveBuddy(){
        
    }
    
    func test_saveSettings(){
        
    }
    
    func test_loadBuddy() {
        
    }
    
    func test_loadSettings(){
        
    }
}
