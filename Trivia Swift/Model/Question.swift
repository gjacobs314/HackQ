//
//  Question.swift
//  Trivia Swift
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
    
    var answers: [Answer]
    var hasSearchCompleted: Bool = false
    
    init(json: JSON) {
        text = json["question"].stringValue
        category = json["category"].stringValue
        number = json["questionNumber"].uIntValue
        totalCount = json["questionCount"].uIntValue
        answers = json["answers"].arrayValue.compactMap { Answer(id: $0["answerId"].uInt64Value,
                                                                 text: $0["text"].stringValue) }
    }
}

extension Question: CustomStringConvertible {
    var description: String {
        var desc = "Question \(number) of \(totalCount): \(text)"
        for (index, answer) in answers.enumerated() {
            desc += "\nAnswer \(index+1): "
            hasSearchCompleted ? (desc += String(describing: answer)) : (desc += answer.text)
        }
        
        return desc
    }
}
