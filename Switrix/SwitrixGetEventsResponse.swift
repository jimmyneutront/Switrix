//
//  SwitrixGetEventsResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

/**
 The result of a successful call to the [messages](https://spec.matrix.org/v1.3/client-server-api/#get_matrixclientv3roomsroomidmessages) endpoint.
 */
public struct SwitrixGetEventsResponse {
    /**
     The value of the `"start"` field in the actual JSON response.
     */
    public let start: String
    /**
     The value of the `"end"` field in the actual JSON response.
     */
    public let end: String
    /**
     An array of `SwitrixClientEvent`a derived from the value of the `"chunk"` field in the actual JSON response.
     */
    public let chunk: [SwitrixClientEvent]
}
