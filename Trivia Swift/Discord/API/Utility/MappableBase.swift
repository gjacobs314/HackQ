//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation
import ObjectMapper

open class MappableBase : Mappable, CustomStringConvertible, CustomDebugStringConvertible {

    public required init?(map: Map) {
        self.mapping(map: map)
    }

    public init() {}

    open func mapping(map: Map) {    }


    fileprivate func formatDescription(_ prettyPrint: Bool) -> String {
        let json = Mapper().toJSONString(self, prettyPrint: prettyPrint)
        let cls = NSStringFromClass(type(of: self))
        return "\(cls)(\(json))"
    }
    open var description: String {
        return formatDescription(false)
    }

    open var debugDescription: String {
        return formatDescription(false)
    }

}
