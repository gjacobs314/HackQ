//
// Created by David Hedbor on 2/13/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class SendMessageRequest {
    var content: String = ""
    var mentions: [String] = []
    var nonce: String
    var tts = false

    init(content: String, mentions: [String]? = nil) {
        self.content = content
        if let mentions = mentions {
            self.mentions = mentions
        }
        self.nonce = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }

    private func createMessage() -> Parameters {
        return [
                "content": self.content,
                "mentions": self.mentions,
                "nonce": self.nonce,
                "tts": self.tts
        ]
    }

    func sendOnChannel(channelId: String) {
        guard let token = Registry.instance.token else {
            LOG_ERROR("No authorization token found.")
            return
        }
        Alamofire.request(Endpoints.Channel(channelId), method: .post, parameters: createMessage(),
                         encoding: JSONEncoding.default, headers: ["Authorization": token])
                .responseObject {
                    (response: DataResponse<MessageModel>) in
                    print("message is \(response.result.value)")
                }
    }
}

