//
//  DoredataManager.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import Foundation
class CoredataManager {
    static let shared: CoredataManager = CoredataManager()
    func getTopApps(isFree: Bool, completion: @escaping(CompletionBlock)) {
        var appType = "top-free"
        if !isFree {
            appType = "top-paid"
        }
        let freeApps = "\(Constants.baseURL)\(appType)/all/10/explicit.json"
        NetworkManager.makeRequest(freeApps) { (success, result) in
            completion(success, result)
        }
    }
}
