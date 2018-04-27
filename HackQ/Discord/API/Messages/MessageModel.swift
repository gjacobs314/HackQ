//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper
/*

Message format:

{
    "nonce": "1453949470692605952",
    "attachments": [],
    "tts": false,
    "embeds": [],
    "timestamp": "2015-10-07T20:12:45.743000+00:00",
    "mention_everyone": false,
    "id": "111222333444555666",
    "edited_timestamp": null,
    "author": {
        "username": "Test Account",
        "discriminator": "1234",
        "id": "111222333444555666",
        "avatar": "31171c07640015bbc5aed21b28ea2408"
    },
    "content": "I'm a test message~",
    "channel_id": "81384788765712384",
    "mentions": []
}
*/
public enum MessageEventType
{
    case Create, Update
}


public class MessageModel : MappableBase {
    public var attachments: [AttachmentModel]?
    public var embeds: [EmbeddableModel]?
    public var author: UserModel?
    public var editedTimestamp: NSDate?
    public var tts: Bool?
    public var timestamp: NSDate?
    public var id: String?
    public var nonce: String?
    public var content: String?
    public var channelId: String?
    public var guildId: String?
    public var mentions: [UserModel]?
    public var mentionsEveryone: Bool?

    public override func mapping(map: Map) {
        attachments		    <- map["attachments"]
        embeds 			    <- map["embeds"]
        author 		    	<- map["author"]
        editedTimestamp 	<- map["edited_timestamp"]
        tts				    <- map["tts"]
        timestamp 		    <- map["timestamp"]
        id				    <- map["id"]
        nonce 			    <- map["nonce"]
        content			    <- map["content"]
        channelId			<- map["channel_id"]
        guildId             <- map["guild_id"]
        mentions 			<- map["mentions"]
        mentionsEveryone 	<- map["mentions_everyone"]
    }

}
