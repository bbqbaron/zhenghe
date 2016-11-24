# Zheng He

is a toy location search app named for the Chinese explorer [Zheng He](https://en.wikipedia.org/wiki/Zheng_He).

# Dependencies Reviewed

* [Carthage](https://github.com/Carthage/Carthage) for package management. It's a popular standard choice right now; I don't have an opinionated preference over, say, CocoaPods.

* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to slightly ease the pain of JSON parsing. We had to roll our own a year ago, and easy reflection-based JSON is one of the few things I miss from Javaland. It's naturally overkill in this case, but let's pretend this app is supposed to get larger.

* [RxSwift](https://github.com/ReactiveX/RxSwift) and associated libs for reactivity. I haven't developed a strong preference between Rx* and Reactive*; we sadly couldn't use either in our last app, but this has been a great opportunity to exercise one of them a little.

* [SwiftLint](https://github.com/realm/SwiftLint) is run if installed; always handy to have something to yell at you.

# Misc Remarks

Being time-constrained, I'd like to acknowledge a few points of good app structure that aren't present here:

* Protocols aren't used to ease dependency stubbing

* UI tests are a very useful and totally absent tool!

* URL construction by string interpolation isn't a great generalizeable pattern.

* External URLs of things like Geonames shouldn't be hardcoded in source code.
