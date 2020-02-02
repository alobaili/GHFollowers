//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 02/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        
        return date.convertToMonthYearFormat()
    }
    
}
