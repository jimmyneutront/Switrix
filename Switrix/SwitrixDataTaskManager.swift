//
//  SwitrixDataTaskManager.swift
//  Switrix
//
//  Created by jimmyt on 6/16/22.
//

class SwitrixDataTaskManager {
    func manageDataTask<SwitrixResponseType>(request: URLRequest, responseCreator: @escaping ([String:Any]) -> SwitrixResponse<SwitrixResponseType>, completionHandler: @escaping (SwitrixResponse<SwitrixResponseType>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Make sure we have a response. If we don't, check if we have an error and pass it to the completion handler if we do. If we don't, we create our own and pass it to the completion handler.
            guard let response = response else {
                if let error = error {
                    let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(error)
                    completionHandler(switrixResponse)
                } else {
                    let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Received no response and no error from endpoint call"))
                    completionHandler(switrixResponse)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Unable to get HTTP response from endpoint call"))
                completionHandler(switrixResponse)
                return
            }
            if httpResponse.statusCode != 200 {
                // Check if we have response data. If we don't, complete with the error if available, or create our own if the passed error is nil
                guard let responseData = data else {
                    if let error = error {
                        let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(error)
                        completionHandler(switrixResponse)
                    } else {
                        let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Got non-200 status code but no response data and no error from endpoint call"))
                        completionHandler(switrixResponse)
                    }
                    return
                }
                // Since we do have response data, try to get an error from it and complete with that error
                if let switrixError = SwitrixClient.getError(responseData: responseData) {
                    completionHandler(SwitrixResponse<SwitrixResponseType>.failure(switrixError))
                } else {
                    // We did get response data but no error from it, so we complete with our own error
                    let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Got non-200 status code and response data from endpoint call, but response data had no error"))
                    completionHandler(switrixResponse)
                }
                return
            }
            // We got a response with a 200 status code, so let's try to get the data and throw an error if there is no data
            guard let responseData = data else {
                let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Got a 200 status code response but no response data from endpoint call"))
                completionHandler(switrixResponse)
                return
            }
            // We can still get Matrix errors in responses with a 200 status code, so we check for that here
            if let switrixError = SwitrixClient.getError(responseData: responseData) {
                completionHandler(SwitrixResponse<SwitrixResponseType>.failure(switrixError))
                return
            }
            // We have a response with a 200 status code and no Matrix error, so we try to create a response object
            guard let json = try? JSONSerialization.jsonObject(with: responseData, options: .fragmentsAllowed) as? [String:Any] else {
                let switrixResponse = SwitrixResponse<SwitrixResponseType>.failure(SwitrixError.localUnknown(message: "Unable to get JSON from endpoint response"))
                completionHandler(switrixResponse)
                return
            }
            let responseObject = responseCreator(json)
            completionHandler(responseObject)
        }
        task.resume()
    }
}
