//
//  SwitrixTaskManagerTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/17/22.
//

import XCTest
@testable import Switrix

class SwitrixTaskManagerTests: XCTestCase {
    /**
     Ensure that SwitrixTaskManager handles [Matrix Unknown Token](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes) errors properly.
     */
    func testSwitrixTaskManagerUnknownTokenHandling() {
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
        SwitrixTaskManager.manageDataTask(request: request, responseCreator: responseCreator) { response in
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
    
    // Ensure SwitrixTaskManager handles missing token errors properly
    /**
     Ensure that SwitrixTaskManager handles [Matrix Missing Token](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes) errors properly.
     */
    func testSwitrixTaskManagerMissingTokenHandling() {
        let missingTokenExpectation = XCTestExpectation(description: "Get missing token error from homeserver")
        let urlComponents = URLComponents(string: "https://matrix.org/_matrix/client/v3/sync")!
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixSyncResponse> = { json in
            return SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unexpectedly got a successful response in a test where failure is expected"))
        }
        SwitrixTaskManager.manageDataTask(request: request, responseCreator: responseCreator) { response in
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
