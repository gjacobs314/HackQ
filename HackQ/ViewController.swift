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

    /*
    A Bearer token/user ID to use
    
    Bearer Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwMDk4MDUzLCJ1c2VybmFtZSI6IjEyMzQ1Njc4OTEwMTEiLCJhdmF0YXJVcmwiOiJzMzovL2h5cGVzcGFjZS1xdWl6L2RlZmF1bHRfYXZhdGFycy9VbnRpdGxlZC0xXzAwMDRfZ29sZC5wbmciLCJ0b2tlbiI6bnVsbCwicm9sZXMiOltdLCJjbGllbnQiOiIiLCJndWVzdElkIjpudWxsLCJ2IjoxLCJpYXQiOjE1MTk1MTE5NTksImV4cCI6MTUyNzI4Nzk1OSwiaXNzIjoiaHlwZXF1aXovMSJ9.AoMWU1tj7w0KXYcrm0a8UwxjA0g_xuPehOAAMlPnWNY
    User ID: 10098053
    */

    private var answerLabels: [NSTextField] = []

    let hqheaders : HTTPHeaders = [
        "x-hq-client": "iOS/1.2.17",
        "Authorization": "Bearer BEARER_TOKEN_HERE",
        "x-hq-stk": "MQ==",
        "Host": "api-quiz.hype.space",
        "Connection": "Keep-Alive",
        "Accept-Encoding": "gzip",
        "User-Agent": "okhttp/3.8.0"
    ]

    var socketUrl : String = "https://socketUrl"
    
    private var question : String = "Question"
    private var answers: [String] = ["Answer 1", "Answer 2", "Answer 3"]
    private var bestAnswer : String = "Best answer"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        answerLabels = [answer1Label, answer2Label, answer3Label]

        SiteEncoding.addGoogleAPICredentials(apiKeys: ["GOOGLE_API_KEY"], searchEngineID: "GOOGLE_CSE_ID")

        updateLabels()
        getSocketURL()
    }

    func getSocketURL() {
        Alamofire.request("https://api-quiz.hype.space/shows/now?type=hq&userId=USER_ID", headers: hqheaders).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                let broadcast = json["broadcast"]

                if (broadcast != JSON.null) {
                    let secondjson = JSON(broadcast)
                    self.socketUrl = secondjson["socketUrl"].stringValue
                    print(self.socketUrl)
                    print("-----")

                    let replacedSocketUrl = self.socketUrl.replacingOccurrences(of: "https", with: "wss")
                    self.socketUrl = replacedSocketUrl
                    print(self.socketUrl)
                    print("-----")
                } else {
                    print("No socket available. The game is not live.")
                    return
                }
            }

            self.openWebSocket()
        }
    }

    func openWebSocket() {
        var request = URLRequest(url: URL(string: socketUrl)!)
        request.timeoutInterval = 5
        request.addValue("iOS/1.2.17", forHTTPHeaderField: "x-hq-client")
        request.addValue("Bearer BEARER_TOKEN_HERE", forHTTPHeaderField: "Authorization")
        request.addValue("MQ==", forHTTPHeaderField: "x-hq-stk")
        request.addValue("api-quiz.hype.space", forHTTPHeaderField: "Host")
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
                    let json = JSON(receivedAsJSON)
                    
                    let receivedQuestion = json["question"].stringValue
                    self.question = receivedQuestion
                    print(self.question)
                    print("-----")

                    let answersArray = json["answers"].arrayValue
                    print(answersArray)
                    print("-----")

                    let answersJSONArray = JSON(answersArray)
                    for (_, object) in answersJSONArray {
                        let answer = object["text"].stringValue
                        print(answer)
                        print("-----")
                    }
                    
                    for (index, jsonAnwser) in answersArray.enumerated() {
                        let answerText = jsonAnwser["text"].stringValue
                        print("#\(index+1) value in array: " + answerText)
                        print("-----")
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

    func updateLabels() {
        questionLabel.stringValue = self.question
        
        for (index, label) in answerLabels.enumerated() {
            label.stringValue = self.answers[index]
        }
        
        bestAnswerLabel.stringValue = self.bestAnswer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
