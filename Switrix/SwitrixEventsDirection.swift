//
//  SwitrixEventsDirection.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

/**
 Specifies the direction in which events should be returned when calling a [Matrix Client-Server API](https://spec.matrix.org/v1.3/client-server-api/) endpoint that returns a list of Matrix events. `"forwards"` means that newest events will be at the end of the list, and `"backwards"` means that newest events will be at the beginning of the list.
 */
public enum SwitrixEventsDirection {
    /**
     Specifies that newest events should be at the end of the returned list of events.
     */
    case forwards
    /**
     Specifies that newest events should be at the beginning of the returned list of events.
     */
    case backwards
    /**
     The representation of the direction as a `String` that can be understood by a Matrix homeserver.
     */
    var directionString: String {
        switch self {
        case .forwards:
            return "f"
        case .backwards:
            return "b"
        }
    }
}
