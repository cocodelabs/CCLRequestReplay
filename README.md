# CCLRequestReplay

[![Build Status](https://travis-ci.org/cocodelabs/CCLRequestReplay.png?branch=master)](https://travis-ci.org/cocodelabs/CCLRequestReplay)

CCLRequestReplay is greatly inspired by VCRURLConnection, however it supports
creating a recording purely from code instead of having to actually record the
requests manually and store them in a json file. It also supports using [API
Blueprint](http://apiblueprint.org/)'s directly so you can write your iOS and
OS X tests directly to your API specification without writing any extra code.

## Usage

### Recording

```objective-c
CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];
[manager record];

/* Make an NSURLConnection */

[manager stopRecording];
```

### Re-playing

```objective-c
[manager replay];

/* Make an NSURLConnection, it will be served from the manager */

[manager stopReplay];
```

### API Blueprint

To use CCLRequestReplay with API Blueprint, first you will need to convert your
API Blueprint file from Markdown to JSON. This process can be done with
[Snow Crash](https://github.com/apiaryio/snowcrash). Once installed, the
conversion can be done by invoking it with your Markdown file as follows.

```bash
$ snowcrash -o PalaverTests/Fixtures/palaver.apib.json -f json palaver-api-docs/palaver.apib
```

Then simple add your JSON file to your bundle so you can pull it out in your
tests using the following:

```objective-c
NSURL *blueprintURL = [[NSBundle mainBundle] URLForResource:@"fitnessfirst.apib" withExtension:@"json"];
CCLRequestReplayManager *replayManager = [CCLRequestReplayManager managerFromBlueprintURL:blueprintURL error:nil];
[replayManager replay];
```

Be sure to keep the manager alive across all your tests that need it.

## Installation

Installation is simple, add the following to your Podfile:

```ruby
pod 'CCLRequestReplay', :git => 'https://github.com/cocodelabs/CCLRequestReplay'
```

## License

CCLRequestReplay is released under the BSD license. See [LICENSE](LICENSE).

