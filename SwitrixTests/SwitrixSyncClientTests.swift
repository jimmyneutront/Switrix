//
//  SwitrixSyncClientTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/15/22.
//

import XCTest
@testable import Switrix

class SwitrixSyncClientTests: XCTestCase {
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
