//
//  SwitrixClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

/**
 The main Switrix Client class. It contains clients used to call specific types of [Matrix Client-Server API](https://spec.matrix.org/v1.3/client-server-api/) endpoints.
 
 - Properties:
    - homeserverUrl: The URL of the homeserver that this client should use, as a `String` without a trailing slash.
    - accessToken: The access token to include in API requests.
    - sync: The `SwitrixSyncClient` for making `sync` requests.
    - events: The `SwitrixEventsClient` for making `events`-related requests.
 */
public class SwitrixClient {
    /**
     Creates a new `SwitrixClient`.
     
     - Parameters:
        - homeserver: The URL of the homeserver that this client should use, as a `String` without a trailing slash.
        - token: The access token to include in API requests.
     */
    public init(homeserver: String, token: String) {
        homeserverUrl = homeserver
        accessToken = token
        sync = SwitrixSyncClient(homeserverUrl: homeserverUrl, accessToken: token)
        events = SwitrixEventsClient(homeserverUrl: homeserverUrl, accessToken: token)
    }
    /**
     The URL of the homeserver that this client should use as a `String`, without a trailing slash.
     */
    let homeserverUrl: String
    /**
     The access token to include in API requests.
     */
    let accessToken: String
    
    /**
     The client for making `sync` requests.
     */
    public let sync: SwitrixSyncClient
    /**
     The client for making `events`-related requests.
     */
    public let events: SwitrixEventsClient
    
    /**
     Attempts to get a `MatrixErrorResponse` from the response `Data` returned from an API call.
     
     - Returns: A `MatrixErrorResponse` if one can be created from `response`, or `nil` otherwise.
     */
    static func getErrorResponse(response: Data) -> MatrixErrorResponse? {
        return try? JSONDecoder().decode(MatrixErrorResponse.self, from: response)
    }
    
    /**
     Attempts to get a `SwitrixError` from the response `Data` returned from an API call.
     
     - Returns: A `SwitrixError` if one can be created from `responseData`, or `nil` otherwise.
     */
    static func getError(responseData: Data) -> SwitrixError? {
        guard let errorResponse = getErrorResponse(response: responseData) else {
            return nil
        }
        return SwitrixError.createError(errorResponse: errorResponse)
    }
    
}
