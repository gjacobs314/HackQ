//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

open class UserModel : MappableBase {
    open var avatar: String?
    open var discriminator: String?
    open var id: String?
    open var username: String?
    open var email: String?
    open var verified: Bool?


    open override func mapping(map: Map) {
        username        <- map["username"]
        avatar          <- map["avatar"]
        discriminator   <- map["discriminator"]
        id              <- map["id"]
        email           <- map["email"]
        verified        <- map["verified"]
    }

}
