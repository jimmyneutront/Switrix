//
//  SwitrixSyncClient.swift
//  Switrix
//
//  Created by jimmyt on 6/15/22.
//

class SwitrixSyncClient {
    init(homeserverUrl: String, accessToken: String) {
        self.homeserverUrl = homeserverUrl
        self.accessToken = accessToken
    }
    let homeserverUrl: String
    let accessToken: String
    func sync() {
        guard var syncUrlComponents = URLComponents(string: homeserverUrl + "/_matrix/client/v3/sync") else {
            // TODO: handle this bad scenario
            return
        }
        syncUrlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken)
        ]
        guard let syncUrl = syncUrlComponents.url else {
            // TODO: handle this bad scenario
            return
        }
        let request = URLRequest(url: syncUrl)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // TODO: handle this bad scenario
                print(error)
            } else if let data = data {
                // TODO: don't forget to check for matrix errors here
                let json = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String:Any]
                print(json)
            } else {
                // TODO: handle this bad scenario
                print(response as Any)
            }
        }
        task.resume()
    }
}
