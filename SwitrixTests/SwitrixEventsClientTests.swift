//
//  SwitrixEventsClientTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 6/16/22.
//

import XCTest
@testable import Switrix

class SwitrixEventsClientTests: XCTestCase {
    func testSwitrixGetEvents() {
        let startToken = "t1-2607497254_757284974_11441483_1402797642_1423439559_3319206_507472245_4060289024_0"
        let getEventsExpectation = XCTestExpectation(description: "Get events object from SwitrixClient")
        let client = SwitrixClient(homeserver: "https://matrix.org", token: ProcessInfo.processInfo.environment["MXKY"]!)
        client.events.getEvents(roomId: "!WEuJJHaRpDvkbSveLu:matrix.org", from: startToken, direction: .forwards, limit: 1_000_000_000_000) { response in
            switch response {
            case .success(let getEventsResponse):
                XCTAssertTrue(getEventsResponse.start == startToken)
                XCTAssertTrue(getEventsResponse.chunk.count > 0)
                getEventsExpectation.fulfill()
            default:
                break
            }
        }
        wait(for: [getEventsExpectation], timeout: 20.0)
    }
}
