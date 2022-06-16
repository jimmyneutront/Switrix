//
//  SwitrixTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/15/22.
//

import XCTest
@testable import Switrix

class SwitrixTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMatrixApi() throws {
        let unreachableExpectation = XCTestExpectation(description: "Unreachable Expectation")
        let homeserver = "https://matrix.org"
        var homeserverUrlComponents = URLComponents(string: homeserver + "/_matrix/client/v3/sync")!
        homeserverUrlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: "an_access_token")
        ]
        var request = URLRequest(url: homeserverUrlComponents.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String:Any]
                print(json)
            } else {
                print(response as Any)
            }
        }
        task.resume()
        wait(for: [unreachableExpectation], timeout: 60.0)
    }

}
