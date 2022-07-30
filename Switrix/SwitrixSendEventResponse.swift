//
//  SwitrixSendEventResponse.swift
//  Switrix
//
//  Created by jimmyt on 7/29/22.
//

/**
 The result of a successful call to the [event sending](https://spec.matrix.org/v1.3/client-server-api/#put_matrixclientv3roomsroomidstateeventtypestatekey) endpoint.
 */
public struct SwitrixSendEventResponse {
    /**
     The value of the `"event_id"` field in the actual JSON response.
     */
    public let eventId: String
}
