//
//  TimeAPITests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 5/26/23.
//

import XCTest
@testable import SunriseSunset

class TimeAPITests: XCTestCase {

    private let expectedSunrise = "08:00:00 AM"
    private let expectedSunset = "08:00:00 PM"

    func testTimeResultsDecoding() throws {
        let testData = try XCTUnwrap(TimeResults.testDataString.data(using: .utf8))
        let results = try JSONDecoder().decode(TimeResults.self, from: testData)
        XCTAssertEqual(results.sunrise, MockConstants.sunrise)
        XCTAssertEqual(results.sunset, MockConstants.sunset)
    }

    func testTimeResultsWithInvalidNullValue() throws {
        let testData = """
        {
            "sunrise": null,
            "sunset": "08:00:00 PM"
        }
        """.data(using: .utf8)

        let data = try XCTUnwrap(testData)

        var foundResult: TimeResults?
        var foundError: Error?

        do {
            foundResult = try JSONDecoder().decode(TimeResults.self, from: data)
        } catch {
            foundError = error
        }

        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }

    func testTimeData() throws {
        let testData = try XCTUnwrap(TimeData.testDataString.data(using: .utf8))
        let results = try JSONDecoder().decode(TimeData.self, from: testData).results
        XCTAssertEqual(results.sunrise, expectedSunrise)
        XCTAssertEqual(results.sunset, expectedSunset)
    }

    func testTimeDataWithInvalidNullValue() throws {
        let testData = """
        {
            "results": {
                "sunrise": "08:00:00 AM",
                "sunset": null
            }
        }
        """.data(using: .utf8)

        let data = try XCTUnwrap(testData)

        var foundResult: TimeData?
        var foundError: Error?

        do {
            foundResult = try JSONDecoder().decode(TimeData.self, from: data)
        } catch {
            foundError = error
        }

        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }

    func testAPICall() throws {
        let testData = try XCTUnwrap(TimeData.testDataString.data(using: .utf8))
        let lat = MockConstants.latitude
        let lon = MockConstants.longitude
        let timeURL = TimeAPI.timeURL(lat: lat, lon: lon)
        MockURLProtocol.mockData[timeURL] = testData

        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        let urlSession = URLSession(configuration: mockConfiguration)

        let expectation = XCTestExpectation(description: "Wait for mock session")

        TimeAPI.fetchTimeInfo(lat: lat, lon: lon, urlSession: urlSession) { timeData, error in
            XCTAssertNil(error)
            XCTAssertEqual(timeData?.results.sunrise, MockConstants.sunrise)
            XCTAssertEqual(timeData?.results.sunset, MockConstants.sunset)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6)
    }
}
