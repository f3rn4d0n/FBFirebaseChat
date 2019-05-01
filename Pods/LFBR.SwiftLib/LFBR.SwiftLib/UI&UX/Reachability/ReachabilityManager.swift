//
//  ReachabilityManager.swift
//  ReachabilityTest
//
//  Created by Janet García on 8/27/18.
//

import Foundation

//Known before as InternetServices
public class ReachabilityManager: NSObject {
    
    public static let sharedInstance = ReachabilityManager()
    public var reachability: Reachability?
    var internetStatus: Reachability.Connection = .none
    public var isInternetAvaliable = false
    
    private override init() {
        super.init()
        
        reachability = Reachability()
        startNotifier()
        isInternetAvailable()
        NotificationCenter.default.addObserver(self, selector: #selector(showInetStatus(_:)), name: .reachabilityChanged, object: reachability
        )
    }
    
    func startNotifier() {
        print("Internet --- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("Internet Unable to start\nnotifier")
            return
        }
    }
    
    //showInetStatus & reachabilityChangedSelector methods replacement
    @objc func showInetStatus(_ note: Notification) {
        reachabilityChangedSelector()
    }
    
    public func reachabilityChangedSelector() {
        let internetConnectionStatus: Reachability.Connection = reachability?.connection ?? .none
        var dictionary = [String:String]()
        switch internetConnectionStatus {
        case .cellular:
            dictionary["Status"] = "1"
            dictionary["medium"] = "ReachableViaWWAN"
            internetStatus = .cellular
            isInternetAvaliable = true
            print("Internet ReachableViaWWAN available")
            break
        case .wifi:
            dictionary["Status"] = "1"
            dictionary["medium"] = "ReachableViaWiFi"
            internetStatus = .wifi
            isInternetAvaliable = true
            print("Internet ReachableViaWiFi available")
            
            break
        case .none:
            dictionary["Status"] = "0"
            dictionary["medium"] = "global_lbl_rednodisponible_1"
            internetStatus = .none
            isInternetAvaliable = false
            print("Internet NOT available")
            
            break
        }
        
        internetConnectionBanner()
    }
    
    func internetConnectionBanner() {
        if ReachabilityManager.sharedInstance.isInternetAvaliable {
            //BannerViewManager.shared.hideBannerView(ofType: .INTERNET)
        } else {
            //BannerViewManager.shared.showBannerView(ofType: .INTERNET)
        }
    }
    
    public func isInternetAvailable() {
        if let internetStatus: Reachability.Connection = reachability?.connection {
            if internetStatus != .none {
                isInternetAvaliable = true
            } else {
                isInternetAvaliable = false
            }
        } else {
            isInternetAvaliable = false
        }
    }
}
