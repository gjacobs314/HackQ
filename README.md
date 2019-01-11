# Welcome to HackQ for Swift (MacOS)

![alt text](https://i.imgur.com/mwgmCpC.png)

## Features:
- Gets questions directly from the HQ WebSocket, no need to do OCR
- Solves them using a search method created by [Daniel Smith](https://github.com/DanielSmith1239/)
- Clean, friendly, and simple UI

## How to use:
- Download the repo/clone it
- Enter in your info (Bearer token, user id, Google API key, Google CSE ID) [you have to fill in the info in ViewController.swift and SiteEncoding.swift]
- Run a pod install to make sure everything is up to date
- Run the project... if you start it before the game is live, it won't connect because the socket url isn't available, so once the game is live, click the "HackQ" label at the top of the window (or you can just wait until the countdown starts to launch it)

## Some info to use for authorization for the WebSocket:
- HQ reset Bearer tokens so you gotta use your own

### Fill in info in lines 31, 50, 57 at the end of the link, and 83 of ViewController.swift and lines 13, and 14 in SiteEncoding.swift

## How it works:
- Uses Alamofire to make a request to the host
- Once the game is live, the "socketUrl" becomes available under the "broadcast" structure
- A socket is opened with SwiftWebSocket, using all required headers
- When a message is received, it is checked if it is a question then it parses the answers and sets the labels as their string value then solves (chat messages come through with the socket too, so this is why you have to check the type)

## Requirements (CocoaPods):
- Alamofire (for HTTPS requests, to find the socketUrl which changes each broadcast)
- SwiftyJSON (for easy JSON parsing)
- SwiftWebSocket (for opening the WebSocket that gets questions and answers, with authorization and other headers)
- KeychainSwift (for the API key/CSE ID)

## Support:
- If you need any help, open an issue, I will try to help

## Disclaimer:
- This is meant for educational use only, I do not advise you to use this in an actual HQ game because it is against their terms of service

## TODO:
- [x] [Make a website that shows the answers... Never mind, HQ emailed me requesting it to be disabled](https://www.thehackq.com)
- [ ] Improve accuracy and add additional algorithms for searching.
- [ ] Show percentages of answers/confidence to aid answering.
- [ ] Show chat messages.
- [ ] Display the video stream of the game show.
- [ ] Let the program answer for you/submit the best answer, so no need to use your phone.

## Credits:
- [Daniel Smith (Search Method)](https://github.com/DanielSmith1239/)
