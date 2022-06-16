//
//  SwitrixClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

class SwitrixClient {
    init(homeserver: String, token: String) {
        homeserverUrl = homeserver
        accessToken = token
        sync = SwitrixSyncClient(homeserverUrl: homeserverUrl, accessToken: token)
    }
    let homeserverUrl: String
    let accessToken: String
    let sync: SwitrixSyncClient
}
