//
//  OxfordAPIRequestURLStringTests.swift
//  OxfordAPIRequestURLStringTests
//
//  Created by Aleksander Makedonski on 1/31/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import XCTest
@testable import Scrambled_Messenger

class OxfordAPIRequestURLStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testWordListAPIRequestURLString(){
        
        let apiRequest = OxfordWordlistAPIRequest(withSourceLanguage: .English, withDomainFilters: [], withRegionFilters: [], withRegisterFilters: [], withTranslationsFilters: [], withLexicalCategoryFilters: [])
        
        let urlString = apiRequest.getURLString()
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/wordlist/en")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
