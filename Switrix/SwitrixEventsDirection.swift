//
//  SwitrixEventsDirection.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

public enum SwitrixEventsDirection {
    case forwards
    case backwards
    var directionString: String {
        switch self {
        case .forwards:
            return "f"
        case .backwards:
            return "b"
        }
    }
}
