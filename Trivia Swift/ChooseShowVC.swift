//
//  ChooseShowVC.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 5/6/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa

class ChooseShowVC: NSViewController {
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let segueName = segue.identifier?.rawValue else { return }
        
        if let discordShowVC = (segue.destinationController as! WindowController).contentViewController as? DiscordShow {
            switch segueName {
            case "cashShowSegue":
                discordShowVC.discordTrivia = DiscordTrivia(triviaShow: .cashShow)
                discordShowVC.showTitle.stringValue = "CASHSHOW"
            case "joyrideSegue":
                discordShowVC.discordTrivia = DiscordTrivia(triviaShow: .joyride)
                discordShowVC.showTitle.stringValue = "Joyride"
            default:
                return
            }
        }
    }
}
