//
//  SwitrixSyncClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

import Foundation

/**
 The Switrix Sync Client, used to call [Matrix Client-Server API](https://spec.matrix.org/v1.3/client-server-api/) `sync` endpoints.
 */
public class SwitrixSyncClient {
    /**
     Creates a new `SwitrixSyncClient`.
     
     - Parameters:
        - homeserverUrl: The URL of the homeserver that this client should use, as a `String` without a trailing slash.
        - accessToken: The access token to include in API requests, as a `String`.
     */
    init(homeserverUrl: String, accessToken: String) {
        self.homeserverUrl = homeserverUrl
        self.accessToken = accessToken
    }
    /**
     The URL of the homeserver that this client should use, without a trailing slash.
     */
    let homeserverUrl: String
    /**
     The access token to include in API requests.
     */
    let accessToken: String
    
    /**
     Calls the Matrix Client-Server API [sync](https://spec.matrix.org/v1.3/client-server-api/#get_matrixclientv3sync) endpoint using a `SwitrixDataTaskManager`.
     
     - Parameter completionHandler: A closure to which `SwitrixResponse<SwitrixSyncResponse>` result of the API call will be passed for handling.
     */
    public func sync(completionHandler: @escaping (SwitrixResponse<SwitrixSyncResponse>) -> Void) {
        guard var syncUrlComponents = URLComponents(string: homeserverUrl + "/_matrix/client/v3/sync") else {
            let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unable to create sync endpoint URL components"))
            completionHandler(switrixResponse)
            return
        }
        syncUrlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken)
        ]
        guard let syncUrl = syncUrlComponents.url else {
            let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unable to get sync endpoint URL from components"))
            completionHandler(switrixResponse)
            return
        }
        let request = URLRequest(url: syncUrl)
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixSyncResponse> = { json in
            guard let nextBatchToken = json["next_batch"] as? String else {
                let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Did not find next batch token in sync endpoint response"))
                return switrixResponse
            }
            let switrixResponse = SwitrixResponse.success(SwitrixSyncResponse(nextBatchToken: nextBatchToken))
            return switrixResponse
        }
        SwitrixDataTaskManager().manageDataTask(request: request, responseCreator: responseCreator, completionHandler: completionHandler)
    }
    
}
