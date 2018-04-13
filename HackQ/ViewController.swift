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

private let bearerTokenConstant = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE2MjQ3MTY0LCJ1c2VybmFtZSI6InNwYXo5MjYiLCJhdmF0YXJVcmwiOiJodHRwczovL2QyeHUxaGRvbWgzbnJ4LmNsb3VkZnJvbnQubmV0L2RlZmF1bHRfYXZhdGFycy9VbnRpdGxlZC0xXzAwMDJfcHVycGxlLnBuZyIsInRva2VuIjoiRGV5TTlVIiwicm9sZXMiOltdLCJjbGllbnQiOiJpT1MvMS4zLjIgYjg0IiwiZ3Vlc3RJZCI6bnVsbCwidiI6MSwiaWF0IjoxNTIzMzYxNDU0LCJleHAiOjE1MzExMzc0NTQsImlzcyI6Imh5cGVxdWl6LzEifQ.BaeVxMHb75GoQjsQWMwECO4GLu75pPygdoLIql3ohHk"
private let userIDConstant = "16247164"
private let googleSearchAPIKeyConstant = "AIzaSyBzVlcl79pu1ItkCLYqwe7_vjmGxG4tObE"
private let googleSearchSearchEngineIDConstant = "004052065808184753945:elxpxzkusvs"

class ViewController: NSViewController, NSTextFieldDelegate {

    /*
    A Bearer token/user ID to use
    
    Bearer Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwMDk4MDUzLCJ1c2VybmFtZSI6IjEyMzQ1Njc4OTEwMTEiLCJhdmF0YXJVcmwiOiJzMzovL2h5cGVzcGFjZS1xdWl6L2RlZmF1bHRfYXZhdGFycy9VbnRpdGxlZC0xXzAwMDRfZ29sZC5wbmciLCJ0b2tlbiI6bnVsbCwicm9sZXMiOltdLCJjbGllbnQiOiIiLCJndWVzdElkIjpudWxsLCJ2IjoxLCJpYXQiOjE1MTk1MTE5NTksImV4cCI6MTUyNzI4Nzk1OSwiaXNzIjoiaHlwZXF1aXovMSJ9.AoMWU1tj7w0KXYcrm0a8UwxjA0g_xuPehOAAMlPnWNY
    User ID: 10098053
    */

    @IBOutlet weak var questionLabel: NSTextField!
    @IBOutlet weak var answer1Label: NSTextField!
    @IBOutlet weak var answer2Label: NSTextField!
    @IBOutlet weak var answer3Label: NSTextField!
    @IBOutlet weak var bestAnswerLabel: NSTextField!

    let hqheaders : HTTPHeaders = [
        "x-hq-client": "iOS/1.2.17",
        "Authorization": "Bearer \(bearerToken)",
        "x-hq-stk": "MQ==",
        "Host": "api-quiz.hype.space",
        "Connection": "Keep-Alive",
        "Accept-Encoding": "gzip",
        "User-Agent": "okhttp/3.8.0"
    ]

    var socketUrl : String = "https://socketUrl"
    var question : String = "Question"
    var answer1 : String = "Answer 1"
    var answer2 : String = "Answer 2"
    var answer3 : String = "Answer 3"
    var bestAnswer : String = "Best answer"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        SiteEncoding.addGoogleAPICredentials(apiKeys: [googleSearchAPIKey], searchEngineID: googleSearchSearchEngineID)

        updateLabels()
        getSocketURL()
    }

    func getSocketURL() {
        Alamofire.request("https://api-quiz.hype.space/shows/now?type=hq&userId=\(userID)", headers: hqheaders).responseJSON { response in
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
                }
            }

            self.openWebSocket()
        }
    }

    func openWebSocket() {
        var request = URLRequest(url: URL(string: socketUrl)!)
        request.timeoutInterval = 5
        request.addValue("iOS/1.2.17", forHTTPHeaderField: "x-hq-client")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
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

                print("Message received: \(receivedString)")
                print("-----")

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

                    let firstJSON = JSON((answersArray.first)!)
                    let firstText = firstJSON["text"].stringValue
                    print("First value in array: " + firstText)
                    print("-----")
                    self.answer1 = firstText

                    let middleJSON = JSON(answersArray[1])
                    let middleText = middleJSON["text"].stringValue
                    print("Second value in array: " + middleText)
                    print("-----")
                    self.answer2 = middleText

                    let lastJSON = JSON((answersArray.last)!)
                    let lastText = lastJSON["text"].stringValue
                    print("Last value in array: " + lastText)
                    print("-----")
                    self.answer3 = lastText

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
        let options = [answer1, answer2, answer3]
        AnswerController.answer(for: question, answers: options) { answer in

            print("Predicted correct answer: \(answer.correctAnswer)")
            print("-----")

            self.bestAnswer = answer.correctAnswer

            self.updateLabels()
        }
    }

    func updateLabels() {
        questionLabel.stringValue = self.question
        answer1Label.stringValue = self.answer1
        answer2Label.stringValue = self.answer2
        answer3Label.stringValue = self.answer3
        bestAnswerLabel.stringValue = self.bestAnswer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
