//
//  SwitrixResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

enum SwitrixResponse<Response> {
    case success(Response)
    case failure(Error)
}
