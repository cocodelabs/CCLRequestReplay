# CCLRequestReplay

[![Build Status](https://travis-ci.org/cocodelabs/CCLRequestReplay.png?branch=master)](https://travis-ci.org/cocodelabs/CCLRequestReplay)

CCLRequestReplay is greatly inspired by VCRURLConnection, however it supports
creating a recording purely from code instead of having to actually record the
requests manually and store them in a json file.

## Recording

```objective-c
CCLRequestReplayManager *manager = [[CCLRequestReplayManager alloc] init];
[manager record];

/* Make an NSURLConnection */

[manager stopRecording];
```

## Re-playing

```objective-c
[manager replay];

/* Make an NSURLConnection, it will be served from the manager */

[manager stopReplay];
```

