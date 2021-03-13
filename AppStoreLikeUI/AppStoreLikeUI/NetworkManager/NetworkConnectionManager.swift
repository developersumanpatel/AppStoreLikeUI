//
//  NetworkConnectionManager.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//

import Reachability

class NetworkConnectionManager: NSObject {
    let reachability = try! Reachability()
    static let shared = NetworkConnectionManager()
    var isConnected: Bool = true
    
    override init() {
        super.init()
        startMonitoring()
    }
    
    func startMonitoring() {
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                isConnected = true
                break
            case .none, .unavailable:
                isConnected = false
                break
            }
        }
        
        func removeNotifire() {
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        }
    }
}
