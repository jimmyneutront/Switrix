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
    
    public func sendEvent(roomId: String, event: SwitrixClientEvent, completionHandler: @escaping (SwitrixResponse<SwitrixSendEventResponse>) -> Void) {
        guard var sendEventUrlComponents = URLComponents(string: "\(homeserverUrl)/_matrix/client/v3/rooms/\(roomId)/state/\(event.type)") else {
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
        // We merge the event content with the event itself because Synapse doesn't allow wrapping event content in a content node, see here: https://github.com/matrix-org/synapse/issues/1889
        var eventJSON = event.asJSON
        eventJSON.merge(event.content.asJSON) { (current, _) in current }
        eventJSON.removeValue(forKey: "content")
        guard JSONSerialization.isValidJSONObject(eventJSON) else {
            let switrixResponse = SwitrixResponse<SwitrixSendEventResponse>.failure(SwitrixError.localUnknown(message: "Event to send cannot be serialized"))
            completionHandler(switrixResponse)
            return
        }
        guard let eventData = try? JSONSerialization.data(withJSONObject: eventJSON) else {
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
