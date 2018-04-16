# Welcome to HackQ for Swift (macOS)

![alt text](https://i.imgur.com/mwgmCpC.png)

## Disclaimer: This program is meant for educational purposes only. I do not advise you to use this during a live HQ game because it is against their Terms of Service.

## Features:
- Gets questions live, directly from the HQ WebSocket (no need for OCR which is time-consuming and less accurate)
- Solves them using a search method created by [Daniel Smith](https://github.com/DanielSmith1239/)
- Clean, friendly, and simple UI

## How to use:
- Download the repo/clone it.
- **Enter your Google API key and Google Search Engine ID in `Config-default.plist` (this is required; otherwise, it cannot answer questions!).**
- Run a `pod install` to make sure everything is up to date
- Build and run the project. If you start it before the game is live, HackQ will show you the time of the next live show and the corresponding prize. Once the game is live, click the "HackQ" label at the top of the window. It will connect and display the questions and answers as they are presented during the live show.

## How it works:
- Uses Alamofire to make a request to the host.
- Once the game is live, the `socketUrl` becomes available under the `broadcast` structure.
- A socket is opened with SwiftWebSocket, using all required headers.
- When a message is received, the program checks if this is a a question. If so, it parses the answers, sets the labels as their string value, then solves and displays the confidence value of each answer.

## Requirements (CocoaPods):
- Alamofire (for HTTPS requests, to find the socketUrl which changes each broadcast)
- SwiftyJSON (for easy JSON parsing)
- SwiftWebSocket (for opening the WebSocket that gets questions and answers, with authorization and other headers)
- KeychainSwift (for the API key/Google Search Engine ID)

## Support 

If you need any help, open an issue and I will assist you. Alternatively, you can contact the [developer of the original project](https://github.com/gjacobs314/HQTrivia).

## TODO:
- [ ] Crowdsource answers from Discord trivia server for a second opinion.
- [ ] Improve accuracy and add additional algorithms for searching.
- [ ] Show chat messages.
- [ ] Display the video stream of the game show.
- [ ] Adapt the program to run on iOS devices.

## Credits:
- [Daniel Smith (Search Method)](https://github.com/DanielSmith1239/)
- [Gordon Jacobs (original developer)](https://github.com/gjacobs314/HQTrivia)