//
//  GFError.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 31/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data recieved from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You already favorited this user. You must REALLY like them!"
    
    var localizedDescription: String {
        switch self {
            case .invalidUsername: return NSLocalizedString("Invalid Username Body", comment: "This username created an invalid request. Please try again.")
            case .unableToComplete: return NSLocalizedString("Unable To Complete Body", comment: "Unable to complete your request. Please check your internet connection.")
            case .invalidResponse: return NSLocalizedString("Invalid Response Body", comment: "Invalid response from the server. Please try again.")
            case .invalidData: return NSLocalizedString("Invalid Data Body", comment: "The data recieved from the server was invalid. Please try again.")
            case .unableToFavorite: return NSLocalizedString("Unable To Favorite Body", comment: "There was an error favoriting this user. Please try again.")
            case .alreadyInFavorites: return NSLocalizedString("Already In Favorites Body", comment: "You already favorited this user. You must REALLY like them!")
        }
    }
    
}
