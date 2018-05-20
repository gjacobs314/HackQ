//
//  DiscordTrivia.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 4/27/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Foundation

/// An array of confidence votes from Discord, sorted by answer key and rounded to the nearest integer.
typealias DiscordConfidence = [Int]

/// A dictionary of confidence votes from Discord where each key is the answer choice (1, 2, or 3).
private typealias DiscordKeyAnswers = [UInt: Float]

protocol DiscordTriviaDelegate: class {
    func didUpdateVotes(votes: DiscordConfidence)
}

enum TriviaShow {
    case hq
    case cashShow
    case joyride
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
            case .cashShow:
                triviaChannels = Config.cashShowChannels
                break
            case .joyride:
                triviaChannels = Config.joyrideChannels
                break
            default:
                break
            }
        }
    }
    
    let discordNotifier = DiscordTriviaNotifier()
    private let discordBot = Discord()
    
    private var isBroadcastLive = false
    private var triviaChannels: [String] = []
    private lazy var votes: DiscordKeyAnswers = [1: 0.0, 2: 0.0, 3: 0.0]
    
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
        
        delegate?.didUpdateVotes(votes: sortVotes(for: votes))
    }
    
    private func resetRound() {
        for key in votes.keys {
            votes.updateValue(0.0, forKey: key)
        }
        
        delegate?.didUpdateVotes(votes: sortVotes(for: votes))
    }
    
    private func sortVotes(for votes: DiscordKeyAnswers) -> DiscordConfidence {
        return votes.sorted(by: { $0.key < $1.key }).map { Int(roundf($0.value)) }
    }
    
    func discordLoginDidComplete(_ error: DiscordError?) {
        print("Logged in to Discord")
    }
    
    func discordWebsocketEndpointError(_ error: DiscordError?) {
        return
    }
    
    func discordMessageReceived(_ message: MessageModel, event: MessageEventType) {
        guard let channel = message.channelId,
            isBroadcastLive,
            triviaChannels.contains(channel),
            let vote = message.content?.trimmingCharacters(in: .whitespaces) else { return }
        
        if isValidVote(vote) {
            tallyVote(vote)
        }
    }
    
    func isValidVote(_ vote: String) -> Bool {
        let voteMatchingPattern = "^[1-3]$|^[1-3][^\\w.,]|^(?:it's|its)\\s+[1-3]"
        if let _ = vote.range(of: voteMatchingPattern,
                              options: [.regularExpression, .caseInsensitive],
                              range: nil,
                              locale: nil) {
            return true
        }
        
        return false
    }
    
    private func tallyVote(_ vote: String) {
        switch vote {
        case _ where vote.contains("1"):
            addVote(for: 1, isConfident: !vote.contains("?"))
            break
        case _ where vote.contains("2"):
            addVote(for: 2, isConfident: !vote.contains("?"))
            break
        case _ where vote.contains("3"):
            addVote(for: 3, isConfident: !vote.contains("?"))
            break
        default:
            break
        }
    }
    
    func didResetRound() {
        print("Round has been reset")
        resetRound()
    }
    
    func broadcastStateChanged(isLive: Bool) {
        if isBroadcastLive != isLive {
            print("Show broadcast changed to: \(isLive)")
            isBroadcastLive = isLive
        }
    }
}
