# CDZLinkOpenManager

[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

CDZLinkOpenManager provides a simple & easy facility for your app's users to select a default alternative browser (Safari, Chrome, 1Password).

As an example, this is used on the Settings screen in my [BuyVM Manager app](https://github.com/cdzombak/BuyVMManager-iOS).

## Installation

Add the dependency to your `Podfile`:

```ruby
platform :ios
pod 'CDZLinkOpenManager'
...
```

Run `pod install` to install the dependencies.

## Usage

Include `CDZLinkOpenManager.h` in whichever files you'd like to use the library. This header declares several useful class methods. (Most of those are useful when building a browser-picker, but this library already provides a reusable `UIViewController` for choosing a default browser (`CDZBrowserSelectorViewController`).)

These methods are all you need to open links in the user's selected default browser:

```objc
+ (void)openURL:(NSURL *)url;
+ (void)openURLString:(NSString *)urlString;
```

To allow the user to select his default browser, create and present a `CDZBrowserSelectorViewController`. It's prepared for presentation in a popover or just in a standard `UINavigationController`.

```objc
UIViewController *browserSelector = [[CDZBrowserSelectorViewController alloc] init];
[self.navigationController pushViewController:browserSelector animated:YES];
```

This view controller is customizable; see `CDZBrowserSelectorViewController.h` for details and notes.

## Requirements

`CDZLinkOpenManager` requires iOS 5.x+. It might work on iOS 4, but I haven't tested it.


## License

[MIT License](http://http://opensource.org/licenses/mit-license.php). See LICENSE for the full details.

## Author

Chris Dzombak.

* chris@chrisdzombak.net
* [chris.dzombak.name](http://chris.dzombak.name)
* [twitter: @cdzombak](http://twitter.com/cdzombak)
* [ADN: @dzombak](https://alpha.app.net/dzombak/)
