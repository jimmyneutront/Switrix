//
//  MatrixErrorResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

/**
 Represents a [Matrix Standard error response](https://spec.matrix.org/v1.3/client-server-api/#standard-error-response)
 */
struct MatrixErrorResponse: Decodable {
    /**
     The value of the `"errcode"` field in the Standard error response that this represents.
     */
    let errcode: String
    /**
     The value of the `"error"` field in the Standard error response that this represents.
     */
    let error: String
}
