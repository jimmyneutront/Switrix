//
//  SwitrixRoomsClient.swift
//  Switrix
//
//  Created by jimmyt on 7/29/22.
//

public class SwitrixRoomsClient {
    /**
     Creates a new `SwitrixRoomsClient`.
     
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
    
    /**
     Sends an event with the specified `eventContent` of the specified `eventType` in the room with the specified `roomId`, and then passes the result to `completionHandler`.
     
     - Parameters:
        - roomId: The ID of the room in which the event will be sent.
        - eventType: The type of event to be sent, as described in the [Client-Server API spec](https://spec.matrix.org/v1.3/client-server-api/#types-of-room-events).
        - eventContent The content of the event to send.
        - completionHandler: A closure to handle the result of the send event call.
     */
    public func sendEvent(roomId: String, eventType: String, eventContent: SwitrixEventContent, completionHandler: @escaping (SwitrixResponse<SwitrixSendEventResponse>) -> Void) {
        guard var sendEventUrlComponents = URLComponents(string: "\(homeserverUrl)/_matrix/client/v3/rooms/\(roomId)/state/\(eventType)") else {
            let switrixResponse = SwitrixResponse<SwitrixSendEventResponse>.failure(SwitrixError.localUnknown(message: "Unable to create get events endpoint URL components"))
            completionHandler(switrixResponse)
            return
        }
        sendEventUrlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken)
        ]
        guard let sendEventUrl = sendEventUrlComponents.url else {
            let switrixResponse = SwitrixResponse<SwitrixSendEventResponse>.failure(SwitrixError.localUnknown(message: "Unable to get send event endpoint URL from components"))
            completionHandler(switrixResponse)
            return
        }
        var request = URLRequest(url: sendEventUrl)
        request.httpMethod = "PUT"
        guard JSONSerialization.isValidJSONObject(eventContent.asJSON) else {
            let switrixResponse = SwitrixResponse<SwitrixSendEventResponse>.failure(SwitrixError.localUnknown(message: "Event to send cannot be serialized"))
            completionHandler(switrixResponse)
            return
        }
        guard let eventData = try? JSONSerialization.data(withJSONObject: eventContent.asJSON) else {
            let switrixResponse = SwitrixResponse<SwitrixSendEventResponse>.failure(SwitrixError.localUnknown(message: "Unable to serialize event"))
            completionHandler(switrixResponse)
            return
        }
        let responseCreator: ([String:Any]) -> SwitrixResponse<SwitrixSendEventResponse> = { json in
            guard let eventId = json["event_id"] as? NSString else {
                return SwitrixResponse.failure(SwitrixError.localUnknown(message: "Unable to find event ID in send message response"))
            }
            return SwitrixResponse.success(SwitrixSendEventResponse(eventId: eventId as String))
        }
        SwitrixTaskManager.manageUploadTask(request: request, uploadData: eventData, responseCreator: responseCreator, completionHandler: completionHandler)
    }
    
}
