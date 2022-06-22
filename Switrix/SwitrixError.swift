//
//  SwitrixError.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

/**
 The Switrix Error `enum`. Created by Switrix code when something unexpected occurs.
 */
public enum SwitrixError: Error {
    /**
     Created when Switrix encounters a [Matrix Unknown Token](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes) error.
     
     - Parameter message: The value of the `"error"` field in the [Matrix Standard error response](https://spec.matrix.org/v1.3/client-server-api/#standard-error-response) that gave rise to this error.
     */
case unknownToken(message:String)
    /**
     Created when Switrix encounters a [Matrix Missing Token](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes) error.
     
     - Parameter message: The value of the `"error"` field in the [Matrix Standard error response](https://spec.matrix.org/v1.3/client-server-api/#standard-error-response) that gave rise to this error.
     */
case missingToken(message: String)
    /**
     Created when Switrix encounters a miscellaneous, rare, or otherwise unexpected non-Matrix error, or when Switrix encounters a Matrix error with an unrecognized [error code](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes)
     
     - Parameter message: A brief message describing the context in which the error occured.
     */
case localUnknown(message: String)
    
    /**
     The [Matrix error code](https://spec.matrix.org/v1.3/client-server-api/#common-error-codes) associated with a `SwitrixError`, or `"none"` if no error code exists.
     */
    var errorCode: String {
        switch self {
        case .unknownToken:
            return "M_UNKNOWN_TOKEN"
        case .missingToken:
            return "M_MISSING_TOKEN"
        default:
            return "none"
        }
    }
    
    /**
     The message associated with a `SwitrixError`.
     */
    var errorMessage: String {
        switch self {
        case .unknownToken(let message):
            return message
        case .missingToken(let message):
            return message
        case .localUnknown(let message):
            return message
        }
    }
    
    /**
     Creates a `SwitrixError` to represent the given `MatrixErrorResponse`.
     
     - Parameter errorResponse: The `MatrixErrorResponse` for which to create a `SwitrixError`
     
     - Returns A `SwitrixError` corresponding to `errorResponse`.
     */
    static func createError(errorResponse: MatrixErrorResponse) -> SwitrixError {
        switch errorResponse.errcode {
        case "M_UNKNOWN_TOKEN":
            return SwitrixError.unknownToken(message: errorResponse.error)
        case "M_MISSING_TOKEN":
            return SwitrixError.missingToken(message: errorResponse.error)
        default:
            return SwitrixError.localUnknown(message: "Received error response with unknown error code")
        }
    }
}
