//
//  TSSegue.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 6/10/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa

class TSSegue: NSStoryboardSegue {
    override func perform() {
        guard let identifier = identifier else { return }
                
        if let discordShowVC = (destinationController as! WindowController).contentViewController as? DiscordShow {
            switch identifier.rawValue {
            case "cashShowSegue":
                discordShowVC.discordTrivia = DiscordTrivia(triviaShow: .cashShow)
                discordShowVC.showTitle.stringValue = "CASHSHOW"
            case "joyrideSegue":
                discordShowVC.discordTrivia = DiscordTrivia(triviaShow: .joyride)
                discordShowVC.showTitle.stringValue = "Joyride"
            default:
                return
            }
            
            super.perform()
        }
        
    }
}
