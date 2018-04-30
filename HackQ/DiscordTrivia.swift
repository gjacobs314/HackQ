//
//  DiscordTrivia.swift
//  HackQ
//
//  Created by Nino Vitale on 4/27/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Foundation

typealias DiscordConfidence = [UInt: Float]

protocol DiscordTriviaDelegate: class {
    func didUpdateVotes(votes: DiscordConfidence)
}

enum TriviaShow {
    case hq
    case cashShow
}

class DiscordTrivia: DiscordDelegate, DiscordTriviaNotifyDelegate {
    private enum TriviaConfidence: Float {
        case confident = 1.0
        case notConfident = 0.25
    }
    
    private var show: TriviaShow! {
        didSet {
            switch show {
            case .hq:
                triviaChannels = Config.hqChannels
                break
            default:
                break
            }
        }
    }
    
    let discordNotifier = DiscordTriviaNotifier()
    private let discordBot = Discord()
    
    private var triviaChannels: [String] = []
    private lazy var votes: DiscordConfidence = [1: 0.0, 2: 0.0, 3: 0.0]
    
    weak var delegate: DiscordTriviaDelegate?
    
    init(triviaShow: TriviaShow) {
        setTriviaShow(show: triviaShow)
        
        discordBot.delegate = self
        discordBot.login(Config.discordToken)
        
        discordNotifier.delegate = self
    }
    
    private func setTriviaShow(show: TriviaShow) {
        self.show = show
    }
    
    private func addVote(for answerNumber: UInt, isConfident: Bool) {
        /* sometimes the user isn't sure, but we still want their vote to have some influence
           because if *no one* is sure, we'd get no answer */
        votes[answerNumber]? += isConfident ?
            TriviaConfidence.confident.rawValue :
            TriviaConfidence.notConfident.rawValue
        
        delegate?.didUpdateVotes(votes: votes)
    }
    
    private func resetRound() {
        for key in votes.keys {
            votes.updateValue(0.0, forKey: key)
        }
        
        delegate?.didUpdateVotes(votes: votes)
    }
    
    func discordLoginDidComplete(_ error: DiscordError?) {
        print("Logged in to Discord")
    }
    
    func discordWebsocketEndpointError(_ error: DiscordError?) {
        return
    }
    
    func discordMessageReceived(_ message: MessageModel, event: MessageEventType) {
        guard let channel = message.channelId,
            triviaChannels.contains(channel),
            let content = message.content?.trimmingCharacters(in: .whitespaces) else { return }
        
        switch content {
        case _ where content.hasPrefix("1"):
            addVote(for: 1, isConfident: !content.contains("?"))
            break
        case _ where content.hasPrefix("2"):
            addVote(for: 2, isConfident: !content.contains("?"))
            break
        case _ where content.hasPrefix("3"):
            addVote(for: 3, isConfident: !content.contains("?"))
            break
        default:
            break
        }
    }
    
    func didResetRound() {
        resetRound()
    }
}
