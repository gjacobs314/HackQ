//
//  AppDelegate.swift
//  HackQ
//
//  Created by Gordon on 2/19/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa

struct Config {
    private static let configJSON: NSDictionary = {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)!
        } else {
            return NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Config-default", ofType: "plist")!)!
        }
    }()
    
    static let bearerToken: String = {
        return configJSON["BearerToken"] as! String
    }()
    
    static let userID: String = {
        return configJSON["UserID"] as! String
    }()
    
    static let hostURL: String = {
        return configJSON["HostURL"] as! String
    }()
    
    static let hostFullURL: String = {
        return configJSON["HostFullURL"] as! String
    }()
    
    static let hqClient: String = {
        return configJSON["HQClient"] as! String
    }()
    
    private static let googleRoot: NSDictionary = {
        return configJSON["Google"] as! NSDictionary
    }()
    
    static let googleAPIKey: String = {
        let key = "\(googleRoot["APIKey"]!)"
        if key.count == 0 { print("Warning: Google API Key not set!") }
        return key
    }()
    
    static let googleSearchEngineID: String = {
        let searchEngineID = "\(googleRoot["SearchEngineID"]!)"
        if searchEngineID.count == 0 { print("Warning: Google Search Engine ID not set!") }
        return searchEngineID
    }()
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
