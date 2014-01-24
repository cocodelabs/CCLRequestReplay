//
//  CCLRequestReplayProtocol.m
//  CCLRequestReplay
//
//  Created by Kyle Fuller on 22/01/2014.
//  Copyright (c) 2013 Cocode LTD. All rights reserved.
//

#import "CCLRequestReplayProtocol.h"
#import "CCLRequestRecording.h"


@implementation CCLRequestReplayProtocol

static NSMutableSet *_managers;

+ (NSMutableSet *)managers {
    return _managers;
}

+ (void)addManager:(CCLRequestReplayManager *)manager {
    if (_managers == nil) {
        [NSURLProtocol registerClass:[CCLRequestRecording class]];
        _managers = [NSMutableSet new];
    }

    [_managers addObject:manager];
}

+ (void)removeManager:(CCLRequestReplayManager *)manager {
    [_managers removeObject:manager];
}

+ (CCLRequestRecording *)recordingForRequest:(NSURLRequest *)request {
    if (_managers) {
        for (CCLRequestReplayManager *manager in _managers) {
            for (CCLRequestRecording *recording in [manager recordings]) {
                NSURLRequest *recordedRequest = [recording request];

                if ([[recordedRequest URL] isEqual:[request URL]]) {
                    return recording;
                }
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

@implementation CCLRequestReplayManager (Replay)

- (void)replay {
    [CCLRequestReplayProtocol addManager:self];
}

- (void)stopReplay {
    [CCLRequestReplayProtocol removeManager:self];
}

@end

