//
//  SwitrixClientEvent.swift
//  
//
//  Created by jimmyt on 6/17/22.
//

public struct SwitrixClientEvent {
    public let content: SwitrixEventContent
    public let eventId: String
    public let originServerTimestamp: Int
    public let roomId: String
    public let sender: String
    public let type: String
}
