//
//  ErrorMessage.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 28/02/25.
//

import Foundation

enum GFErrorMessage: String, Error {
    case invalidUsername = "Inavlid username, please try again."
    case unableToComplete = "Unable to complete your request. Please try again."
    case invalidResposne = "Inavlid reponse. Please try again."
    case invalidData = "Invalid data. Please try again."
    case unableToFavourite = "There was a error adding this user to favourites. Please try again later."
    case alreadyfavourite = "Already in favourite, you must really like him..😊"
}
