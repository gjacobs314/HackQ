//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

open class GatewayUrlResponseModel : MappableBase {
    open var url: String?

    open override func mapping(map: Map) {
        url <- map["url"]
    }
}
