//
//  SwitrixResponse.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

public enum SwitrixResponse<Response> {
    case success(Response)
    case failure(Error)
}
