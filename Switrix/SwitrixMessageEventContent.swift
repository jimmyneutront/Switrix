//
//  SwitrixMessageEventContent.swift
//  Switrix
//
//  Created by jimmyt on 6/17/22.
//

public struct SwitrixMessageEventContent: SwitrixEventContent {
    public let messageType = "m.text"
    public var body: String
}
