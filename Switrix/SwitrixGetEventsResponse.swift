//
//  SwitrixGetEventsResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

public struct SwitrixGetEventsResponse {
    let start: String
    let end: String
    let chunk: [SwitrixClientEvent]
}
