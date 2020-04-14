//
//  GHFollowersUITests.swift
//  GHFollowersUITests
//
//  Created by Abdulaziz AlObaili on 14/04/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import XCTest

class GHFollowersUITests: XCTestCase {
    
    let application = XCUIApplication()

    override func setUpWithError() throws {

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        application.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchScreen() throws {
        let textField = application.textFields["Enter a username"]
        XCTAssertTrue(textField.exists)
    }
    
    // Test that the search result screen's navigation bar title is the same as the text field's text in the search screen.
    func testResultsScreenNavigationTitle() throws {
        let textField = application.textFields["Enter a username"]
        
        textField.tap()
        
        textField.typeText("alobaili")
        
        let textFieldText = textField.value as! String
        
        application.buttons["Go"].tap()
        
        XCTAssertTrue(application.navigationBars[textFieldText].exists)
    }
    
    
}
