//
//  SwitrixClientEvent.swift
//  
//
//  Created by jimmyt on 6/17/22.
//

public struct SwitrixClientEvent {
    let content: SwitrixEventContent
    let eventId: String
    let originServerTimestamp: Int
    let roomId: String
    let sender: String
    let type: String
}
