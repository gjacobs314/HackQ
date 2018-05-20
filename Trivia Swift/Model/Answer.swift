//
//  Answer.swift
//  Trivia Swift
//
//  Created by Nino Vitale on 4/23/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

typealias AnswerText = (id: UInt64, text: String)
typealias AnswerProb = (id: UInt64, probability: Float)

/**
 Stores information about each answer and its probability of being the correct answer
*/
class Answer
{
    let id: UInt64
    let text: String
    
    private(set) var probability: Float = 0.0
    
    init(id: UInt64, text: String) {
        self.id = id
        self.text = text
    }
    
    func updateProbability(prob: Float) {
        probability = prob
    }
}

extension Float {
    var rounded: String {
        return self.percentageRoundedTo(places: 1)
    }
}

extension Answer: CustomStringConvertible {
    var description: String {
        return "\(text) (\(probability.rounded)%)"
    }
}

extension Array where Element == Answer {
    subscript(id: UInt64) -> Answer? {
        get {
            return self.filter({ $0.id == id }).first
        }
        
        set {
            let answer = self.filter({ $0.id == id }).first
            answer?.updateProbability(prob: newValue?.probability ?? 0.0)
        }
    }
    
    var highest: Answer? {
        return self.sorted { $0.probability > $1.probability }.first
    }
}
