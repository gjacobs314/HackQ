//
// Created by David Hedbor on 2/13/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//
// Very basic implementation of the ready message since we currently don't care about the details.

import Foundation
import ObjectMapper

class WebsocketReadyMessageModel : MappableBase {
    var user: UserModel?
    var sessionId: String?

    override func mapping(map: Map) {
        user                <- map["user"]
        sessionId           <- map["session_id"]
    }

}
