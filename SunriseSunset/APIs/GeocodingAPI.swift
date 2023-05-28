//
//  GeocodingAPI.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import Foundation

struct GeoData: Codable {
    let name: String
    let lat: Float
    let lon: Float
    let country: String
}

enum GeocodingAPI {
    static let baseURL = "https://api.openweathermap.org/geo/1.0/"

    static func geoURL(for zip: Int) -> String {
        "\(baseURL)zip?zip=\(zip)&appid=\(APIKey.geoKey)"
    }

    static func fetchCoordinates(for zip: Int,
                                 urlSession: URLSession = .init(configuration: .default),
                                 completion: @escaping (GeoData?, Error?) -> Void) {
        guard let url = URL(string: geoURL(for: zip)) else {
            completion(nil, CustomError.badURL)
            return
        }

        let task = urlSession.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }

                do {
                    let geoData = try JSONDecoder().decode(GeoData.self, from: data)
                    completion(geoData, nil)
                } catch {
                    completion(nil, error)
                }
            }

        task.resume()
    }
}

#if DEBUG
extension GeoData {
    static var testDataString: String {
        """
        {
            "name": "\(MockConstants.name)",
            "lat": \(MockConstants.latitude),
            "lon": \(MockConstants.longitude),
            "country": "\(MockConstants.country)"
        }
        """
    }
}
#endif
