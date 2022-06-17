//
//  SwitrixSyncClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

import Foundation

public class SwitrixSyncClient {
    init(homeserverUrl: String, accessToken: String) {
        self.homeserverUrl = homeserverUrl
        self.accessToken = accessToken
    }
    let homeserverUrl: String
    let accessToken: String
    
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
