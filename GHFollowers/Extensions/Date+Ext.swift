//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 02/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        formatted(.dateTime.month().year())
    }
}
