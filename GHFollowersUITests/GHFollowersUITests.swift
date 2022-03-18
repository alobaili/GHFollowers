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

    func testSearchScreen() throws {
        let textField = application.textFields["Enter a username"]
        XCTAssertTrue(textField.exists)
    }

    func testResultsScreenNavigationTitleMatchSearchedUser() throws {
        let textField = application.textFields["Enter a username"]
        
        textField.tap()
        
        textField.typeText("alobaili")
        
        let textFieldText = textField.value as! String

        application.tapKeyboardKey("Go")
        
        XCTAssertTrue(application.navigationBars[textFieldText].exists)
    }
}
