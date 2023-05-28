//
//  CustomError.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import Foundation

enum CustomError: Error {
    case invalidLocation
    case invalidTimes
    case badURL
    case unknown

    var title: String {
        String(localizationKey: .errorText)
    }
}

extension CustomError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidLocation:
            return String(localizationKey: .invalidLocation)
        case .invalidTimes:
            return String(localizationKey: .invalidTimes)
        default:
            return String(localizationKey: .unknownErrorText)
        }
    }
}
