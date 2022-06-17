//
//  SwitrixSyncTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/15/22.
//

import XCTest
@testable import Switrix

class SwitrixSyncTests: XCTestCase {
    #warning("TODO: move error handling test to DataTaskManager test")
    #warning("TODO: handle missing token errors and test for them as well")
    func testSwitrixSyncErrorHandling() {
        let unknownTokenExpectation = XCTestExpectation(description: "Get unknown token error from homeserver")
        let client = SwitrixClient(homeserver: "https://matrix.org", token: "not_a_real_token")
        client.sync.sync() { response in
            switch response {
            case .failure(let error):
                if (error as! SwitrixError).errorCode == "M_UNKNOWN_TOKEN" {
                    unknownTokenExpectation.fulfill()
                }
            default:
                break
            }
        }
        wait(for: [unknownTokenExpectation], timeout: 10.0)
    }
    func testSwitrixSync() {
        let syncExpectation = XCTestExpectation(description: "Get sync object from SwitrixClient")
        let client = SwitrixClient(homeserver: "https://matrix.org", token: ProcessInfo.processInfo.environment["MXKY"]!)
        client.sync.sync() { response in
            switch response {
            case .success(let switrixResponse):
                XCTAssertTrue(switrixResponse.nextBatchToken != "")
                syncExpectation.fulfill()
            default:
                break
            }
        }
        wait(for: [syncExpectation], timeout: 30.0)
    }
}
