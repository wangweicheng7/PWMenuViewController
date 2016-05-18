# PWMenuViewController

![logo](https://github.com/wangweicheng7/blog/blob/gh-pages/images/logo.png)
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/Paul Wang/PWMenuViewController.svg?style=flat)](https://travis-ci.org/Paul Wang/PWMenuViewController)
[![Version](https://img.shields.io/cocoapods/v/PWMenuViewController.svg?style=flat)](http://cocoapods.org/pods/PWMenuViewController)
[![License](https://img.shields.io/cocoapods/l/PWMenuViewController.svg?style=flat)](http://cocoapods.org/pods/PWMenuViewController)
[![Platform](https://img.shields.io/cocoapods/p/PWMenuViewController.svg?style=flat)](http://cocoapods.org/pods/PWMenuViewController)

## Show
This is a demo.

[![效果图](https://github.com/wangweicheng7/PWMenuViewController/blob/master/demo.gif)](https://github.com/wangweicheng7/PWMenuViewController/blob/master/demo.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
```
iOS 7.O 及以上
```

## Installation

PWMenuViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PWMenuViewController"
```

You can also use through [Cargthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "wangweicheng7/PWMenuViewController" 
```

follow

```
[self.menuTitles addObject:@"夏天来了"];
[self.menuTitles addObject:@"春天去了"];
[self.menuTitles addObject:@"秋天还远"];
[self.menuTitles addObject:@"冬天很冷"];

[self.bottomViews addObject:self.testView];
[self.bottomViews addObject:self.testView1];
[self.bottomViews addObject:self.testView2];
[self.bottomViews addObject:self.testView3];

[self loadSubViews];
```

__tips:the code `[self loadSubViews];` must in the end.__  

## Author

Paul Wang, wang_weicheng@126.com

## License

PWMenuViewController is available under the MIT license. See the LICENSE file for more info.
