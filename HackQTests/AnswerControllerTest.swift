//
//  HackQTests.swift
//  HackQTests
//
//  Created by Nino Vitale on 4/20/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import HackQ

class AnswerControllerTest: XCTestCase {
    func fetchQuestionsFromJSONFile() -> JSON {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "questions", withExtension: "json")!
        return try! JSON(data: try! Data(contentsOf: fileURL))
    }
    
    func parseQuestions(_ questions: JSON) -> [Question] {
        return questions.arrayValue.compactMap { Question(json: $0) }
    }
    
    func testGoogleAnswers() {
        let questions = parseQuestions(fetchQuestionsFromJSONFile())
        questions.forEach {
            print(String(describing: $0))
            
            let expect = expectation(description: "AnswerController performs a Google Search and returns confidence values for each of the answers.")
            
            let answersIDAndText = $0.answers.compactMap { ($0.id, $0.text) }
            AnswerController.answer(for: $0.text, answers: answersIDAndText) { answers in
                print(answers)
                XCTAssert(answers.count > 0)
                expect.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail("Timeout fetching Google answers: \(error)")
                }
            }
        }
    }
}
