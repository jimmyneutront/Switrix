//
//  SwitrixResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

/**
 Represents a response from a call to a [Matrix Client-Server API](https://spec.matrix.org/v1.3/client-server-api/) endpoint.
 */
public enum SwitrixResponse<Response> {
    /**
     Indicates the request was successfull, and contains the `Response`.
     */
    case success(Response)
    /**
     Indicates that the request failed, and contains the associated `Error`.
     */
    case failure(Error)
}
