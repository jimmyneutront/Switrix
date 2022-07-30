//
//  SwitrixRoomsClientTests.swift
//  SwitrixTests
//
//  Created by jimmyt on 7/29/22.
//

import XCTest
@testable import Switrix

class SwitrixRoomsClientTests: XCTestCase {
    #warning("TODO: get event with ID returned by sendEvent call once getEvent is implemented")
    /**
     Tests `SwitrixRoomsClient`'s `sendMessage` method by ensuring we get a proper `SwitrixSendMessageResponse` from the Matrix Client-Server API [send event](https://spec.matrix.org/v1.3/client-server-api/#put_matrixclientv3roomsroomidstateeventtypestatekey) endpoint.
     */
    func testSwitrixSendEvent() {
        let sendMessageExpectation = XCTestExpectation(description: "Get send message response from SwitrixClient")
        let randomID = UUID()
        let eventContent = SwitrixMessageEventContent(body: randomID.uuidString)
        let client = SwitrixClient(homeserver: "https://matrix.org", token: ProcessInfo.processInfo.environment["MXKY"]!)
        client.rooms.sendEvent(roomId: "!WEuJJHaRpDvkbSveLu:matrix.org", eventType: "m.room.message", eventContent: eventContent) { response in
            switch response {
            case .success(let sendMessageResponse):
                XCTAssertNotNil(sendMessageResponse.eventId)
                sendMessageExpectation.fulfill()
            default:
                break
            }
        }
        wait(for: [sendMessageExpectation], timeout: 20.0)
    }
}
