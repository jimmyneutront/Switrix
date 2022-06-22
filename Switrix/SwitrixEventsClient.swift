//
//  SwitrixEventsClient.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

import Foundation

/**
 The Switrix Events Client, used to call [Matrix Client-Server API](https://spec.matrix.org/v1.3/client-server-api/) `events`-related endpoints.
 */
public class SwitrixEventsClient {
    /**
     Creates a new `SwitrixEventsClient`.
     
     - Parameters:
        - homeserverUrl: The URL of the homeserver that this client should use, as a `String` without a trailing slash.
        - accessToken: The access token to include in API requests, as a `String`.
     */
    init(homeserverUrl: String, accessToken: String) {
        self.homeserverUrl = homeserverUrl
        self.accessToken = accessToken
    }
    /**
     The URL of the homeserver that this client should use, without a trailing slash.
     */
    let homeserverUrl: String
    /**
     The access token to include in API requests.
     */
    let accessToken: String
    
    #warning ("TODO: handle code 403 which means we arent in the room")
    /**
     Calls the Matrix Client-Server API [messages](https://spec.matrix.org/v1.3/client-server-api/#get_matrixclientv3roomsroomidmessages) endpoint using a `SwitrixDataTaskManager`.
     
     - Parameters:
        - roomId: The ID of the room from which to get events.
        - from: The batch token to start returning events from.
        - direction: The direction to return events from: either forwards, with newest events last, or backwards, with newest events first.
        - limit: The maximum number of events to return. Note that the actual number of events returned will likely be less than `limit`, since this only returns text message events.
        - completionHandler: A closure to which the `SwitrixResponse<SwitrixGetEventsResponse>` result of the API call will be passed for handling.
     */
    public func getEvents(roomId: String, from: String, direction: SwitrixEventsDirection, limit: Int, completionHandler: @escaping (SwitrixResponse<SwitrixGetEventsResponse>) -> Void) {
        guard var getEventsUrlComponents = URLComponents(string: homeserverUrl + "/_matrix/client/v3/rooms/" + roomId + "/messages") else {
            let switrixResponse = SwitrixResponse<SwitrixGetEventsResponse>.failure(SwitrixError.localUnknown(message: "Unable to create get events endpoint URL components"))
            completionHandler(switrixResponse)
            return
        }
        getEventsUrlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "roomId", value: roomId),
            URLQueryItem(name: "dir", value: direction.directionString),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        guard let getEventsUrl = getEventsUrlComponents.url else {
            let switrixResponse = SwitrixResponse<SwitrixGetEventsResponse>.failure(SwitrixError.localUnknown(message: "Unable to get get events endpoint URL from components"))
            completionHandler(switrixResponse)
            return
        }
        let request = URLRequest(url: getEventsUrl)
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixGetEventsResponse> = { json in
            guard let start = json["start"] as? NSString, let end = json["end"] as? NSString else {
                return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find tokens in get events response"))
            }
            guard let chunk = json["chunk"] as? Array<Dictionary<String, Any>> else {
                return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find chunk in get events response"))
            }
            var switrixClientEvents: [SwitrixClientEvent] = []
            for event in chunk {
                guard let content = event["content"] as? Dictionary<String, Any> else {
                    return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find content information in chunk element"))
                }
                guard let eventId = event["event_id"] as? String, let originServerTimestamp = event["origin_server_ts"] as? Int, let roomId = event["room_id"] as? String, let sender = event["sender"] as? String, let type = event["type"] as? String else {
                    return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find ClientEvent information in chunk element"))
                }
                // For now, we only include text events in the list that is returned. We can change this later if need be.
                if let messageType = content["msgtype"] as? String {
                    if messageType == "m.text" {
                        guard let body = content["body"] as? String else {
                            return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find body in text event"))
                        }
                        let messageEventContent = SwitrixMessageEventContent(body: body)
                        switrixClientEvents.append(SwitrixClientEvent(content: messageEventContent, eventId: eventId, originServerTimestamp: originServerTimestamp, roomId: roomId, sender: sender, type: type))
                    }
                }
            }
            return SwitrixResponse.success(SwitrixGetEventsResponse(start: start as String, end: end as String, chunk: switrixClientEvents))
        }
        SwitrixDataTaskManager().manageDataTask(request: request, responseCreator: responseCreator, completionHandler: completionHandler)
    }
}
