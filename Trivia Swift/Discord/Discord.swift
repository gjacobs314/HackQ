//
// Created by David Hedbor on 2/13/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//
// Main interface point with the Discord API

import Foundation

public enum DiscordError: Error {
    case missingToken
    case invalidToken
    case endpoint
}

public protocol DiscordDelegate : class {
    func discordLoginDidComplete(_ error: DiscordError?)
    func discordWebsocketEndpointError(_ error: DiscordError?)
    func discordMessageReceived(_ message: MessageModel, event: MessageEventType)
}

open class Discord: WebsocketAPIManagerDelegate {
    fileprivate var websocketManager: WebsocketAPIManager
    open weak var delegate: DiscordDelegate?

    public init() {
        self.websocketManager = WebsocketAPIManager()
        self.websocketManager.delegate = self
    }

    open func login(_ token: String? = nil) {
        if let _ = token {
            Registry.instance.token = token
            self.websocketManager.fetchEndpointAndConnect()
            self.delegate?.discordLoginDidComplete(nil)
        } else {
            LOG_ERROR("No bot token available, try again.")
            self.delegate?.discordLoginDidComplete(.missingToken)
        }
    }

    open func updateLoginWithToken(_ token: String) {
        Registry.instance.token = token
        self.websocketManager.fetchEndpointAndConnect()
    }

    open func sendMessage(_ message: String, channel: String, tts: Bool = false, mentions: [String]? = nil) {
        let messageSender = SendMessageRequest(content: message, mentions: mentions)
        messageSender.tts = tts
        messageSender.sendOnChannel(channelId: channel)
    }

    open func sendPrivateMessage(_ message: String, recipientId: String) {
        let privateChannelRequest = PrivateChannelRequest(recipientId: recipientId)
        privateChannelRequest.execute({ (channelId: String?) in
            guard let channelId = channelId else {
                LOG_ERROR("Cannot send private message - failed to get channel")
                return
            }
            self.sendMessage(message, channel: channelId)
        })
    }

    open func websocketEndpointError() {
        delegate?.discordWebsocketEndpointError(.endpoint)
    }

    open func websocketMessageReceived(_ message: MessageModel, event: MessageEventType) {
        delegate?.discordMessageReceived(message, event: event)
    }

    // Typically means login is out-of-date, try to log in again
    open func websocketAuthenticationError() {
        delegate?.discordLoginDidComplete(.invalidToken)
    }

}
