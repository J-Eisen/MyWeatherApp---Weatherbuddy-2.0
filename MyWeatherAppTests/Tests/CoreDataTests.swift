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
        testMode = true
    }

    override func tearDown() {
        testMode = false
    }

    func test_getManagedContext(){
        let resultMC = getManagedContext()
        let expectedMC = NSManagedObjectContext.init(concurrencyType: <#T##NSManagedObjectContextConcurrencyType#>)
        XCTAssertEqual(expectedMC, resultMC)
    }
    
    func test_saveData(){
        
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
