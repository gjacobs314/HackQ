//
//  DiscordShow.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 5/3/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa
import HotKey

class DiscordShow: NSViewController, DiscordTriviaDelegate {
    @IBOutlet weak var showTitle: NSTextField!
    @IBOutlet private weak var answerSV: NSStackView!

    let resetShortcutPressed = HotKey(key: .r, modifiers: [.command])
    var discordTrivia: DiscordTrivia?
    private var discordVoteBoxes: [NSBox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetShortcutPressed.keyDownHandler = { [unowned self] in
            self.discordTrivia?.discordNotifier.notifyRoundReset()
        }
        
        discordVoteBoxes = answerSV.arrangedSubviews as! [NSBox]
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        discordTrivia?.delegate = self
        discordTrivia?.discordNotifier.notifyBroadcastStateChanged(isLive: true)
        view.window!.styleMask.remove(.resizable)
    }
    
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: closeSocketNotificationName), object: nil)
    }
    
    @IBAction func resetButtonPressed(_ sender: NSButton) {
        discordTrivia?.discordNotifier.notifyRoundReset()
    }
    
    func didUpdateVotes(votes: DiscordConfidence) {
        discordVoteBoxes.updateVotes(votes: votes, for: discordTrivia!.show)
    }
}
