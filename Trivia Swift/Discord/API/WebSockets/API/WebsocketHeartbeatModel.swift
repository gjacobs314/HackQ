//
// Created by David Hedbor on 2/13/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

class WebsocketHeartbeatModel : MappableBase {
    var op = 1
    var sequence: Int?

    required init?(map: Map) {
        super.init(map: map)
    }

    init(sequence: Int) {
        self.sequence = sequence
        super.init()
    }

    override func mapping(map: Map) {
        op        <- map["op"]
        sequence  <- map["d"]
    }

}
