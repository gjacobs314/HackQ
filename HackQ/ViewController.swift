//
//  ViewController.swift
//  HackQ
//
//  Created by Gordon on 2/19/18.
//  Copyright © 2018 Gordon Jacobs. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import SwiftWebSocket

class ViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var nextGameLabel: NSTextField!
    @IBOutlet weak var nextGameInfoLabel: NSTextField!
    @IBOutlet private weak var fixedQuestionLabel: NSTextField!
    @IBOutlet private weak var fixedAnswer1Label: NSTextField!
    @IBOutlet private weak var fixedAnswer2Label: NSTextField!
    @IBOutlet private weak var fixedAnswer3Label: NSTextField!
    @IBOutlet private weak var fixedBestAnswerLabel: NSTextField!
    @IBOutlet private weak var questionLabel: NSTextField!
    @IBOutlet private weak var answer1Label: NSTextField!
    @IBOutlet private weak var answer2Label: NSTextField!
    @IBOutlet private weak var answer3Label: NSTextField!
    @IBOutlet private weak var bestAnswerLabel: NSTextField!
    
    private var fixedLabels: [NSTextField] = []
    private var answerLabels: [NSTextField] = []

    private let hqheaders : HTTPHeaders = [
        "x-hq-client": Config.hqClient,
        "Authorization": Config.bearerToken,
        "x-hq-stk": "MQ==",
        "Host": Config.hostURL,
        "Connection": "Keep-Alive",
        "Accept-Encoding": "gzip",
        "User-Agent": "okhttp/3.8.0"
    ]

    private var socketUrl = "https://socketUrl"
    
    private var question = "Question"
    private var questionCount: UInt = 0
    private var answers = ["Answer 1", "Answer 2", "Answer 3"]
    private var bestAnswer = "Best answer"

    override func viewDidLoad() {
        super.viewDidLoad()
        fixedLabels = [fixedQuestionLabel, fixedAnswer1Label, fixedAnswer2Label, fixedAnswer3Label, fixedBestAnswerLabel]
        answerLabels = [answer1Label, answer2Label, answer3Label]

        SiteEncoding.addGoogleAPICredentials(apiKeys: [Config.googleAPIKey],
                                             searchEngineID: Config.googleSearchEngineID)

        updateLabels()
        getSocketURL()
    }

    func getSocketURL() {
        Alamofire.request("\(Config.hostFullURL)\(Config.userID)", headers: hqheaders).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                let broadcast = json["broadcast"]
                
                if (broadcast != JSON.null) {
                    print("Game is live!")
                    self.showQuestionsAndAnswers()
                    
                    self.socketUrl = JSON(broadcast)["socketUrl"].stringValue
                    print(self.socketUrl)
                    print("-----")

                    self.socketUrl = self.socketUrl.replacingOccurrences(of: "https", with: "wss")
                    print(self.socketUrl)
                    print("-----")
                } else {
                    print("No socket available. The game is not live.")
                    let prize = json["nextShowPrize"].stringValue
                    let showTime = Date(RFC3339FormattedString: json["nextShowTime"].stringValue)!
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    formatter.doesRelativeDateFormatting = true
                    
                    let prettyShowTime = formatter.string(from: showTime)
                    
                    self.nextGameInfoLabel.stringValue = "\(prettyShowTime)\n\(prize) prize"
                    self.toggleNextGameInfo(true)

                    return
                }
            }

            self.openWebSocket()
        }
    }

    func openWebSocket() {
        var request = URLRequest(url: URL(string: socketUrl)!)
        request.timeoutInterval = 5
        request.addValue(Config.hqClient, forHTTPHeaderField: "x-hq-client")
        request.addValue(Config.bearerToken, forHTTPHeaderField: "Authorization")
        request.addValue("MQ==", forHTTPHeaderField: "x-hq-stk")
        request.addValue(Config.hostURL, forHTTPHeaderField: "Host")
        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("okhttp/3.8.0", forHTTPHeaderField: "User-Agent")
        let ws = WebSocket(request: request)

        ws.event.open = {
            print("Opened web socket.")
            print("-----")
        }

        ws.event.error = { error in
            print("Error: \(error)")
            print("-----")
        }

        ws.event.message = { message in
            if let receivedString = message as? String,
                let data = receivedString.data(using: .utf8),
                let receivedAsJSON = try! JSONSerialization.jsonObject(with: data) as? [String: Any],
                let type = receivedAsJSON["type"] as? String {
                
                if (type == "question") {
                    self.questionCount += 1
                    let json = JSON(receivedAsJSON)
                    
                    let receivedQuestion = json["question"].stringValue
                    self.fixedQuestionLabel.stringValue = "Question \(self.questionCount):"
                    self.question = receivedQuestion
                    print(self.question)
                    
                    for (index, jsonAnswer) in json["answers"].arrayValue.enumerated() {
                        let answerText = jsonAnswer["text"].stringValue
                        print("Answer #\(index+1): " + answerText)
                        self.answers[index] = answerText
                    }
                    
                    self.getMatches()
                    
                    self.updateLabels()
                }
                
                if (type == "broadcastEnded") {
                    self.openWebSocket()
                }
            }
        }
    }

    @IBAction func openSocket(_ sender: Any) {
        getSocketURL()
        openWebSocket()
    }

    ///Retrieves the correct answer
    private func getMatches()
    {
        AnswerController.answer(for: question, answers: answers) { answer in
            let correctFormattedAnswer = Answer.format(answer: answer.correctAnswer, confidence: answer.probability)
            print("Predicted correct answer: \(correctFormattedAnswer) confidence)")
            print("-----")
            
            for (index, ans) in self.answers.enumerated() {
                if ans == answer.correctAnswer {
                    self.answers[index] = correctFormattedAnswer + ")"
                    self.bestAnswer = correctFormattedAnswer + " confidence)"
                } else {
                    if let otherAnswer = answer.others.filter({ $0.0 == ans }).first {
                        self.answers[index] = Answer.format(answer: otherAnswer.0, confidence: otherAnswer.1) + ")"
                    }
                }
            }
            
            self.updateLabels()
        }
    }
    
    func toggleNextGameInfo(_ state: Bool) {
        if state {
            nextGameLabel.isHidden = !state
            nextGameInfoLabel.isHidden = false
            return
        }
        
        nextGameLabel.isHidden = true
        nextGameInfoLabel.isHidden = state
    }
    
    func showQuestionsAndAnswers() {
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 2.0
            self.nextGameInfoLabel.animator().alphaValue = 0.0
        }, completionHandler: {
            self.toggleNextGameInfo(false)
            
            self.questionLabel.isHidden = !self.questionLabel.isHidden
            self.fixedLabels.forEach { $0.isHidden = !$0.isHidden }
            self.answerLabels.forEach { $0.isHidden = !$0.isHidden }
            self.bestAnswerLabel.isHidden = !self.bestAnswerLabel.isHidden
        })
    }

    func updateLabels() {
        questionLabel.stringValue = self.question
        
        for (index, label) in answerLabels.enumerated() {
            label.stringValue = self.answers[index]
        }
        
        bestAnswerLabel.stringValue = self.bestAnswer
    }
}
