//
//  SwitrixClientEvent.swift
//  
//
//  Created by jimmyt on 6/17/22.
//

/**
 Switrix's representation of a [ClientEvent](https://spec.matrix.org/v1.3/client-server-api/#room-event-format), containing some of its fields.
 */
public struct SwitrixClientEvent {
    /**
     The content of the event.
     */
    public let content: SwitrixEventContent
    /**
     The globally unique identifier of the event.
     */
    public let eventId: String
    /**
     The timestamp (in milliseconds since the UNIX epoch) on the originating homeserver when the event was sent.
     */
    public let originServerTimestamp: Int
    /**
     The ID of the room in which the event was sent.
     */
    public let roomId: String
    /**
     The fully-qualified Matrix ID of the sender of this event.
     */
    public let sender: String
    /**
     The type of the event.
     */
    public let type: String
}
