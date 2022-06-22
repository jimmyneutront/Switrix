//
//  SwitrixSyncResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

/**
 The result of a successful call to the [sync](https://spec.matrix.org/v1.3/client-server-api/#get_matrixclientv3sync) endpoint. Note that this only contains the value of the `"next_batch"` field in the actual JSON response.
 */
public struct SwitrixSyncResponse: Decodable {
    /**
     The value of the `"next_batch"` field in the actual JSON response.
     */
    public let nextBatchToken: String
}
