//
//  SwitrixDataTaskManagerTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/17/22.
//

import XCTest
@testable import Switrix

class SwitrixDataTaskManagerTests: XCTestCase {
    // Ensure SwitrixDataTaskManager handles unknown token errors properly
    func testSwitrixDataTaskManagerUnknownTokenHandling() {
        let unknownTokenExpectation = XCTestExpectation(description: "Get unknown token error from homeserver")
        var urlComponents = URLComponents(string: "https://matrix.org/_matrix/client/v3/sync")!
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: "not_a_real_access token")
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixSyncResponse> = { json in
            return SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unexpectedly got a successful response in a test where failure is expected"))
        }
        SwitrixDataTaskManager().manageDataTask(request: request, responseCreator: responseCreator) { response in
            switch response {
            case .failure(let error):
                XCTAssertTrue((error as! SwitrixError).errorCode == "M_UNKNOWN_TOKEN")
                unknownTokenExpectation.fulfill()
            default:
                break
            }
        }
        wait(for: [unknownTokenExpectation], timeout: 20.0)
    }
    
    // Ensure SwitrixDataTaskManager handles missing token errors properly
    func testSwitrixDataTaskManagerMissingTokenHandling() {
        let missingTokenExpectation = XCTestExpectation(description: "Get missing token error from homeserver")
        let urlComponents = URLComponents(string: "https://matrix.org/_matrix/client/v3/sync")!
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixSyncResponse> = { json in
            return SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unexpectedly got a successful response in a test where failure is expected"))
        }
        SwitrixDataTaskManager().manageDataTask(request: request, responseCreator: responseCreator) { response in
            switch response {
            case .failure(let error):
                XCTAssertTrue((error as! SwitrixError).errorCode == "M_MISSING_TOKEN")
                missingTokenExpectation.fulfill()
            default:
                break
            }
        }
        wait(for: [missingTokenExpectation], timeout: 20.0)
    }
}