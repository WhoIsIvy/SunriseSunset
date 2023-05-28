//
//  TimeAPI.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import Foundation

struct TimeData: Codable {
    let results: TimeResults
}

struct TimeResults: Codable {
    let sunrise: String
    let sunset: String
}

enum TimeAPI {
    static let baseURL = "https://api.sunrise-sunset.org/json"

    static func timeURL(lat: Float, lon: Float) -> String {
        "\(baseURL)?lat=\(lat)&lon=\(lon)"
    }

    static func fetchTimeInfo(lat: Float, lon: Float,
                              urlSession: URLSession = .init(configuration: .default),
                              completion: @escaping (TimeData?, Error?) -> Void) {
        guard let url = URL(string: timeURL(lat: lat, lon: lon)) else {
            completion(nil, CustomError.badURL)
            return
        }

        let task = urlSession.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }

                do {
                    let timeData = try JSONDecoder().decode(TimeData.self, from: data)
                    completion(timeData, nil)
                } catch {
                    completion(nil, error)
                }
            }

        task.resume()
    }
}

#if DEBUG
extension TimeData {
    static var testDataString: String {
        """
        {
            "results": {
                "sunrise": "\(MockConstants.sunrise)",
                "sunset": "\(MockConstants.sunset)"
            }
        }
        """
    }
}

extension TimeResults {
    static var testDataString: String {
        """
        {
            "sunrise": "\(MockConstants.sunrise)",
            "sunset": "\(MockConstants.sunset)"
        }
        """
    }
}
#endif
