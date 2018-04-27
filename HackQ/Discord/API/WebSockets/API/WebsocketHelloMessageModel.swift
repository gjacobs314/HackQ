//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

class WebsocketHelloMessageModel : MappableBase {
    var token = Registry.instance.token
    var v = 3
    var os = "MacOS X"
    var browser = "SwiftBot"
    var device = "Computer"
    var referrer = "https://discordapp.com/@me"
    var referringDomain = "discordapp.com"
    var largeThreshold = 100
    var compress = true
    var op = 2

    override func mapping(map: Map) {
        token           <- map["d.token"]
        v               <- map["d.v"]
        os              <- map["d.properties.$os"]
        browser         <- map["d.properties.$browser"]
        device          <- map["d.properties.$device"]
        referrer        <- map["d.properties.$referrer"]
        referringDomain <- map["d.properties.$referring_domain"]
        largeThreshold  <- map["d.large_threshold"]
        compress        <- map["d.compress"]
        op              <- map["op"]
    }

}
