//
//  CCLRequestReplayProtocol.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestReplayProtocol.h"
#import "CCLRequestRecording.h"
#import "CCLRequestReplayManager.h"


@implementation CCLRequestReplayProtocol

static CCLRequestReplayManager *_manager;

+ (CCLRequestReplayManager *)manager {
    return _manager;
}

+ (void)setManager:(CCLRequestReplayManager *)manager {
    _manager = manager;
}

+ (CCLRequestRecording *)recordingForRequest:(NSURLRequest *)request {
    if (_manager) {
        for (CCLRequestRecording *recording in [_manager recordings]) {
            NSURLRequest *recordedRequest = [recording request];

            if ([[recordedRequest URL] isEqual:[request URL]]) {
                return recording;
            }
        }
    }

    return nil;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [self recordingForRequest:request] != nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    CCLRequestRecording *recording = [[self class] recordingForRequest:[self request]];

    if ([recording error]) {
        [[self client] URLProtocol:self didFailWithError:[recording error]];
    } else {
        [[self client] URLProtocol:self didReceiveResponse:[recording response] cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        if ([recording data]) {
            [[self client] URLProtocol:self didLoadData:[recording data]];
        }

        [[self client] URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading {
    ;
}

@end
