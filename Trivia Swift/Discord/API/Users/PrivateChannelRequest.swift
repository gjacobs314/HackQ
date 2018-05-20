//
// Created by David Hedbor on 2/14/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

// Not exposed
private class PrivateChannelResponseModel : MappableBase {
    var channelId: String?

    override func mapping(map: Map) {
        channelId   <- map["id"]
    }
}

open class PrivateChannelRequest {
    fileprivate var recipientId: String

    public init(recipientId: String) {
        self.recipientId = recipientId
    }

    open func execute(_ callback: @escaping (String?)->Void) {
        guard let token = Registry.instance.token else {
            LOG_ERROR("No authorization token found.")
            return
        }
        guard let userId = Registry.instance.user?.id else {
            LOG_ERROR("No authorization token found.")
            return
        }
        Alamofire.request(Endpoints.User(userId, endpoint: .Channel), method: .post, parameters:["recipient_id": recipientId],
                          encoding: JSONEncoding.default, headers: ["Authorization": token]).responseObject {
            (response: DataResponse<PrivateChannelResponseModel>) in
            print("Private channel is \(response.result.value)")
            if let channelId = response.result.value?.channelId {
                callback(channelId)
            } else {
                if let error = response.result.error {
                    LOG_ERROR("Failed to create private channel: \(error)")
                }
                callback(nil)
            }
        }
    }
}
