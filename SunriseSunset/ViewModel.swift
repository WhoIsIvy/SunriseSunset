//
//  ViewModel.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import UIKit

struct SunModel {
    let city: String
    let country: String
    let sunrise: String
    let sunset: String

    var cityAndCountry: String {
        "\(city), \(country)"
    }

    var sunriseTime: String {
        "\(String(localizationKey: .sunrise)): \(sunrise)"
    }

    var sunsetTime: String {
        "\(String(localizationKey: .sunset)): \(sunset)"
    }
}

class ViewModel {
    let backgroundImage = Constants.backgroundImage

    private let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.copperPlateBold(size: 48),
        .foregroundColor: UIColor.black
    ]

    var sunriseTitle: NSAttributedString {
        .init(string: String(localizationKey: .sunrise), attributes: titleAttributes)
    }

    var sunsetTitle: NSAttributedString {
        .init(string: String(localizationKey: .sunset), attributes: titleAttributes)
    }

    var zipPlaceholder: String {
        .init(localizationKey: .zipPlaceholder)
    }

    var disclaimerAttributed: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]

        return .init(string: String(localizationKey: .disclaimer), attributes: attributes)
    }

    var displayInvalidZipCodeAlert: ((NSAttributedString) -> Void)?

    func attributed(for text: String, ofType type: AttributedType) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: type.size, weight: .thin),
            .foregroundColor: UIColor.black
        ]

        return .init(string: text, attributes: attributes)
    }

    private func zipAlert(from text: String) {
        let attributed = attributed(for: text, ofType: .additionalInfo)
        displayInvalidZipCodeAlert?(attributed)
    }

    private func getValidZipcode(from string: String) -> Int? {
        guard !string.isEmpty else {
            zipAlert(from: .init(localizationKey: .emptyZip))
            return nil
        }

        guard string.count == 5 else {
            zipAlert(from: .init(localizationKey: .zipInvalidDigitCount))
            return nil
        }

        guard let zipCode = Int(string) else {
            zipAlert(from: .init(localizationKey: .zipInvalidDigit))
            return nil
        }

        return zipCode
    }

    func retrieveSunTimes(for zipString: String,
                          urlSession: URLSession = .init(configuration: .default),
                          completion: @escaping (SunModel?, CustomError?) -> Void) {
        guard let validZipCode = getValidZipcode(from: zipString) else { return }

        GeocodingAPI.fetchCoordinates(for: validZipCode, urlSession: urlSession) { geoData, error in
            guard let geoData = geoData, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error as? CustomError ?? .unknown)
                }
                return
            }

            TimeAPI.fetchTimeInfo(lat: geoData.lat,
                                  lon: geoData.lon,
                                  urlSession: urlSession) { timeData, error in
                guard let timeData = timeData, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, error as? CustomError ?? .unknown)
                    }
                    return
                }

                DispatchQueue.main.async {
                    let sunModel = SunModel(
                        city: geoData.name,
                        country: geoData.country,
                        sunrise: timeData.results.sunrise,
                        sunset: timeData.results.sunset
                    )
                    completion(sunModel, nil)
                }
            }
        }
    }
}

extension ViewModel {
    enum AttributedType {
        case sunTime
        case additionalInfo

        var size: CGFloat {
            self == .sunTime ? 48 : 24
        }
    }
}

#if DEBUG
extension ViewModel {
    func testZipCodeValidation(_ zipString: String) -> Int? {
        getValidZipcode(from: zipString)
    }
}
#endif
