//
//  SwitrixGetEventsResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

public struct SwitrixGetEventsResponse {
    public let start: String
    public let end: String
    public let chunk: [SwitrixClientEvent]
}
