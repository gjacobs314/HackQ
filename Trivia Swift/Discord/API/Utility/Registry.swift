//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation

class Registry {
    static let instance = Registry()
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.235 Chrome/47.0.2526.110 SwiftBot/1.0.0 Safari/537.36"
    var token: String?
    var websocketEndpoint: String?
    var debugEnabled = false
    var user: UserModel?
}
