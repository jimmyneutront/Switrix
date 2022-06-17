//
//  SwitrixError.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

public enum SwitrixError: Error {
case unknownToken(message:String)
case localUnknown(message: String)
    
    var errorCode: String {
        switch self {
        case .unknownToken:
            return "M_UNKNOWN_TOKEN"
        case .localUnknown:
            return "none"
        }
    }
    
    var errorMessage: String {
        switch self {
        case .unknownToken(let message):
            return message
        case .localUnknown(let message):
            return message
        }
    }
    
    static func createError(errorResponse: MatrixErrorResponse) -> SwitrixError {
        switch errorResponse.errcode {
        case "M_UNKNOWN_TOKEN":
            return SwitrixError.unknownToken(message: errorResponse.error)
        default:
            return SwitrixError.localUnknown(message: "Received error response with unknown error code")
        }
    }
}
