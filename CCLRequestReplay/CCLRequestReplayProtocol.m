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

+ (void)addManager:(CCLRequestReplayManager *)manager {
    if (_managers == nil) {
        [NSURLProtocol registerClass:[CCLRequestReplayProtocol class]];
        _managers = [NSMutableSet new];
    }

    [_managers addObject:manager];
}

+ (void)removeManager:(CCLRequestReplayManager *)manager {
    [_managers removeObject:manager];

    if (_managers && [_managers count] == 0) {
        [NSURLProtocol unregisterClass:[CCLRequestReplayProtocol class]];
        _managers = nil;
    }
}

+ (id<CCLRequestRecordingProtocol>)recordingForRequest:(NSURLRequest *)request {
    if (_managers) {
        for (CCLRequestReplayManager *manager in _managers) {
            for (id<CCLRequestRecordingProtocol> recording in [manager recordings]) {
                if ([recording matchesRequest:request]) {
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
    id<CCLRequestRecordingProtocol> recording = [[self class] recordingForRequest:[self request]];

    NSError *error = [recording errorForRequest:[self request]];

    if (error) {
        [[self client] URLProtocol:self didFailWithError:error];
    } else {
        NSURLResponse *response = [recording responseForRequest:[self request]];
        NSData *data = [recording dataForRequest:[self request]];

        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];

        if (data) {
            [[self client] URLProtocol:self didLoadData:data];
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

