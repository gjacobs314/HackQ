# Welcome to Trivia Swift (macOS)

Ever imagined combining the power of an answer bot with Discord crowd-sourced answers? Well, look no further. 

**Trivia Swift is the first app to provide live answers *and* Discord votes for HQ Trivia, as well as supporting other trivia games!** 

Trivia Swift will **always** be free and open-source. No hidden fees, no monthly subscriptions, no downtime.

| ![](https://i.imgur.com/NKIezgd.png) | 
|:--:| 
| *Show selection user interface* |

## Disclaimer: This program is meant for educational purposes only. I do not advise you to use this during a live HQ game because it is against their Terms of Service. For other games, using Trivia Swift is simply a crowd-sourced bot.

## Features:
- Gets questions live, directly from the HQ WebSocket (no need for OCR which is time-consuming and less accurate)
- Solves them using a search method created by [Daniel Smith](https://github.com/DanielSmith1239/)
- Clean, friendly, and simple UI
- Provides Discord crowd-sourced answers for HQ, Cash Show, and Joyride (support for more shows coming soon!)

## How to use:
- Download the repo/clone it.
- **Enter your Google API key and Google Search Engine ID in `Config-default.plist` (this is required; otherwise, it cannot answer HQ questions!).**
- **Add your [Discord token](https://github.com/TheRacingLion/Discord-SelfBot/wiki/Discord-Token-Tutorial) and add the IDs of the channels you want to monitor for each show in `Config-default.plist`.**
- Run a `pod install` to make sure everything is up to date
- Build and run the project. 
- For HQ: if you start it before the game is live, Trivia Swift will show you the time of the next live show and the corresponding prize. Once the game is live, click the "HQ" label at the top of the window. It will connect and display the questions and answers as they are presented during the live show.
- For other shows: Trivia Swift will tally votes from the channels you specify and highlight the recommended answer(s).

## How it works for an HQ game:
- Uses Alamofire to make a request to the host.
- Once the game is live, the `socketUrl` becomes available under the `broadcast` structure.
- A socket is opened with SwiftWebSocket, using all required headers.
- When a message is received, the program checks if this is a a question. If so, it parses the answers, sets the labels as their string value, then solves and displays the confidence value of each answer.
- Also provides crowd-sourced answers simultaneously from the Discord channels you choose.

| ![](https://i.imgur.com/2DwlEdo.png) | 
|:--:| 
| *HQ user interface when no game is live* |

| ![](https://i.imgur.com/wHz8b6X.png) | 
|:--:| 
| *HQ user interface when a game is in progress, with Discord votes quantified as points* |

## How it works for other trivia games:
- Uses Starscream to connect to Discord using your token.
- Once a message is received, Trivia Swift checks if the message is from a channel you want to monitor. If so, it checks if that is an answer and tallies the appropriate vote.
- The answer(s) with the most votes is highlighted in green for Cash Show and Joyride games for easier selection.
- **Before each answer round, you MUST reset the counter manually to ensure accurate votes using the button in the top-right hand corner.** This cannot be done automatically for Cash Show/Joyride because the app does not have a way of knowing when the next question arrives or the game is live. 

| ![](https://i.imgur.com/nM6w1we.png) | 
|:--:| 
| *A Cash Show round with the best answer highlighted in green* |

## Requirements (CocoaPods):
- Alamofire (for HTTPS requests, to find the socketUrl which changes each broadcast)
- SwiftyJSON (for easy JSON parsing)
- SwiftWebSocket (for opening the WebSocket that gets questions and answers, with authorization and other headers)
- Starscream (for connecting to Discord and receiving messages) 
- KeychainSwift (for the API key/Google Search Engine ID)

## Support 

If you need any help, please open an issue and I will assist you.

## TODO:
- [x] Crowdsource answers from Discord trivia server for a second opinion.
- [ ] Add OCR support for games that do not have a public websocket.
- [ ] Support more trivia games.
- [ ] Improve HQ accuracy and add additional algorithms for searching.
- [ ] Adapt the program to run on iOS devices.

## Credits:
- [Daniel Smith (Search Method)](https://github.com/DanielSmith1239/)
- [Gordon Jacobs (original developer)](https://github.com/gjacobs314/HQTrivia)