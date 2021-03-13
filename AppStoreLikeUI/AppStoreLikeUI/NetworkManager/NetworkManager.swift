//
//  NetworkManager.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import Foundation

typealias CompletionBlock = (_ success: Bool, _ response: Any?) -> Void
class NetworkManager {
    public static func makeRequest(_ urlString: String, completion: @escaping(CompletionBlock)) {
        guard NetworkConnectionManager.shared.isConnected else {
            completion(false, "No internet connection.")
            return
        }
        
        guard let requestURL = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        let request = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false, error?.localizedDescription ?? "No data")
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let jsonResponse = jsonResult as? [String: Any] {
                    completion(true, jsonResponse)
                }
            } catch {
                debugPrint(error)
            }
        }
        task.resume()
    }
}
