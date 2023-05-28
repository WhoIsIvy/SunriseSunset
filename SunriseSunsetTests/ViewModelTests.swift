//
//  ViewModelTests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 5/26/23.
//

import XCTest
@testable import SunriseSunset

class ViewModelTests: XCTestCase {
    func testZipCodeValidation() {
        let viewModel = ViewModel()

        var alerts = [NSAttributedString]()
        viewModel.displayInvalidZipCodeAlert = { alertAttributed in
            alerts.append(alertAttributed)
        }

        let firstAttempt = viewModel.testZipCodeValidation("")
        let secondAttempt = viewModel.testZipCodeValidation("84")
        let thirdAttempt = viewModel.testZipCodeValidation("4f444")
        let validZip = viewModel.testZipCodeValidation("84121")

        XCTAssertNil(firstAttempt)
        XCTAssertNil(secondAttempt)
        XCTAssertNil(thirdAttempt)
        XCTAssertEqual(validZip, 84121)

        XCTAssertEqual(alerts.count, 3)
        XCTAssertEqual(alerts[0].string, String(localizationKey: .emptyZip))
        XCTAssertEqual(alerts[1].string, String(localizationKey: .zipInvalidDigitCount))
        XCTAssertEqual(alerts[2].string, String(localizationKey: .zipInvalidDigit))
    }

    func testAPICalls() throws {
        let geoTestData = try XCTUnwrap(GeoData.testDataString.data(using: .utf8))
        let zipcode = MockConstants.zipcode
        let geoURL = GeocodingAPI.geoURL(for: zipcode)

        let timeTestData = try XCTUnwrap(TimeData.testDataString.data(using: .utf8))
        let timeURL = TimeAPI.timeURL(lat: MockConstants.latitude, lon: MockConstants.longitude)

        MockURLProtocol.mockData[geoURL] = geoTestData
        MockURLProtocol.mockData[timeURL] = timeTestData

        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)

        let urlSession = URLSession(configuration: mockConfiguration)

        let expectation = XCTestExpectation(description: "Wait for mock session")

        let viewModel = ViewModel()
        viewModel.retrieveSunTimes(for: "\(zipcode)", urlSession: urlSession) { sunModel, customError in
            XCTAssertNil(customError)
            XCTAssertEqual(sunModel?.cityAndCountry, "\(MockConstants.name), \(MockConstants.country)")
            XCTAssertEqual(sunModel?.sunriseTime, "Sunrise: \(MockConstants.sunrise)")
            XCTAssertEqual(sunModel?.sunsetTime, "Sunset: \(MockConstants.sunset)")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6)
    }
}
