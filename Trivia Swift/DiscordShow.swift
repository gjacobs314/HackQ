//
//  DiscordShow.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 5/3/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa

class DiscordShow: NSViewController, DiscordTriviaDelegate {
    @IBOutlet weak var showTitle: NSTextField!
    @IBOutlet private weak var answerSV: NSStackView!
    
    var discordTrivia: DiscordTrivia?
    private var answerBoxes: [NSBox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerBoxes = answerSV.arrangedSubviews as! [NSBox]
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
        let max = votes.max()
        
        for (index, box) in answerBoxes.enumerated() {
            let vote = votes[index]
            let voteLabel = (box.subviews.first?.subviews.first as! NSStackView).subviews.last! as! NSTextField
            voteLabel.stringValue = "\(vote) \(vote != 1 ? "votes" : "vote")"
            
            vote != 0 && vote == max ?
                (box.fillColor = NSColor(rgb: 0x009432)) :
                (box.fillColor = NSColor.black.withAlphaComponent(0))
        }
    }
}
