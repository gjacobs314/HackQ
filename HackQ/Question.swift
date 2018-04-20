//
//  Question.swift
//  HackQ
//
//  Created by Nino Vitale on 4/20/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import SwiftyJSON

/**
 Stores information about each question and its possible answers, as well as the searched results.
*/
struct Question {
    let text: String
    let category: String
    let number: UInt
    let totalCount: UInt
    let possibleAnswers: [String]
    
    var searchedAnswers: Answer?
    
    init(json: JSON) {
        text = json["question"].stringValue
        category = json["category"].stringValue
        number = json["questionNumber"].uIntValue
        totalCount = json["questionCount"].uIntValue
        possibleAnswers = json["answers"].arrayValue.compactMap { $0["text"].stringValue }
    }
}

extension Question: CustomStringConvertible {
    var description: String {
        var desc = "Question \(number) of \(totalCount): \(text)"
        
        for (index, answer) in possibleAnswers.enumerated() {
            desc += "\nAnswer \(index+1): \(answer)"
        }
        
        return desc
    }
}
