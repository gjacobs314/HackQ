//
//  DiscordTriviaTest.swift
//  HackQTests
//
//  Created by Nino Vitale on 5/2/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import XCTest

@testable import HackQ

class DiscordTriviaTest: XCTestCase {
    private let discordTrivia = DiscordTrivia(triviaShow: .hq)
    
    func testisValidVote() {
        let votes = ["1", "2", "3", "4", "1 apg", "1?????", "21", "10.5", "its 3"]
        let expectations = [true, true, true, false, true, true, false, false, true]
        
        let isValid = votes.map { discordTrivia.isValidVote($0) }
        
        XCTAssertEqual(isValid, expectations)
    }
}
