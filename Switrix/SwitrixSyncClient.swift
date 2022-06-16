//
//  SwitrixSyncClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

import Foundation

class SwitrixSyncClient {
    init(homeserverUrl: String, accessToken: String) {
        self.homeserverUrl = homeserverUrl
        self.accessToken = accessToken
    }
    let homeserverUrl: String
    let accessToken: String
    
    func sync(completionHandler: @escaping (SwitrixResponse<SwitrixSyncResponse>) -> Void) {
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Make sure we have a response. If we don't, check if we have an error and pass it to the completion handler if we do. If we don't, we create our own and pass it to the completion handler.
            guard let response = response else {
                if let error = error {
                    let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(error)
                    completionHandler(switrixResponse)
                } else {
                    let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Received no response and no error from sync endpoint call"))
                    completionHandler(switrixResponse)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unable to get HTTP response from sync endpoint call"))
                completionHandler(switrixResponse)
                return
            }
            if httpResponse.statusCode != 200 {
                // Check if we have response data. If we don't, complete with the error if available, or create our own if the passed error is nil
                guard let responseData = data else {
                    if let error = error {
                        let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(error)
                        completionHandler(switrixResponse)
                    } else {
                        let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Got non-200 status code but no response data and no error from sync endpoint call"))
                        completionHandler(switrixResponse)
                    }
                    return
                }
                // Since we do have response data, try to get an error from it and complete with that error
                if let switrixError = SwitrixClient.getError(responseData: responseData) {
                    completionHandler(SwitrixResponse<SwitrixSyncResponse>.failure(switrixError))
                } else {
                    // We did get response data but no error from it, so we complete with our own error
                    let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Got non-200 status code and response data from sync endpoint call, but response data had no error"))
                    completionHandler(switrixResponse)
                }
                return
            }
            // We got a response with a 200 status code, so let's try to get the data and throw an error if there is no data
            guard let responseData = data else {
                let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Got a 200 status code response but no response data from sync endpoint call"))
                completionHandler(switrixResponse)
                return
            }
            // We can still get Matrix errors in responses with a 200 status code, so we check for that here
            if let switrixError = SwitrixClient.getError(responseData: responseData) {
                completionHandler(SwitrixResponse<SwitrixSyncResponse>.failure(switrixError))
                return
            }
            // We have a response with a 200 status code and no Matrix error, so we try to create a response object
            guard let json = try? JSONSerialization.jsonObject(with: responseData, options: .fragmentsAllowed) as? [String:Any] else {
                let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Unable to get JSON from sync endpoint response"))
                completionHandler(switrixResponse)
                return
            }
            guard let nextBatchToken = json["next_batch"] as? String else {
                let switrixResponse = SwitrixResponse<SwitrixSyncResponse>.failure(SwitrixError.localUnknown(message: "Did not find next batch token in sync endpoint response"))
                completionHandler(switrixResponse)
                return
            }
            let switrixResponse = SwitrixResponse.success(SwitrixSyncResponse(nextBatchToken: nextBatchToken))
            completionHandler(switrixResponse)
        }
        task.resume()
    }
    
}
