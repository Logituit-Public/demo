//
//  ReachabilityHandler.swift
//  JustTaxi
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import UIKit
import Alamofire
import CoreTelephony

enum NetworkType: String {
    case None
    case wifi
    case _2g
    case _3g
    case _4g
    case wwan
}

class ReachabilityHandler: NSObject {
    static let shared : ReachabilityHandler = ReachabilityHandler()
    static let networkChanged = Notification.Name("networkChanged")
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    var isConnected :Bool = false
    var currentNetwork: NetworkType = .None
    
    func listenForReachability() {
        let listener: NetworkReachabilityManager.Listener = { status in
           //rint("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                self.isConnected = false
                let userInfo = ["connected": false] as [String: Any]
                self.currentNetwork = .None
                NotificationCenter.default.post(name: ReachabilityHandler.networkChanged, object: self, userInfo: userInfo)
                break
                
            case .reachable(.ethernetOrWiFi):
                //print("The network is reachable over the WiFi connection")
                self.isConnected = true
                let userInfo = ["connected": true] as [String: Any]
                self.currentNetwork = .wifi
                NotificationCenter.default.post(name: ReachabilityHandler.networkChanged, object: self, userInfo: userInfo)
                break
                
            case .reachable(.cellular):
                //print("The network is reachable over the WWAN connection")
                self.isConnected = true
                
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.currentRadioAccessTechnology
                switch carrierType{
                case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?: self.currentNetwork = ._2g
                case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?: self.currentNetwork = ._3g
                case CTRadioAccessTechnologyLTE?: self.currentNetwork = ._4g
                default: self.currentNetwork = .wwan
                }
                
                let userInfo = ["connected": true] as [String: Any]
                NotificationCenter.default.post(name: ReachabilityHandler.networkChanged, object: self, userInfo: userInfo)
                
                break
                
            case .unknown:
                break
            }
        }
        
        self.reachabilityManager?.startListening(onUpdatePerforming: listener)
    }
    
}
