//
// Created by David Hedbor on 2/13/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper
class WebsocketMessageModel : MappableBase {
    var type: String?
    var data: [String:AnyObject]?
    var sequence: Int?

    override func mapping(map: Map) {
        type <- map["t"]
        data <- map["d"]
        sequence <- map["s"]
    }

}
