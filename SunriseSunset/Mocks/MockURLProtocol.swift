//
//  MockURLProtocol.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockData = [String: Data]()

    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url, let data = MockURLProtocol.mockData[url.absoluteString] {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
