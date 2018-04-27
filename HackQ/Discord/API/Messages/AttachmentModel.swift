//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

public class AttachmentModel : MappableBase {
    public var id: String?
    public var filename: String?
    public var proxyUrl: String?
    public var url: String?
    public var size: Int?
    public var width : Int?
    public var height: Int?

    public override func mapping(map: Map) {
        id          <- map["id"]
        filename    <- map["filename"]
        proxyUrl    <- map["proxy_url"]
        url         <- map["url"]
        size        <- map["size"]
        width       <- map["width"]
        height      <- map["height"]
    }
}
