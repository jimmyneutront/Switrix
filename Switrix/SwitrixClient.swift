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
    
    static func getErrorResponse(response: Data) -> MatrixErrorResponse? {
        return try? JSONDecoder().decode(MatrixErrorResponse.self, from: response)
    }
    
    static func getError(responseData: Data) -> SwitrixError? {
        guard let errorResponse = getErrorResponse(response: responseData) else {
            return nil
        }
        return SwitrixError.createError(errorResponse: errorResponse)
    }
    
}
