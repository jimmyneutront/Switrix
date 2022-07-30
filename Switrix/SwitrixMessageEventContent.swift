//
//  SwitrixMessageEventContent.swift
//  Switrix
//
//  Created by jimmyt on 6/17/22.
//

/**
 Represents the content of a Matrix text message event.
 */
public struct SwitrixMessageEventContent: SwitrixEventContent {
    /**
     The type of this message.
     */
    public let messageType = "m.text"
    /**
     The body of this text message.
     */
    public var body: String
    /**
     Returns the event content as a valid JSON dictionary.
     */
    public var asJSON: [String : Any] {
        [
            "body": body,
            "msgtype": messageType
        ]
    }
}
