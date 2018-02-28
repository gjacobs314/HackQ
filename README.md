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
- Bearer Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwMDk4MDUzLCJ1c2VybmFtZSI6IjEyMzQ1Njc4OTEwMTEiLCJhdmF0YXJVcmwiOiJzMzovL2h5cGVzcGFjZS1xdWl6L2RlZmF1bHRfYXZhdGFycy9VbnRpdGxlZC0xXzAwMDRfZ29sZC5wbmciLCJ0b2tlbiI6bnVsbCwicm9sZXMiOltdLCJjbGllbnQiOiIiLCJndWVzdElkIjpudWxsLCJ2IjoxLCJpYXQiOjE1MTk1MTE5NTksImV4cCI6MTUyNzI4Nzk1OSwiaXNzIjoiaHlwZXF1aXovMSJ9.AoMWU1tj7w0KXYcrm0a8UwxjA0g_xuPehOAAMlPnWNY
- User ID: 10098053

- Bearer Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjExNjY0NTUzLCJ1c2VybmFtZSI6InRydW1wZnRxIiwiYXZhdGFyVXJsIjoiczM6Ly9oeXBlc3BhY2UtcXVpei9kZWZhdWx0X2F2YXRhcnMvVW50aXRsZWQtMV8wMDAxX2JsdWUucG5nIiwidG9rZW4iOm51bGwsInJvbGVzIjpbXSwiY2xpZW50IjoiIiwiZ3Vlc3RJZCI6bnVsbCwidiI6MSwiaWF0IjoxNTE5NTEyMTEyLCJleHAiOjE1MjcyODgxMTIsImlzcyI6Imh5cGVxdWl6LzEifQ.YxOrP_MnZTapJq5kZSmDd3MzG07W8ZeHcluI2l4cZWI
- User ID: 11664553

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
- [ ] Make a website that shows the answers.
- [ ] Improve accuracy and add additional algorithms for searching.
- [ ] Show percentages of answers.
- [ ] Show chat messages.
- [ ] Display the video stream of the game show.
- [ ] Let the program answer for you/submit the best answer, so no need to use your phone.

## Credits:
- [Daniel Smith (Search Method)](https://github.com/DanielSmith1239/)
