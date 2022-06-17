//
//  SwitrixMessageEventContent.swift
//  Switrix
//
//  Created by jimmyt on 6/17/22.
//

struct SwitrixMessageEventContent: SwitrixEventContent {
    let messageType = "m.text"
    var body: String
}
