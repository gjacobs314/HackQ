//
//  WindowController.swift
//  HackQ
//
//  Created by Gordon on 2/19/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
    }
}
