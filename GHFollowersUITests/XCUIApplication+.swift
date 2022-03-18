//
//  XCUIApplication+.swift
//  GHFollowersUITests
//
//  Created by Abdulaziz AlObaili on 18/03/2022.
//  Copyright © 2022 Abdulaziz AlObaili. All rights reserved.
//

import XCTest

extension XCUIApplication {
    /// Taps the specified keyboard key while handling the
    /// keyboard onboarding interruption, if it exists.
    /// - Parameter key: The keyboard key to tap.
    func tapKeyboardKey(_ key: String) {
        let key = self.keyboards.buttons[key]

        if key.isHittable == false {
            // Attempt to find and tap the Continue button
            // of the keyboard onboarding screen.
            self.buttons["Continue"].tap()
        }

        key.tap()
    }
}
