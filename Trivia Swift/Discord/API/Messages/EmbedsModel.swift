//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper
/*
            {
                "author": { optional
                    "name": "<string>"
                    "url": "<string>" or null
                }
                "description": "<string>" or null
                "provider": { optional
                    "name": "<string>"
                    "url": "<string>" or null
                }
                "thumbnail": { optional
                    "height": <integer>
                    "proxy_url": "<string>"
                    "url": "<string>"
                    "width": <integer>
                }
                "title": "<string>" or null
                "type": "<string>"
                "url": "<string>"
                "video": { optional
                    "height": <integer>
                    "url": "<string>"
                    "width": <integer>
                }
            }
*/
public class EmbeddableModel: MappableBase {
    public var authorName: String?
    public var authorUrl: String?
    public var desc: String?
    public var providerName: String?
    public var providerUrl: String?
    public var thumbnailHeight: Int?
    public var thumbnailWidth: Int?
    public var thumbnailProxyUrl: String?
    public var thumbnailUrl: String?
    public var title: String?
    public var type: String?
    public var url: String?
    public var videoHeight: Int?
    public var videoWidth: Int?
    public var videoUrl: String?

    public override func mapping(map: Map) {
        authorName          <- map["author.name"]
        authorUrl           <- map["author.url"]
        desc                <- map["description"]
        providerName        <- map["provider.name"]
        providerUrl         <- map["provider.url"]
        thumbnailHeight     <- map["thumbnail.height"]
        thumbnailWidth      <- map["thumbnail.width"]
        thumbnailProxyUrl   <- map["thumbnail.proxy_url"]
        thumbnailUrl        <- map["thumbnail.url"]
        title               <- map["title"]
        type                <- map["type"]
        url                 <- map["url"]
        videoHeight         <- map["video.height"]
        videoWidth          <- map["video.width"]
        videoUrl            <- map["video.url"]
    }

}
