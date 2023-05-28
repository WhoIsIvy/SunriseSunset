//
//  GeocodingAPITests.swift
//  SunriseSunsetTests
//
//  Created by Lisa Fellows on 5/26/23.
//

import XCTest
@testable import SunriseSunset

class GeocodingAPITests: XCTestCase {

    func testGeoDataDecoding() throws {
        let testData = try XCTUnwrap(GeoData.testDataString.data(using: .utf8))
        let results = try JSONDecoder().decode(GeoData.self, from: testData)
        XCTAssertEqual(results.name, MockConstants.name)
        XCTAssertEqual(results.lat, MockConstants.latitude)
        XCTAssertEqual(results.lon, MockConstants.longitude)
        XCTAssertEqual(results.country, MockConstants.country)
    }

    func testGeoDataWithInvalidNullValue() throws {
        let testData = """
        {
            "name": "A name",
            "lat": 04.43,
            "lon": null,
            "country": "US"
        }
        """.data(using: .utf8)

        let data = try XCTUnwrap(testData)

        var foundResult: GeoData?
        var foundError: Error?

        do {
            foundResult = try JSONDecoder().decode(GeoData.self, from: data)
        } catch {
            foundError = error
        }

        XCTAssertNil(foundResult)
        XCTAssertNotNil(foundError)
    }

    func testAPICall() throws {
        let testData = try XCTUnwrap(GeoData.testDataString.data(using: .utf8))
        let zipcode = MockConstants.zipcode
        let geoURL = GeocodingAPI.geoURL(for: zipcode)
        MockURLProtocol.mockData[geoURL] = testData

        URLProtocol.registerClass(MockURLProtocol.self)
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        let urlSession = URLSession(configuration: mockConfiguration)

        let expectation = XCTestExpectation(description: "Wait for mock session")

        GeocodingAPI.fetchCoordinates(for: zipcode, urlSession: urlSession) { geoData, error in
            XCTAssertNil(error)
            XCTAssertEqual(geoData?.name, MockConstants.name)
            XCTAssertEqual(geoData?.country, MockConstants.country)
            XCTAssertEqual(geoData?.lat, MockConstants.latitude)
            XCTAssertEqual(geoData?.lon, MockConstants.longitude)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6)
    }
}
